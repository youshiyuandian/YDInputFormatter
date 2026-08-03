//
//  UITextField+YDInputFormatter.m
//  YDInputFormatter
//
//  Created by Codex on 2026/7/31.
//

#import "UITextField+YDInputFormatter.h"

#import <objc/runtime.h>

#import "YDInputFormatter.h"

@interface YDTextFieldFormatterController : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, strong) YDInputFormatter *formatter;
@property (nonatomic, weak, nullable) id<UITextFieldDelegate> externalDelegate;
@property (nonatomic, assign) BOOL suppressEditingChanged;
@property (nonatomic, strong, nullable) NSNumber *pendingCaretOffset;

- (instancetype)initWithTextField:(UITextField *)textField formatter:(YDInputFormatter *)formatter;
- (void)applyResult:(YDInputFormatterResult *)result sendEditingChanged:(BOOL)sendEditingChanged;
- (void)refreshFormattingPreservingSelection;

@end

@implementation YDTextFieldFormatterController

- (instancetype)initWithTextField:(UITextField *)textField formatter:(YDInputFormatter *)formatter {
    self = [super init];
    if (self) {
        _textField = textField;
        _formatter = formatter;
    }
    return self;
}

- (void)refreshFormattingPreservingSelection {
    UITextField *textField = self.textField;
    if (textField == nil || self.suppressEditingChanged) {
        return;
    }

    UITextRange *selectedRange = textField.selectedTextRange;
    NSUInteger caretOffset = textField.text.length;
    if (selectedRange != nil) {
        caretOffset = [textField offsetFromPosition:textField.beginningOfDocument
                                         toPosition:selectedRange.start];
    }

    YDInputFormatterResult *result = [self.formatter formatText:textField.text
                                                    caretOffset:caretOffset];
    [self applyResult:result sendEditingChanged:NO];
}

- (void)applyResult:(YDInputFormatterResult *)result sendEditingChanged:(BOOL)sendEditingChanged {
    UITextField *textField = self.textField;
    if (textField == nil) {
        return;
    }

    self.suppressEditingChanged = YES;
    textField.text = result.formattedText;
    self.pendingCaretOffset = @(result.caretOffset);
    [self applyCaretOffset:result.caretOffset];

    if (sendEditingChanged) {
        [textField sendActionsForControlEvents:UIControlEventEditingChanged];
    }
    self.suppressEditingChanged = NO;

    __weak typeof(self) weakSelf = self;
    NSString *expectedText = [result.formattedText copy];
    NSUInteger expectedCaretOffset = result.caretOffset;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UITextField *strongTextField = strongSelf.textField;
        if (strongSelf == nil || strongTextField == nil) {
            return;
        }

        if (strongSelf.pendingCaretOffset.unsignedIntegerValue != expectedCaretOffset) {
            return;
        }

        if (![strongTextField.text isEqualToString:expectedText]) {
            return;
        }

        [strongSelf applyCaretOffset:expectedCaretOffset];
        strongSelf.pendingCaretOffset = nil;
    });
}

- (void)applyCaretOffset:(NSUInteger)caretOffset {
    UITextField *textField = self.textField;
    if (textField == nil) {
        return;
    }

    UITextPosition *position = [textField positionFromPosition:textField.beginningOfDocument
                                                        offset:caretOffset];
    if (position != nil) {
        textField.selectedTextRange = [textField textRangeFromPosition:position toPosition:position];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.externalDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.externalDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.externalDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.externalDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.externalDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.externalDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self refreshFormattingPreservingSelection];
    if ([self.externalDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.externalDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.externalDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)] &&
        ![self.externalDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string]) {
        return NO;
    }

    UITextRange *markedTextRange = textField.markedTextRange;
    UITextPosition *markedTextPosition = markedTextRange.start;
    if (markedTextPosition != nil) {
        return YES;
    }

    YDInputFormatterResult *result = [self.formatter applyEditToText:textField.text
                                                               range:range
                                                         replacement:string];
    [self applyResult:result sendEditingChanged:YES];
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.externalDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.externalDelegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.externalDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.externalDelegate textFieldShouldReturn:textField];
    }
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if ([self.externalDelegate respondsToSelector:@selector(textFieldDidChangeSelection:)]) {
        [self.externalDelegate textFieldDidChangeSelection:textField];
    }
}

