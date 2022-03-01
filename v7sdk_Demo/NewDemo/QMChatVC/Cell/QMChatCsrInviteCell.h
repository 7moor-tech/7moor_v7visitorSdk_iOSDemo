//
//  QMCsrInviteCell.h
//  NewDemo
//
//  Created by lishuijiao on 2021/6/4.
//

#import "QMChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^InviteAction)(void);

@interface QMChatCsrInviteCell : QMChatBaseCell

@property (nonatomic, copy) InviteAction inviteAction;

@property (nonatomic, copy) void(^showAllAction)(void);

@end

NS_ASSUME_NONNULL_END
