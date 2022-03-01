//
//  NSObject+QMUIKit_OC.m
//  IMSDK
//
//  Created by 焦林生 on 2021/10/20.
//

#import "NSObject+QMUIKit_OC.h"
#import <objc/runtime.h>

@implementation NSObject (QMUIKit_OC)

@end


@implementation UIButton (QMCategory)

static char MSExtendEdgeKey;

- (void)layoutButtonWithEdgeInsetsStyle:(QMButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space {
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    /**
     MKButtonEdgeInsetsStyleTop, // image在上，label在下
     MKButtonEdgeInsetsStyleLeft, // image在左，label在右
     MKButtonEdgeInsetsStyleBottom, // image在下，label在上
     MKButtonEdgeInsetsStyleRight // image在右，label在左
     */
    switch (style) {
        case QMButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case QMButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case QMButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case QMButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}


- (void)extendTouchArea:(UIEdgeInsets)edgeArea {
    objc_setAssociatedObject(self, &MSExtendEdgeKey, [NSValue valueWithUIEdgeInsets:edgeArea], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIEdgeInsets edge = [objc_getAssociatedObject(self, &MSExtendEdgeKey) UIEdgeInsetsValue];
    
    CGRect extendArea = self.bounds;
    if (edge.left || edge.right || edge.top || edge.bottom) {
        extendArea = CGRectMake(self.bounds.origin.x - edge.left,
                                self.bounds.origin.y - edge.top,
                                self.bounds.size.width + edge.left + edge.right,
                                self.bounds.size.height + edge.top + edge.bottom);
    }
    return CGRectContainsPoint(extendArea, point);
}

@end

@interface UIControl ()
/// 是否忽略点击事件；YES，忽略点击事件，NO，允许点击事件
@property (nonatomic, assign) BOOL isIgnoreEvent;
@end

@implementation UIControl(QMCategory)

static const CGFloat QMEventDefaultTimeInterval = 0;

#pragma mark -- 按钮事件点击间隔
- (BOOL)isIgnoreEvent {
    return [objc_getAssociatedObject(self, @"isIgnoreEvent") boolValue];
}

- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
    objc_setAssociatedObject(self, @"isIgnoreEvent", @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)QM_eventTimeInterval {
    return [objc_getAssociatedObject(self, @"QM_eventTimeInterval") doubleValue];
}

- (void)setQM_eventTimeInterval:(NSTimeInterval)QM_eventTimeInterval {
    objc_setAssociatedObject(self, @"QM_eventTimeInterval", @(QM_eventTimeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSEL = @selector(sendAction:to:forEvent:);
        SEL replaceSEL = @selector(QM_sendAction:to:forEvent:);
        Method systemMethod = class_getInstanceMethod(self, systemSEL);
        Method replaceMethod = class_getInstanceMethod(self, replaceSEL);
        
        BOOL isAdd = class_addMethod(self, systemSEL, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));
        
        if (isAdd) {
            class_replaceMethod(self, replaceSEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            // 添加失败，说明本类中有 replaceMethod 的实现，此时只需要将 systemMethod 和 replaceMethod 的IMP互换一下即可
            method_exchangeImplementations(systemMethod, replaceMethod);
        }
    });
}

- (void)QM_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([target isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
        [self setIsIgnoreEvent:NO];
        [self QM_sendAction:action to:target forEvent:event];
    }else {

    self.QM_eventTimeInterval = self.QM_eventTimeInterval == 0 ? QMEventDefaultTimeInterval : self.QM_eventTimeInterval;
    if (self.isIgnoreEvent){
        return;
    } else if (self.QM_eventTimeInterval >= 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.QM_eventTimeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setIsIgnoreEvent:NO];
        });
    }
    self.isIgnoreEvent = YES;
    [self QM_sendAction:action to:target forEvent:event];
          
    }
}

@end
