//
//  QMChatRoomViewController+TableView.h
//  NewDemo
//
//  Created by ZCZ on 2021/5/20.
//

#import "QMChatRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMChatRoomViewController (TableView) <UITableViewDelegate, UITableViewDataSource>

- (void)setupTableView;
@end

NS_ASSUME_NONNULL_END
