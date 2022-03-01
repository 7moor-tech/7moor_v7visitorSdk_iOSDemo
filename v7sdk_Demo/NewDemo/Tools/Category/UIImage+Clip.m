//
//  UIImage+Clip.m
//  CeTest
//
//  Created by ZCZ on 2021/1/25.
//

#import "UIImage+Clip.h"

@implementation UIImage (Clip)

- (NSArray *)clipImage:(CGSize)clipSize {
    NSMutableArray *arr = [NSMutableArray array];

    CGRect beginRect = CGRectMake(0, 0, clipSize.width, clipSize.height);
    for (int i = 0; i < 53; i ++) {
        if (beginRect.origin.x + clipSize.width > self.size.width) {
            beginRect.origin.x = 0;
            beginRect.origin.y += clipSize.height;
        }
        
        if (beginRect.origin.y > self.size.height) {
            break;
        }
        
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, beginRect);

        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextDrawImage(context, beginRect, imageRef);
        UIImage * newImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        UIGraphicsEndImageContext();
        beginRect.origin.x += clipSize.width;
        if (newImage != nil) {
            [arr addObject:newImage];
        }
    }
    
    return arr;
    
}

+ (UIImage *)convertViewToImage:(UIView*)view {
   
    CGSize size = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
