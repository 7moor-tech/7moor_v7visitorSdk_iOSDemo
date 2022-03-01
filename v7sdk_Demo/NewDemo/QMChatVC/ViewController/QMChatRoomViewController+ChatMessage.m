//
//  QMChatRoomViewController+ChatMessage.m
//  NewDemo
//
//  Created by ZCZ on 2021/5/20.
//

#import "QMChatRoomViewController+ChatMessage.h"
#import "QMFileManagerController.h"
#import "QMChatFileCell.h"
#import "QMChatRoomViewController+QMChatQuickFAQ.h"

@implementation QMChatRoomViewController (ChatMessage)


#pragma mark - 发送消息操作
//发送文本
- (void)sendTextMessage:(NSString *)text {
    
//    NSDictionary *dic1 = @{@"text"     : text,
//                           @"messageType" : @"text",
//                           @"fromType" : @"1"
//    };
//
//    NSArray *array = @[dic1];
//
//    for (NSDictionary *dict in array) {
//        QMChatMessage *model = [[QMChatMessage alloc] initWithDictionary:dict error:nil];
//        [self.dataSource addObject:model];
//    }
//    [self.chatTableView reloadData];
    
//    QMMessageModel *model = [[QMMessageModel alloc] init];
//    model.messageType = @"text";
//    model.message = text;
//    [QMConnect sendMessage:model delegate:self];
    NSString *nText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (nText.length == 0) {
        return;
    }
        
    [QMConnect sendText:text];

}

//发送图片
- (void)sendImage:(UIImage *)image {
    [QMConnect sendImage:image];
}

//发送语音
- (void)sendAudioMesage:(NSString *)fileName duration:(NSString *)duration {
    [QMConnect sendAudio:fileName duration:duration];
}

- (void)sendCsrInviteMessage:(NSString *)text {
    [QMConnect sendCsrInviteMessage:text];
}


#pragma mark - ChatMessageDelegate
//消息代理
- (void)oneMessage:(NSString *)sessionId messageId:(nonnull NSString *)messageId {
    [self loadNewMessageData:messageId];
}

/// 更新消息id
/// @param message 消息体
/// @param messageIds 消息id - count = 2  [之前的消息id, 需要更新的消息ID]
- (void)updateOneMessage:(QMMessageModel *)message withMessageIds:(NSArray *)messageIds {
    [self.dataSource enumerateObjectsUsingBlock:^(QMChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj._id isEqualToString:messageIds.firstObject] || [obj._id isEqualToString:messageIds.lastObject]) {

            QMChatMessage *model = [QMChatMessage initFromMessage:message];
            [self.dataSource replaceObjectAtIndex:idx withObject:model];

            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.chatTableView.visibleCells.count > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    NSInteger maxIndex = [self.chatTableView numberOfRowsInSection:0];
                    if (indexPath && indexPath.row < maxIndex) {
                        [self.chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                } else {
                    [self.chatTableView reloadData];
                }
            });
        }
    }];
}

- (void)updateMessageStatus:(NSDictionary *)statusInformation {
    NSString *status = [statusInformation objectForKey:@"status"];
    NSString *oldMessageId = [statusInformation objectForKey:@"oldMessageId"];
    NSString *newId = [statusInformation objectForKey:@"newMessageId"];

    [self.dataSource enumerateObjectsUsingBlock:^(QMChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj._id isEqualToString:oldMessageId] || [obj._id isEqualToString:newId]) {
            obj.status = status;
            if (oldMessageId.length > 0) {
                [NSNotificationCenter.defaultCenter postNotificationName:oldMessageId object:status];
            }
            [self.dataSource replaceObjectAtIndex:idx withObject:obj];
            *stop = YES;
        }
    }];
}

// 发送文件
- (void)sendFileMessageWithName:(NSString *)fileName AndSize:(NSString *)fileSize AndPath:(NSString *)filePath {
    [QMConnect sendFile:filePath fileName:fileName fileSize:fileSize progressHander:^(float progress, NSString *messageId) {
        [self setProgressFloat:progress messageId:messageId];
    }];
    
}

