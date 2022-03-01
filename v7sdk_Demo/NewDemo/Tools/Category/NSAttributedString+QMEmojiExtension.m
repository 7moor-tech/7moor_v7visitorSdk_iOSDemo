//
//  NSAttributedString+QMEmojiExtension.m
//  newDemo
//
//  Created by lishuijiao on 2021/3/4.
//

#import "NSAttributedString+QMEmojiExtension.h"

@implementation NSAttributedString (QMEmojiExtension)

- (NSString *)getRichString {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[QMTextAttachment class]]) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((QMTextAttachment *) value).emojiCode];
                          base += ((QMTextAttachment *) value).emojiCode.length - 1;
                      }
                  }];
    
    return plainString;
}

+ (NSAttributedString *)colorAttributeString:(NSString *)sourceString sourceSringColor:(UIColor *)sourceColor sourceFont:(UIFont *)sourceFont keyWordArray:(NSArray<NSString *> *)keyWordArray keyWordColor:(UIColor *)keyWordColor keyWordFont:(UIFont *)keyWordFont{
    if (sourceString == nil || ![sourceString isKindOfClass:[NSString class]]) {
        sourceString = @"";
    }
    NSMutableArray *muKeyWordsArr;
    if (keyWordArray == nil) {
        muKeyWordsArr = [NSMutableArray arrayWithCapacity:0];
    }else{
        muKeyWordsArr = keyWordArray.mutableCopy;
    }
    if (sourceColor == nil) {
        sourceColor = [UIColor blackColor];
    }
    if (keyWordColor == nil) {
        keyWordColor = [UIColor blackColor];
    }
    if (sourceFont == nil) {
        sourceFont = [UIFont systemFontOfSize:15];
    }
    if (keyWordFont == nil) {
        keyWordFont = [UIFont systemFontOfSize:15];
    }
    NSMutableAttributedString *attributeContent;
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attriDic = @{NSFontAttributeName : sourceFont,NSForegroundColorAttributeName : sourceColor,NSParagraphStyleAttributeName : ps};
    attributeContent = [[NSMutableAttributedString alloc] initWithString:sourceString attributes:attriDic];
    [muKeyWordsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *searchKey = (NSString *)obj;
        NSError *error = nil;
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:searchKey options:NSRegularExpressionCaseInsensitive error:&error];
        if (!expression) {
        }else {
            [expression enumerateMatchesInString:sourceString options:NSMatchingReportProgress range:NSMakeRange(0, sourceString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                [attributeContent addAttributes:@{NSFontAttributeName : keyWordFont,NSForegroundColorAttributeName:keyWordColor} range:result.range];
            }];
        }
    }];
    return attributeContent;
}


@end

@implementation QMTextAttachment

@end
