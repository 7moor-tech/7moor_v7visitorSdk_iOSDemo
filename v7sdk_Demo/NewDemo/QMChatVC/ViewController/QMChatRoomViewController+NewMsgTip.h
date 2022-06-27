//
//  QMChatRoomViewController+NewMsgTip.h
//  NewDemo
//
//  Created by ZCZ on 2022/4/25.
// 新消息滑动 + 预知输入  便于集成

#import "QMChatRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMChatRoomViewController (NewMsgTip)
// ** 新消息添加
@property (nonatomic, strong) NSIndexPath *scrollTo_indexPath;
// 记录已经设置过得内部偏移
@property (nonatomic, assign) UIEdgeInsets settedEdgeInsets;

- (BOOL)checkCanScroolCurrentOffSet;
- (void)showNewMsgScrollButton;
- (void)hiddenMessageScrollButtopn;
// ** 新消息结束

// 预知输入开始
- (void)addToPredicttheInputNotification;
- (void)removeToPredicttheInputNotification;


@end

NS_ASSUME_NONNULL_END