- (void)setProgressFloat:(float)progress messageId:(NSString *)messageId {
//    NSLog(@"progress = %.2f",progress);
    int index = 0;
    for (QMChatMessage *message in self.dataSource) {
        if ([message._id isEqualToString:messageId]) {
            if (progress == 1) {
                message.status = @"0";
            }
            break;
        }
        index++;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    QMChatFileCell *cell = (QMChatFileCell *)[self.chatTableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [cell setProgress:progress];
    }
    
}


- (void)sendCard {
    NSDictionary *dic = @{
        @"orderTitle":@"订单标题",
        @"orderNumName":@"订单号文案",
        @"orderNum":@"00000000000",
        @"orderList":@[
            @{
             @"content":@"好闻娇韵诗棉花籽温和控油磨砂泡沫洁面霜125ml",
             @"price":@"￥9999",
             @"imgUrl":@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201510%2F15%2F20151015064025_BRHAr.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626340747&t=931ced71c20aa7f51b66496bc088f1ca",
             @"clickTarget":@"self | url | user",
             @"clickUrl":@"执行跳转的链接"
            }
          ],

            @"btnRightShow":@(1),
             @"btnRightText":@"右侧按钮",
             @"btnRightTarget":@"self | url | user",
             @"btnRightUrl":@"执行跳转的数据",
            
             @"btnLeftShow":@(1),
             @"btnLeftText":@"左侧按钮",
             @"btnLeftTarget":@"self | url | user",
             @"btnLeftUrl":@"执行跳转的数据"
        };
    
    [QMConnect sendOrderCard:dic];
}

#pragma test
- (void)chatStatus:(QMChatInformation *)information {
    self.currentChatInfor = information;
    switch (information.kStatus) {
        case QMKStatusRobot: {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loadNewMessageData:nil];                
                [self sendListCards];
            });
            [self showQuickFAQ];
            [self closeQueueNum];

            self.isRobot = YES;
            self.manualButotn.hidden = NO;
            self.manualButotn.tag = 1001;
            [self updateAddBtnStatus:YES];
            self.serviceMode = QMChatServiceModeRobot;

        }
            break;
        case QMKStatusManualButton: {
            NSString *transferSeatsBtnText = QMThemeManager.shared.transferSeatsBtnText ? : @"";

            [self.manualButotn setTitle:transferSeatsBtnText forState:UIControlStateNormal];
            
            NSString *url = QMThemeManager.shared.transferSeatsBtnImgUrl ? : @"";
//            if (url.length > 0) {
                url = [[QMConnect sdkGetQiniuURL] stringByAppendingPathComponent:url].stringByRemovingPercentEncoding;
                url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                NSURL *uRL = [NSURL URLWithString:url];
                [self.manualButotn setImageWithURL:uRL forState:UIControlStateNormal];

            self.manualButotn.tag = 1001;
            self.manualButotn.hidden = NO;
            self.manualButotn.tag = 1001;

        }
            break;
        case QMKStatusClaim: {
            [self closeQueueNum];
            [self closeQuickFAQ];
            NSString *closeSeatsSessionBtnText = QMThemeManager.shared.closeSeatsSessionBtnText ? : @"";
            
            [self.manualButotn setTitle:closeSeatsSessionBtnText forState:UIControlStateNormal];
          

            NSString *url = QMThemeManager.shared.closeSeatsSessionBtnImgUrl ? : @"";

            url = [[QMConnect sdkGetQiniuURL] stringByAppendingString:url].stringByRemovingPercentEncoding;
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *uRL = [NSURL URLWithString:url];
            [self.manualButotn setImageWithURL:uRL forState:UIControlStateNormal];


            self.manualButotn.hidden = NO;
            self.manualButotn.tag = 1002;
            self.isRobot = NO;
            self.serviceMode = QMChatServiceModeCustomer;
            [self updateAddBtnStatus:NO];
        }
            break;
        case QMKStatusFinish:
            self.serviceMode = QMChatServiceModeNone;

            [self closeQuickFAQ];
            [self closeQueueNum];
            self.manualButotn.hidden = YES;
            self.manualButotn.tag = 1000;
            self.isAssociationInput = YES;
            if (information.messageId.length) {
                [self satisfactionAction:information.messageId sessionId:information.sessionId];
            }
            [self updateAddBtnStatus:YES];
            [self setCannotSelectFingerAndMutiSelect];
            [QMConnect sdkUpdateFingerMessageCannotSelected:YES];
            break;
            
        case QMKStatusQueueNum:
            [self closeQuickFAQ];
            if (information.number > 0) {
                self.manualButotn.hidden = YES;
                [self setupQueueNum:information];
            }
            break;
            
        case QMKStatusLeave:
            self.manualButotn.hidden = YES;
            self.manualButotn.tag = 1000;
            [self closeQueueNum];

            break;
            
        case QMKStatusInit:
            self.manualButotn.hidden = YES;
            self.manualButotn.tag = 1000;
            [self closeQueueNum];
            self.serviceMode = QMChatServiceModeNone;

            break;
        default:
            break;
    }
}

- (void)updateAddBtnStatus:(BOOL)status {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [QMThemeManager shared].isHiddenAddBtn = status;
        [self.chatInputView refreshInputView];
    });
}

- (void)satisfactionAction:(NSString *)messageId sessionId:(NSString *)sessionId {
    [QMConnect sdkCheckCSRStatus:messageId sessionId:sessionId completion:^(NSDictionary * _Nonnull data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *status = [data objectForKey:@"status"];
            if ([status isEqualToString:@"failure"]) {
                [QMRemind showMessage:@"评价已失效"];
                return;
            }else if ([status isEqualToString:@"evaluationed"]) {
                [QMRemind showMessage:@"会话已评价"];
                return;
            }else {
                [self.chatInputView showMoreView:NO];
                self.chatInputView.inputView.inputView = nil;
                [self.chatInputView.inputView endEditing:YES];

                [self.view bringSubviewToFront: self.satisfactionView];
                self.satisfactionView.hidden = NO;
                self.satisfactionView.messageId = messageId;
                self.satisfactionView.sessionId = sessionId;
                self.satisfactionView.satisfactionModel = self.satisfactionModel;
                
                __weak typeof(self)wSelf = self;
                self.satisfactionView.sendTanksText = ^(NSString * _Nonnull text) {
                    __strong typeof(self) sSelf = wSelf;
                    
                    __block NSString *sessionId;
                    [sSelf.dataSource enumerateObjectsUsingBlock:^(QMChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj._id isEqualToString:messageId]) {
                            obj.invite = @"2";
                            sessionId = obj.sessionId;
                            [sSelf.dataSource replaceObjectAtIndex:idx withObject:obj];
                        }
                    }];
                    
                    [sSelf.dataSource enumerateObjectsUsingBlock:^(QMChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.sessionId isEqualToString:sessionId] && obj.eMessageType == QMMessageTypeCsrInvite) {
                            obj.invite = @"2";
                            sessionId = obj.sessionId;
                            [sSelf.dataSource replaceObjectAtIndex:idx withObject:obj];
                        }
                    }];
                    
                    [sSelf sendCsrInviteMessage:text];
                };
            }
        });
    } failure:^(NSDictionary * _Nonnull reason) {
        [QMRemind showMessage:@"请求失败"];
        return;
    }];

}


@end
