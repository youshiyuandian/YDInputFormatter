//
//  ViewController.m
//  YDInputFormatter
//
//  Created by zuuuxi on 2026/7/31.
//

#import "ViewController.h"

#import "UITextField+YDInputFormatter.h"
#import "YDInputFormatter.h"

@interface ViewController ()

- (UIView *)demoSectionWithTitle:(NSString *)title
                          detail:(NSString *)detail
                     placeholder:(NSString *)placeholder
                        rawValue:(NSString *)rawValue
                    keyboardType:(UIKeyboardType)keyboardType
             autocapitalization:(UITextAutocapitalizationType)autocapitalization
                       formatter:(YDInputFormatter *)formatter;
- (UILabel *)titleLabelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;
- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
                                  rawValue:(NSString *)rawValue
                              keyboardType:(UIKeyboardType)keyboardType
                       autocapitalization:(UITextAutocapitalizationType)autocapitalization
                                 formatter:(YDInputFormatter *)formatter;
- (YDInputFormatter *)bankCardFormatter;
- (YDInputFormatter *)phoneFormatter;
- (YDInputFormatter *)identityFormatter;
- (YDInputFormatter *)licenseFormatter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YDInputFormatter";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];

    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.translatesAutoresizingMaskIntoConstraints = NO;
    contentStack.axis = UILayoutConstraintAxisVertical;
    contentStack.spacing = 20.0;
    [scrollView addSubview:contentStack];

    UILabel *titleLabel = [self titleLabelWithText:@"YDInputFormatter Demo"
                                              font:[UIFont boldSystemFontOfSize:28.0]
                                             color:[UIColor labelColor]];
    UILabel *descriptionLabel = [self titleLabelWithText:@"支持任意分组、separator、光标恢复、粘贴、中间插入、删除 separator 和中文输入法收起后的自动格式化。"
                                                    font:[UIFont systemFontOfSize:15.0]
                                                   color:[UIColor secondaryLabelColor]];
    descriptionLabel.numberOfLines = 0;

    [contentStack addArrangedSubview:titleLabel];
    [contentStack addArrangedSubview:descriptionLabel];
    [contentStack addArrangedSubview:[self demoSectionWithTitle:@"银行卡"
                                                         detail:@"4-4-4-4 分组，空格分隔。"
                                                    placeholder:@"6222 0212 3456 7890"
                                                       rawValue:@"6222021234567890"
                                                   keyboardType:UIKeyboardTypeNumberPad
                                            autocapitalization:UITextAutocapitalizationTypeNone
                                                      formatter:[self bankCardFormatter]]];
    [contentStack addArrangedSubview:[self demoSectionWithTitle:@"手机号"
                                                         detail:@"3-4-4 分组，支持粘贴整串手机号。"
                                                    placeholder:@"138 1234 5678"
                                                       rawValue:@"13812345678"
                                                   keyboardType:UIKeyboardTypeNumberPad
                                            autocapitalization:UITextAutocapitalizationTypeNone
                                                      formatter:[self phoneFormatter]]];
    [contentStack addArrangedSubview:[self demoSectionWithTitle:@"身份证"
                                                         detail:@"6-8-4 分组，末位支持 X/x。"
                                                    placeholder:@"110101 19900101 123X"
                                                       rawValue:@"11010119900101123X"
                                                   keyboardType:UIKeyboardTypeASCIICapable
                                            autocapitalization:UITextAutocapitalizationTypeAllCharacters
                                                      formatter:[self identityFormatter]]];
    [contentStack addArrangedSubview:[self demoSectionWithTitle:@"License Key"
                                                         detail:@"5-5-5 分组，使用 - 分隔。"
                                                    placeholder:@"ABCDE-12345-FGHIJ"
                                                       rawValue:@"ABCDE12345FGHIJ"
                                                   keyboardType:UIKeyboardTypeASCIICapable
                                            autocapitalization:UITextAutocapitalizationTypeAllCharacters
                                                      formatter:[self licenseFormatter]]];

    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:safeArea.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [contentStack.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor constant:24.0],
        [contentStack.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor constant:20.0],
        [contentStack.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor constant:-20.0],
        [contentStack.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor constant:-24.0],
        [contentStack.widthAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.widthAnchor constant:-40.0],
    ]];
}

