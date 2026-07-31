//
//  YDInputFormatterEngine.m
//  YDInputFormatter
//
//  Created by Codex on 2026/7/31.
//

#import "YDInputFormatterEngine.h"

#import "YDInputFormatterConfig.h"
#import "YDInputFormatterResult.h"

static NSRange YDInputFormatterClampRange(NSRange range, NSUInteger length) {
    NSUInteger location = MIN(range.location, length);
    NSUInteger maxLength = length - location;
    NSUInteger clampedLength = MIN(range.length, maxLength);
    return NSMakeRange(location, clampedLength);
}

static BOOL YDInputFormatterAcceptsCharacter(unichar character, YDInputFormatterConfig *config) {
    return config.filter ? config.filter(character) : YES;
}

static NSString *YDInputFormatterFilterText(NSString *text, YDInputFormatterConfig *config) {
    NSMutableString *result = [NSMutableString string];
    NSUInteger length = text.length;
    for (NSUInteger index = 0; index < length; index++) {
        unichar character = [text characterAtIndex:index];
        if (YDInputFormatterAcceptsCharacter(character, config)) {
            [result appendFormat:@"%C", character];
        }
    }
    return result;
}

static NSString *YDInputFormatterTruncateRawText(NSString *rawText, YDInputFormatterConfig *config) {
    if (config.maxLength == 0 || rawText.length <= config.maxLength) {
        return rawText;
    }
    return [rawText substringToIndex:config.maxLength];
}

static NSUInteger YDInputFormatterAcceptedCountBeforeOffset(NSString *text, NSUInteger offset, YDInputFormatterConfig *config) {
    NSUInteger safeOffset = MIN(offset, text.length);
    NSUInteger count = 0;
    for (NSUInteger index = 0; index < safeOffset; index++) {
        if (YDInputFormatterAcceptsCharacter([text characterAtIndex:index], config)) {
            count += 1;
        }
    }
    return count;
}

static NSUInteger YDInputFormatterAcceptedCountInRange(NSString *text, NSRange range, YDInputFormatterConfig *config) {
    NSUInteger count = 0;
    NSUInteger end = NSMaxRange(range);
    for (NSUInteger index = range.location; index < end; index++) {
        if (YDInputFormatterAcceptsCharacter([text characterAtIndex:index], config)) {
            count += 1;
        }
    }
    return count;
}

static NSArray<NSNumber *> *YDInputFormatterSanitizedPrefixGroups(NSArray<NSNumber *> *prefixGroups) {
    NSMutableArray<NSNumber *> *groups = [NSMutableArray array];
    for (NSNumber *group in prefixGroups) {
        NSUInteger value = group.unsignedIntegerValue;
        if (value > 0) {
            [groups addObject:@(value)];
        }
    }
    return groups;
}

static NSString *YDInputFormatterBuildFormattedText(NSString *rawText,
                                                    YDInputFormatterConfig *config,
                                                    NSMutableArray<NSNumber *> *offsetMap,
                                                    NSMutableArray<NSNumber *> *contentOffsetMap) {
    [offsetMap removeAllObjects];
    [contentOffsetMap removeAllObjects];
    [offsetMap addObject:@0];
    [contentOffsetMap addObject:@0];

    if (rawText.length == 0) {
        return @"";
    }

    NSArray<NSNumber *> *prefixGroups = YDInputFormatterSanitizedPrefixGroups(config.prefixGroups ?: @[]);
    NSString *separator = config.separator ?: @"";
    NSMutableString *formattedText = [NSMutableString string];

    NSUInteger prefixIndex = 0;
    NSUInteger currentGroupLength = 0;

    if (prefixGroups.count > 0) {
        currentGroupLength = prefixGroups.firstObject.unsignedIntegerValue;
    } else if (config.repeatGroupLength > 0) {
        currentGroupLength = config.repeatGroupLength;
    } else {
        currentGroupLength = rawText.length;
    }

    NSUInteger currentGroupCount = 0;

    for (NSUInteger index = 0; index < rawText.length; index++) {
        [formattedText appendFormat:@"%C", [rawText characterAtIndex:index]];
        currentGroupCount += 1;
        NSUInteger contentOffset = formattedText.length;

        BOOL hasMoreCharacters = (index + 1) < rawText.length;
        if (hasMoreCharacters && currentGroupCount == currentGroupLength) {
            if (separator.length > 0) {
                [formattedText appendString:separator];
            }

            currentGroupCount = 0;
            if (prefixIndex + 1 < prefixGroups.count) {
                prefixIndex += 1;
                currentGroupLength = [prefixGroups[prefixIndex] unsignedIntegerValue];
            } else if (config.repeatGroupLength > 0) {
                currentGroupLength = config.repeatGroupLength;
            } else {
                currentGroupLength = rawText.length;
            }
        }

        [offsetMap addObject:@(formattedText.length)];
        [contentOffsetMap addObject:@(contentOffset)];
    }

    return formattedText;
}

