//
//  UIImage+Color.m
//  NewDemo
//
//  Created by ZCZ on 2021/3/17.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageFromColor:(UIColor *)color {
    return [self imageFromColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