- (UIView *)demoSectionWithTitle:(NSString *)title
                          detail:(NSString *)detail
                     placeholder:(NSString *)placeholder
                        rawValue:(NSString *)rawValue
                    keyboardType:(UIKeyboardType)keyboardType
             autocapitalization:(UITextAutocapitalizationType)autocapitalization
                       formatter:(YDInputFormatter *)formatter {
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    container.layer.cornerRadius = 16.0;

    UIStackView *stack = [[UIStackView alloc] init];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 10.0;
    [container addSubview:stack];

    UILabel *titleLabel = [self titleLabelWithText:title
                                              font:[UIFont boldSystemFontOfSize:18.0]
                                             color:[UIColor labelColor]];
    UILabel *detailLabel = [self titleLabelWithText:detail
                                               font:[UIFont systemFontOfSize:13.0]
                                              color:[UIColor secondaryLabelColor]];
    detailLabel.numberOfLines = 0;

    UITextField *textField = [self textFieldWithPlaceholder:placeholder
                                                    rawValue:rawValue
                                                keyboardType:keyboardType
                                         autocapitalization:autocapitalization
                                                   formatter:formatter];

    [stack addArrangedSubview:titleLabel];
    [stack addArrangedSubview:detailLabel];
    [stack addArrangedSubview:textField];

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:container.topAnchor constant:16.0],
        [stack.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:16.0],
        [stack.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-16.0],
        [stack.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:-16.0],
    ]];

    return container;
}

- (UILabel *)titleLabelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.font = font;
    label.textColor = color;
    return label;
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
                                  rawValue:(NSString *)rawValue
                              keyboardType:(UIKeyboardType)keyboardType
                       autocapitalization:(UITextAutocapitalizationType)autocapitalization
                                 formatter:(YDInputFormatter *)formatter {
    UITextField *textField = [[UITextField alloc] init];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.placeholder = placeholder;
    textField.text = rawValue;
    textField.keyboardType = keyboardType;
    textField.autocapitalizationType = autocapitalization;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.smartInsertDeleteType = UITextSmartInsertDeleteTypeNo;
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont monospacedDigitSystemFontOfSize:12.0 weight:UIFontWeightRegular];
    textField.backgroundColor = [UIColor tertiarySystemGroupedBackgroundColor];
    [textField.heightAnchor constraintEqualToConstant:46.0].active = YES;
    [textField yd_enableFormatter:formatter];
    return textField;
}

- (YDInputFormatter *)bankCardFormatter {
    YDInputFormatter *formatter = [[YDInputFormatter alloc] init];
    formatter.separator = @" ";
    formatter.prefixGroups = @[@4];
    formatter.repeatGroupLength = 4;
    formatter.maxLength = 30;
    return formatter;
}

- (YDInputFormatter *)phoneFormatter {
    YDInputFormatter *formatter = [[YDInputFormatter alloc] init];
    formatter.separator = @" ";
    formatter.prefixGroups = @[@3, @4];
    formatter.repeatGroupLength = 4;
    formatter.maxLength = 11;
    return formatter;
}

- (YDInputFormatter *)identityFormatter {
    YDInputFormatter *formatter = [[YDInputFormatter alloc] init];
    formatter.separator = @" ";
    formatter.prefixGroups = @[@6, @8];
    formatter.repeatGroupLength = 4;
    formatter.maxLength = 18;
    formatter.filter = ^BOOL(unichar character) {
        if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:character]) {
            return YES;
        }
        return character == 'X' || character == 'x';
    };
    return formatter;
}

- (YDInputFormatter *)licenseFormatter {
    YDInputFormatter *formatter = [[YDInputFormatter alloc] init];
    formatter.separator = @"-";
    formatter.prefixGroups = @[@5];
    formatter.repeatGroupLength = 5;
    formatter.maxLength = 15;
    formatter.filter = ^BOOL(unichar character) {
        return [[NSCharacterSet alphanumericCharacterSet] characterIsMember:character];
    };
    return formatter;
}

@end
