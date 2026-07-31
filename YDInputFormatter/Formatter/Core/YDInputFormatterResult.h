//
//  YDInputFormatterResult.h
//  YDInputFormatter
//
//  Created by Codex on 2026/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDInputFormatterResult : NSObject

@property (nonatomic, copy, readonly) NSString *formattedText;
@property (nonatomic, copy, readonly) NSString *rawText;
@property (nonatomic, assign, readonly) NSUInteger caretOffset;

- (instancetype)initWithFormattedText:(NSString *)formattedText
                              rawText:(NSString *)rawText
                          caretOffset:(NSUInteger)caretOffset NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
