//
//  UIImage+Clip.h
//  CeTest
//
//  Created by ZCZ on 2021/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Clip)

- (NSArray<UIImage *>*)clipImage:(CGSize)clipSize;

+ (UIImage *)convertViewToImage:(UIView*)view;


@end

NS_ASSUME_NONNULL_END
