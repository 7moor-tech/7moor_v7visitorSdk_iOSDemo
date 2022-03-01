//
//  QMChatRoomViewController+QMChatQuickFAQ.h
//  NewDemo
//
//  Created by ZCZ on 2021/6/2.
//  快捷常见问题

#import "QMChatRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface QMChatRoomViewController (QMChatQuickFAQ) <UICollectionViewDelegate, UICollectionViewDataSource>

// 设置底部推荐问题数据
- (void)setupQuickFAQ:(NSArray *)bottomList;
// 关闭底部问题
- (void)closeQuickFAQ;
// 加载底部问题
- (void)showQuickFAQ;

- (void)setupQueueNum:(QMChatInformation *)inform;
- (void)closeQueueNum;

@end

NS_ASSUME_NONNULL_END
