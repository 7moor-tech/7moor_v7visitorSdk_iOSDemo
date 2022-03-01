//
//  UIImage+Color.h
//  NewDemo
//
//  Created by ZCZ on 2021/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Color)

+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;


@end

NS_ASSUME_NONNULL_END
