//
//  QMConnectStatusView.h
//  NewDemo
//
//  Created by lishuijiao on 2021/6/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMConnectStatusView : UIView

@property (nonatomic, copy) void(^cancelBlock)(void);

@property (nonatomic, copy) void(^reConnectBlock)(void);

@end

NS_ASSUME_NONNULL_END
