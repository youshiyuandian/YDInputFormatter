//
//  UITextField+YDInputFormatter.h
//  YDInputFormatter
//
//  Created by Codex on 2026/7/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YDInputFormatter;

@interface UITextField (YDInputFormatter)

@property (nullable, nonatomic, strong, readonly) YDInputFormatter *yd_inputFormatter;

- (void)yd_enableFormatter:(nullable YDInputFormatter *)formatter;
- (void)yd_disableFormatter;

- (BOOL)yd_formatWithFormatter:(nullable YDInputFormatter *)formatter
  shouldChangeCharactersInRange:(NSRange)range
              replacementString:(nullable NSString *)string;

- (void)yd_applyFormattingWithFormatter:(nullable YDInputFormatter *)formatter;

@end

NS_ASSUME_NONNULL_END
