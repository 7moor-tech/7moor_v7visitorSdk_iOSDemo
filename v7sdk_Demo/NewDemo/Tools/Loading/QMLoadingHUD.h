//
//  QMLoadingHUD.h
//  NewDemo
//
//  Created by ZCZ on 2021/6/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMLoadingHUD : UIView

+ (instancetype)sharedHUD;

+ (void)loading;
- (void)loading;
+ (void)hidden;
- (void)hidden;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
