//
//  ColorCell.h
//  NewDemo
//
//  Created by ZCZ on 2021/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorCell : UICollectionViewCell
- (void)setCellData:(UIColor *)color;
- (UIColor *)getSelectColor;
@end

NS_ASSUME_NONNULL_END
