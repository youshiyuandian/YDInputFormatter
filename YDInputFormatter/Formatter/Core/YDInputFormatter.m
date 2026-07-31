//
//  YDInputFormatter.m
//  YDInputFormatter
//
//  Created by Codex on 2026/7/31.
//

#import "YDInputFormatter.h"

#import "YDInputFormatterEngine.h"

@interface YDInputFormatter ()

@property (nonatomic, strong) YDInputFormatterConfig *config;
@property (nonatomic, strong) YDInputFormatterEngine *engine;

@end

@implementation YDInputFormatter

- (instancetype)init {
    self = [super init];
    if (self) {
        _config = [[YDInputFormatterConfig alloc] init];
        _engine = [[YDInputFormatterEngine alloc] init];
    }
    return self;
}

- (NSArray<NSNumber *> *)prefixGroups {
    return self.config.prefixGroups;
}

- (void)setPrefixGroups:(NSArray<NSNumber *> *)prefixGroups {
    self.config.prefixGroups = [prefixGroups copy];
}

- (NSUInteger)repeatGroupLength {
    return self.config.repeatGroupLength;
}

- (void)setRepeatGroupLength:(NSUInteger)repeatGroupLength {
    self.config.repeatGroupLength = repeatGroupLength;
}

- (NSUInteger)maxLength {
    return self.config.maxLength;
}

- (void)setMaxLength:(NSUInteger)maxLength {
    self.config.maxLength = maxLength;
}

- (NSString *)separator {
    return self.config.separator;
}

- (void)setSeparator:(NSString *)separator {
    self.config.separator = [separator copy];
}

- (YDInputFormatterCharacterFilter)filter {
    return self.config.filter;
}

- (void)setFilter:(YDInputFormatterCharacterFilter)filter {
    self.config.filter = filter;
}

- (YDInputFormatterResult *)applyEditToText:(NSString *)text
                                      range:(NSRange)range
                                replacement:(NSString *)replacement {
    return [self.engine applyEditToText:text
                                  range:range
                            replacement:replacement
                                 config:self.config];
}

- (YDInputFormatterResult *)formatText:(NSString *)text
                           caretOffset:(NSUInteger)caretOffset {
    return [self.engine formatText:text
                       caretOffset:caretOffset
                            config:self.config];
}

@end
