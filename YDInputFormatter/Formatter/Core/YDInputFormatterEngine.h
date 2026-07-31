//
//  YDInputFormatterEngine.h
//  YDInputFormatter
//
//  Created by Codex on 2026/7/31.
//

#import <Foundation/Foundation.h>

@class YDInputFormatterConfig;
@class YDInputFormatterResult;

NS_ASSUME_NONNULL_BEGIN

@interface YDInputFormatterEngine : NSObject

- (YDInputFormatterResult *)applyEditToText:(nullable NSString *)text
                                      range:(NSRange)range
                                replacement:(nullable NSString *)replacement
                                     config:(YDInputFormatterConfig *)config;

- (YDInputFormatterResult *)formatText:(nullable NSString *)text
                           caretOffset:(NSUInteger)caretOffset
                                config:(YDInputFormatterConfig *)config;

@end

NS_ASSUME_NONNULL_END
