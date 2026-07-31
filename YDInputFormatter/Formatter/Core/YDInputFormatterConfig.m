//
//  YDInputFormatterConfig.m
//  YDInputFormatter
//
//  Created by Codex on 2026/7/31.
//

#import "YDInputFormatterConfig.h"

@implementation YDInputFormatterConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _prefixGroups = @[];
        _repeatGroupLength = 0;
        _maxLength = 0;
        _separator = @"";
        _filter = ^BOOL(unichar character) {
            return [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:character];
        };
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    YDInputFormatterConfig *config = [[[self class] allocWithZone:zone] init];
    config.prefixGroups = self.prefixGroups;
    config.repeatGroupLength = self.repeatGroupLength;
    config.maxLength = self.maxLength;
    config.separator = self.separator;
    config.filter = self.filter;
    return config;
}

@end
