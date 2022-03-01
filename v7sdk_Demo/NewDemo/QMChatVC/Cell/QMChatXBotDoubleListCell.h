//
//  QMChatXBotDoubleListCell.h
//  NewDemo
//
//  Created by ZCZ on 2021/6/8.
//

#import "QMChatBaseCell.h"
#import "QMChatXBotFLowListCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface QMChatXBotDoubleListCell : QMChatXBotFLowListCell

@property (nonatomic, copy) void(^updateFingerSelected)(QMChatMessage *message);

@end

NS_ASSUME_NONNULL_END