@interface YDInputFormatterEngine ()

- (YDInputFormatterResult *)resultWithRawText:(NSString *)rawText
                               caretRawOffset:(NSUInteger)caretRawOffset
                           useContentOffset:(BOOL)useContentOffset
                                       config:(YDInputFormatterConfig *)config;

@end

@implementation YDInputFormatterEngine

- (YDInputFormatterResult *)applyEditToText:(NSString *)text
                                      range:(NSRange)range
                                replacement:(NSString *)replacement
                                     config:(YDInputFormatterConfig *)config {
    NSString *sourceText = text ?: @"";
    NSString *sourceReplacement = replacement ?: @"";
    NSRange safeRange = YDInputFormatterClampRange(range, sourceText.length);

    NSString *rawText = YDInputFormatterTruncateRawText(YDInputFormatterFilterText(sourceText, config), config);
    NSUInteger startRawOffset = MIN(YDInputFormatterAcceptedCountBeforeOffset(sourceText, safeRange.location, config), rawText.length);
    NSUInteger endRawOffset = MIN(YDInputFormatterAcceptedCountBeforeOffset(sourceText, NSMaxRange(safeRange), config), rawText.length);

    NSString *deletedText = [sourceText substringWithRange:safeRange];
    BOOL deletingSeparatorOnly = (sourceReplacement.length == 0 &&
                                  safeRange.length == 1 &&
                                  YDInputFormatterAcceptedCountInRange(deletedText, NSMakeRange(0, deletedText.length), config) == 0 &&
                                  startRawOffset == endRawOffset &&
                                  startRawOffset > 0);
    if (deletingSeparatorOnly) {
        startRawOffset -= 1;
    }

    NSString *replacementRawText = YDInputFormatterFilterText(sourceReplacement, config);
    NSUInteger removedLength = endRawOffset - startRawOffset;
    NSUInteger remainingLength = rawText.length - removedLength;
    NSUInteger allowedInsertionLength = NSUIntegerMax;
    if (config.maxLength > 0) {
        allowedInsertionLength = (config.maxLength > remainingLength) ? (config.maxLength - remainingLength) : 0;
    }
    if (replacementRawText.length > allowedInsertionLength) {
        replacementRawText = [replacementRawText substringToIndex:allowedInsertionLength];
    }

    NSMutableString *nextRawText = [NSMutableString string];
    [nextRawText appendString:[rawText substringToIndex:startRawOffset]];
    [nextRawText appendString:replacementRawText];
    [nextRawText appendString:[rawText substringFromIndex:endRawOffset]];

    NSUInteger caretRawOffset = startRawOffset + replacementRawText.length;
    BOOL useContentOffset = replacementRawText.length > 1;
    return [self resultWithRawText:nextRawText
                    caretRawOffset:caretRawOffset
                  useContentOffset:useContentOffset
                            config:config];
}

- (YDInputFormatterResult *)formatText:(NSString *)text
                           caretOffset:(NSUInteger)caretOffset
                                config:(YDInputFormatterConfig *)config {
    NSString *sourceText = text ?: @"";
    NSUInteger safeCaretOffset = MIN(caretOffset, sourceText.length);
    NSString *rawText = YDInputFormatterTruncateRawText(YDInputFormatterFilterText(sourceText, config), config);
    NSUInteger caretRawOffset = MIN(YDInputFormatterAcceptedCountBeforeOffset(sourceText, safeCaretOffset, config), rawText.length);
    return [self resultWithRawText:rawText
                    caretRawOffset:caretRawOffset
                  useContentOffset:NO
                            config:config];
}

- (YDInputFormatterResult *)resultWithRawText:(NSString *)rawText
                               caretRawOffset:(NSUInteger)caretRawOffset
                           useContentOffset:(BOOL)useContentOffset
                                       config:(YDInputFormatterConfig *)config {
    NSString *safeRawText = YDInputFormatterTruncateRawText(rawText ?: @"", config);
    NSUInteger safeCaretRawOffset = MIN(caretRawOffset, safeRawText.length);

    NSMutableArray<NSNumber *> *offsetMap = [NSMutableArray array];
    NSMutableArray<NSNumber *> *contentOffsetMap = [NSMutableArray array];
    NSString *formattedText = YDInputFormatterBuildFormattedText(safeRawText, config, offsetMap, contentOffsetMap);
    NSArray<NSNumber *> *targetOffsetMap = useContentOffset ? contentOffsetMap : offsetMap;
    NSUInteger caretOffset = [targetOffsetMap[safeCaretRawOffset] unsignedIntegerValue];

    return [[YDInputFormatterResult alloc] initWithFormattedText:formattedText
                                                         rawText:safeRawText
                                                     caretOffset:caretOffset];
}

@end
