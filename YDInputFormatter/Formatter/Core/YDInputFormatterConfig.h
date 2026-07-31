//
//  YDInputFormatterConfig.h
//  YDInputFormatter
//
//  Created by Codex on 2026/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^YDInputFormatterCharacterFilter)(unichar character);

@interface YDInputFormatterConfig : NSObject <NSCopying>

@property (nonatomic, copy) NSArray<NSNumber *> *prefixGroups;
@property (nonatomic, assign) NSUInteger repeatGroupLength;
@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, copy) NSString *separator;
@property (nullable, nonatomic, copy) YDInputFormatterCharacterFilter filter;

@end

NS_ASSUME_NONNULL_END
