//
//  UIColor+Hex.h
//  newDemo
//
//  Created by lishuijiao on 2021/2/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///会话页面 light_#EDEDED dark_#141212
static NSString *QMColor_Main_Bg_Light = @"#EDEDED";
static NSString *QMColor_Main_Bg_Dark = @"#141212";




static NSString *QMColor_666666_timeLabel = @"#666666";


@interface UIColor (Hex)

/*
 从十六进制字符串获取颜色，
 color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 默认alpha位1
 **/
+ (UIColor *)colorWithHexString:(NSString *)color;

/*
从十六进制字符串获取颜色，
color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
**/
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
