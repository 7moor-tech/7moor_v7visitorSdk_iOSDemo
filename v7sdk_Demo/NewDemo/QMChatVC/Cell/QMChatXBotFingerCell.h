//
//  QMChatXBotFingerCell.h
//  NewDemo
//
//  Created by ZCZ on 2021/6/7.
//

#import "QMChatXBotFLowListCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMChatXBotFingerCell : QMChatXBotFLowListCell

@property (nonatomic, copy) void(^updateFingerSelected)(QMChatMessage *message);

@end

NS_ASSUME_NONNULL_END
