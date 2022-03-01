//
//  SetColorView.h
//  NewDemo
//
//  Created by ZCZ on 2021/3/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetColorView : UIView

+ (instancetype)defuatView;

- (void)showColorView:(void(^)(UIColor *))competion;
- (void)hiddenView;
@end

@interface QMSelectColor : QMColorModel

@property (nonatomic, strong) NSArray *nearColors;

@end

NS_ASSUME_NONNULL_END
