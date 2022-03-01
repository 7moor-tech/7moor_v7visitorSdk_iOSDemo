//
//  QMChatXBotFLowListCell.h
//  NewDemo
//
//  Created by ZCZ on 2021/6/6.
//

#import "QMChatXBotBaseCell.h"
#import "QMChatTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMChatXBotFLowListCell : QMChatXBotBaseCell <UITextViewDelegate>

@property (nonatomic, strong) QMChatTextView *contentLab;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, copy) void(^needRoloadCell)(QMChatMessage * _Nullable);


@end

NS_ASSUME_NONNULL_END
