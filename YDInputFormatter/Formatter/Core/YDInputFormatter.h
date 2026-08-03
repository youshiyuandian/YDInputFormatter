//
//  YDInputFormatter.h
//  YDInputFormatter
//
//  Created by Codex on 2026/7/31.
//

#import <Foundation/Foundation.h>

#import "YDInputFormatterConfig.h"
#import "YDInputFormatterResult.h"

NS_ASSUME_NONNULL_BEGIN

@class YDInputFormatterEngine;

@interface YDInputFormatter : NSObject

@property (nonatomic, strong, readonly) YDInputFormatterConfig *config;
@property (nonatomic, copy) NSArray<NSNumber *> *prefixGroups;
@property (nonatomic, assign) NSUInteger repeatGroupLength;
@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, copy) NSString *separator;
@property (nullable, nonatomic, copy) YDInputFormatterCharacterFilter filter;

- (YDInputFormatterResult *)applyEditToText:(nullable NSString *)text
                                      range:(NSRange)range
                                replacement:(nullable NSString *)replacement;

- (YDInputFormatterResult *)formatText:(nullable NSString *)text
                           caretOffset:(NSUInteger)caretOffset;

- (NSString *)formattedTextFromText:(nullable NSString *)text;

@end

NS_ASSUME_NONNULL_END
