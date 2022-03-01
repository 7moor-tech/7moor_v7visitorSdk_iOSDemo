//
//  QMCircleView.m
//  NewDemo
//
//  Created by 焦林生 on 2021/10/18.
//

#import "QMCircleView.h"

@implementation QMCircleView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIBezierPath * path = [[UIBezierPath alloc] init];
    [path addArcWithCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) radius:7 startAngle:0.0 endAngle:M_PI*2.0 clockwise:YES];
    path.lineWidth = 2;
    UIColor *color;
    if (QMThemeManager.shared.rightMsgBgColor.hasBeenSetColor) {
        UIColor *bgColor = QMThemeManager.shared.rightMsgBgColor.color;
        if (bgColor) {
            color = bgColor;
        }
    } else {
        color = k_QMRGB(0, 129, 255);
    }
    [color setStroke];
    [path stroke];
}


@end