- (void)handleEditingChanged:(UITextField *)textField {
    if (self.suppressEditingChanged) {
        return;
    }

    UITextRange *markedTextRange = textField.markedTextRange;
    UITextPosition *markedTextPosition = markedTextRange.start;
    if (markedTextPosition != nil) {
        return;
    }

    [self refreshFormattingPreservingSelection];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.externalDelegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.externalDelegate respondsToSelector:aSelector]) {
        return self.externalDelegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end

static const void *YDInputFormatterControllerKey = &YDInputFormatterControllerKey;

static YDTextFieldFormatterController *YDInputFormatterControllerForTextField(UITextField *textField,
                                                                              YDInputFormatter *formatter) {
    YDTextFieldFormatterController *controller = objc_getAssociatedObject(textField, YDInputFormatterControllerKey);
    if (controller == nil) {
        controller = [[YDTextFieldFormatterController alloc] initWithTextField:textField formatter:formatter];
        objc_setAssociatedObject(textField, YDInputFormatterControllerKey, controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        controller.formatter = formatter;
    }
    return controller;
}

@implementation UITextField (YDInputFormatter)

- (YDInputFormatter *)yd_inputFormatter {
    YDTextFieldFormatterController *controller = objc_getAssociatedObject(self, YDInputFormatterControllerKey);
    return controller.formatter;
}

- (void)yd_enableFormatter:(YDInputFormatter *)formatter {
    if (formatter == nil) {
        [self yd_disableFormatter];
        return;
    }

    YDTextFieldFormatterController *controller = YDInputFormatterControllerForTextField(self, formatter);
    if (self.delegate != controller) {
        controller.externalDelegate = self.delegate;
    }

    [self removeTarget:controller action:@selector(handleEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:controller action:@selector(handleEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.delegate = controller;
    [controller refreshFormattingPreservingSelection];
}

- (void)yd_disableFormatter {
    YDTextFieldFormatterController *controller = objc_getAssociatedObject(self, YDInputFormatterControllerKey);
    if (controller == nil) {
        return;
    }

    [self removeTarget:controller action:@selector(handleEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    if (self.delegate == controller) {
        self.delegate = controller.externalDelegate;
    }
    objc_setAssociatedObject(self, YDInputFormatterControllerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yd_formatWithFormatter:(YDInputFormatter *)formatter
  shouldChangeCharactersInRange:(NSRange)range
              replacementString:(NSString *)string {
    if (formatter == nil) {
        return YES;
    }

    UITextRange *markedTextRange = self.markedTextRange;
    UITextPosition *markedTextPosition = markedTextRange.start;
    if (markedTextPosition != nil) {
        return YES;
    }

    YDTextFieldFormatterController *controller = YDInputFormatterControllerForTextField(self, formatter);
    YDInputFormatterResult *result = [formatter applyEditToText:self.text
                                                         range:range
                                                   replacement:string];
    [controller applyResult:result sendEditingChanged:YES];
    return NO;
}

- (void)yd_setText:(NSString *)text withFormatter:(YDInputFormatter *)formatter {
    self.text = text ?: @"";
    if (formatter == nil) {
        return;
    }

    [self yd_applyFormattingWithFormatter:formatter];
}

- (void)yd_applyFormattingWithFormatter:(YDInputFormatter *)formatter {
    if (formatter == nil) {
        return;
    }

    UITextRange *markedTextRange = self.markedTextRange;
    UITextPosition *markedTextPosition = markedTextRange.start;
    if (markedTextPosition != nil) {
        return;
    }

    YDTextFieldFormatterController *controller = YDInputFormatterControllerForTextField(self, formatter);
    [controller refreshFormattingPreservingSelection];
}

@end
