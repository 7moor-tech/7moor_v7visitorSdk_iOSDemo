//
//  QMChatMoreView.h
//  newDemo
//
//  Created by lishuijiao on 2021/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    QMChatMoreModePicture = 200,
    QMChatMoreModeCamera,
    QMChatMoreModeVideo,
    QMChatMoreModeFile,
    QMChatMoreModeQuestion,
    QMChatMoreModeEvaluate,
    QMChatMoreModeCard,
} QMChatMoreMode;

@protocol QMMoreViewDelegate <NSObject>

- (void)moreViewSelectAcitonIndex:(QMChatMoreMode)index;

@end

@interface QMChatMoreView : UIView

@property (nonatomic, weak) id<QMMoreViewDelegate> delegate;

- (void)refreshMoreBtn;

@end

@interface QMChatMoreModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image_name;
@property (nonatomic, assign) QMChatMoreMode mode;


@end

NS_ASSUME_NONNULL_END