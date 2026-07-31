//
//  YDInputFormatterResult.m
//  YDInputFormatter
//
//  Created by Codex on 2026/7/31.
//

#import "YDInputFormatterResult.h"

@implementation YDInputFormatterResult

- (instancetype)initWithFormattedText:(NSString *)formattedText
                              rawText:(NSString *)rawText
                          caretOffset:(NSUInteger)caretOffset {
    self = [super init];
    if (self) {
        _formattedText = [formattedText copy];
        _rawText = [rawText copy];
        _caretOffset = caretOffset;
    }
    return self;
}

@end
