//
//  NSAttributedString+QMEmojiExtension.h
//  newDemo
//
//  Created by lishuijiao on 2021/3/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (QMEmojiExtension)

- (NSString *)getRichString;

/// 关键字变色
/// @param sourceString 原数据符串
/// @param sourceColor 原数据颜色
/// @param sourceFont 原数据字号
/// @param keyWordArray 关键词数据
/// @param keyWordColor 关键词颜色
/// @param keyWordFont 关键词字号
+ (NSAttributedString *)colorAttributeString:(NSString *)sourceString sourceSringColor:(UIColor *)sourceColor sourceFont:(UIFont *)sourceFont keyWordArray:(NSArray<NSString *> *)keyWordArray keyWordColor:(UIColor *)keyWordColor keyWordFont:(UIFont *)keyWordFont;
@end

@interface QMTextAttachment : NSTextAttachment

@property(strong, nonatomic) NSString *emojiCode;

@property(assign, nonatomic) CGSize emojiSize;

@end

NS_ASSUME_NONNULL_END
