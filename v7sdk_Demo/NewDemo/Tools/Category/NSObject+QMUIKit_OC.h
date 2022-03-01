//
//  NSObject+QMUIKit_OC.h
//  IMSDK
//
//  Created by 焦林生 on 2021/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (QMUIKit_OC)

@end

@interface UIButton (QMCategory)
// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, QMButtonEdgeInsetsStyle) {
    QMButtonEdgeInsetsStyleTop, // image在上，label在下
    QMButtonEdgeInsetsStyleLeft, // image在左，label在右
    QMButtonEdgeInsetsStyleBottom, // image在下，label在上
    QMButtonEdgeInsetsStyleRight // image在右，label在左
};

/**
 * 设置button的titleLabel和imageView的布局样式，及间距
 *
 * @param style titleLabel和imageView的布局样式
 * @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(QMButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;


//扩充点击区域
- (void)extendTouchArea:(UIEdgeInsets)edgeArea;

@end

@interface UIControl (QMCategory)

/** 按钮事件响应间隔 */
@property (nonatomic, assign) NSTimeInterval QM_eventTimeInterval;

@end



NS_ASSUME_NONNULL_END
