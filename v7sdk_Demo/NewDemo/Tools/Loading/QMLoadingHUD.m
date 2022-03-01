//
//  QMLoadingHUD.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/4.
//

#import "QMLoadingHUD.h"

@interface QMLoadingHUD () <CAAnimationDelegate>

@end

@implementation QMLoadingHUD

+ (instancetype)sharedHUD {
    UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
    keyWindow.windowLevel = UIWindowLevelAlert;
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow * tmpWin in windows) {
        if (tmpWin.windowLevel > keyWindow.windowLevel) {
            keyWindow.windowLevel = tmpWin.windowLevel;
        }
    }

    QMLoadingHUD *hud = [keyWindow viewWithTag:500];
    if (!hud) {
        hud = [[QMLoadingHUD alloc] initWithFrame:keyWindow.bounds];
        hud.tag = 500;
        hud.backgroundColor = k_qm_RGBA(41, 41, 41, 0.5);
        [hud setupSubviews];
        [keyWindow addSubview:hud];
    }
    return hud;
}

- (void)setupSubviews {
    
    CGFloat width = 90;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - width/2.0, CGRectGetMidY(self.frame) - width/2.0 - 20, width, width)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 6;
    bgView.tag = 100;
    [self addSubview:bgView];
    
    
    CGFloat subWidth = 20;
    
    UIView *redV = [[UIView alloc] initWithFrame:CGRectMake(15, width/2.0 - subWidth/2.0, subWidth, subWidth)];
    redV.backgroundColor =
    redV.backgroundColor = [UIColor colorWithRed:0/255.0 green:129/255.0 blue:255/255.0 alpha:1.0];
    
    if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
        redV.backgroundColor = QMThemeManager.shared.mainColorModel.color;
    }
    redV.tag = 200;
    redV.layer.cornerRadius = subWidth/2.0;
    redV.clipsToBounds = YES;
    [bgView addSubview:redV];
    
    UIView *greendV = [[UIView alloc] initWithFrame:CGRectMake(width - 15 - subWidth, width/2.0 - subWidth/2.0, subWidth, subWidth)];
    if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
        greendV.backgroundColor = [UIColor colorWithRed:QMThemeManager.shared.mainColorModel.red/255.0 green:QMThemeManager.shared.mainColorModel.green/255.0 blue:QMThemeManager.shared.mainColorModel.blue/255.0 alpha:0.5];
    } else {
        greendV.backgroundColor = [UIColor colorWithRed:0/255.0 green:129/255.0 blue:255/255.0 alpha:.4];
    }
    greendV.tag = 201;
    greendV.layer.cornerRadius = subWidth/2.0;
    greendV.clipsToBounds = YES;
    [bgView addSubview:greendV];
    
    [bgView bringSubviewToFront:redV];
}

+ (void)loading {
    QMLoadingHUD *hud = [self sharedHUD];
    [hud loading];
}

- (void)loading {
    
    float duration = 0.8;
    
    UIView *bgView = [self viewWithTag:100];
    
    UIView *redV = [bgView viewWithTag:200];
    CGFloat subWidth = CGRectGetWidth(redV.frame);
    CGFloat x = redV.frame.origin.x + subWidth/2.0;
    CGFloat y = redV.center.y;
    
    CGFloat pathWidth = CGRectGetWidth(bgView.frame) - 30 - subWidth;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value01 = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    NSValue *value02 = [NSValue valueWithCGPoint:CGPointMake(x + pathWidth, y)];
//    NSValue *value03 = [NSValue valueWithCGPoint:CGPointMake(x, y)];
//    NSValue *value04 = [NSValue valueWithCGPoint:CGPointMake(x + pathWidth, y)];
    animation.values = @[value01,value02];
    animation.repeatCount = MAXFLOAT;
    //设置是否原路返回默认为不
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = duration;
    [redV.layer addAnimation:animation forKey:@"CAKeyframeAnimation"];
    
    
    UIView *greendV = [bgView viewWithTag:201];

    CGFloat x1 = greendV.frame.origin.x + subWidth/2.0;
    
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value11 = [NSValue valueWithCGPoint:CGPointMake(x1, y)];
    NSValue *value12 = [NSValue valueWithCGPoint:CGPointMake(x1 - pathWidth, y)];
//    NSValue *value13 = [NSValue valueWithCGPoint:CGPointMake(x1 - subWidth, y)];
//    NSValue *value14 = [NSValue valueWithCGPoint:CGPointMake(x1 - pathWidth - subWidth, y)];

    animation1.values = @[value11,value12];
    animation1.repeatCount = MAXFLOAT;
    //设置是否原路返回默认为不
    animation1.autoreverses = YES;
    animation1.removedOnCompletion = NO;
    animation1.fillMode = kCAFillModeForwards;
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation1.duration = duration;
    [greendV.layer addAnimation:animation1 forKey:@"CAKeyframeAnimation1"];

}

- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"---anim----");
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"+++-anim-++++");
}

- (void)hidden {
    UIWindow *keyWindow = (UIWindow *)self.superview;
    if (keyWindow.isKeyWindow) {
        keyWindow.windowLevel = UIWindowLevelNormal;
    }
    [self removeFromSuperview];
}

+ (void)hidden {
    QMLoadingHUD *hud = [self sharedHUD];
    [hud hidden];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
