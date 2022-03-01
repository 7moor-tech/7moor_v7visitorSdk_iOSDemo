//
//  UILabel+QMLabel.h
//  NewDemo
//
//  Created by ZCZ on 2021/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (QMLabel)
- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth;
@end

NS_ASSUME_NONNULL_END
