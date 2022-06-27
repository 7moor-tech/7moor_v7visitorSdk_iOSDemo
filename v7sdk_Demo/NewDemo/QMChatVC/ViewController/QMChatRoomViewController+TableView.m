//
//  QMChatRoomViewController+TableView.m
//  NewDemo
//
//  Created by ZCZ on 2021/5/20.
//

#import "QMChatRoomViewController+TableView.h"
#import "QMChatRoomViewController+ChatMessage.h"
//cell
#import "QMChatTextCell.h"
#import "QMChatImageCell.h"
#import "QMChatFileCell.h"
#import "QMChatVideoCell.h"
#import "QMChatAudioCell.h"
#import "QMChatCardCell.h"
#import "QMChatRemindCell.h"
#import "QMChatXBotQuestionGroupCell.h"
#import "QMChatXBobtSelectButtonRowCell.h"
#import "QMChatCsrInviteCell.h"
#import "QMChatXBotFLowListCell.h"
#import "QMChatXBotFingerCell.h"
#import "QMWebViewController.h"
#import "QMChatXBotDoubleListCell.h"
#import "QMChatXBotLevelCell.h"
#import "QMChatXBotMultiRowCell.h"
#import "QMChatXBotFormCell.h"
#import "QMChatOrderCardCell.h"
#import "QMChatLogistcsInfoCell.h"
#import "QMChatListCardCell.h"
#import "QMChatQuickMenuCell.h"
#import "QMMoreQuestionView.h"
#import "QMLogistsMoreView.h"

#import "QMChatRoomViewController+NewMsgTip.h"


@implementation QMChatRoomViewController (TableView)



- (void)setupTableView {
    
    [self.chatTableView registerClass:[QMChatTextCell class] forCellReuseIdentifier:NSStringFromClass([QMChatTextCell class])];
    [self.chatTableView registerClass:QMChatImageCell.class forCellReuseIdentifier:NSStringFromClass(QMChatImageCell.class)];
    [self.chatTableView registerClass:QMChatFileCell.class forCellReuseIdentifier:NSStringFromClass(QMChatFileCell.class)];
    [self.chatTableView registerClass:QMChatVideoCell.class forCellReuseIdentifier:NSStringFromClass(QMChatVideoCell.class)];
    [self.chatTableView registerClass:QMChatAudioCell.class forCellReuseIdentifier:NSStringFromClass(QMChatAudioCell.class)];
    [self.chatTableView registerClass:QMChatCardCell.class forCellReuseIdentifier:NSStringFromClass(QMChatCardCell.class)];
    [self.chatTableView registerClass:QMChatRemindCell.class forCellReuseIdentifier:NSStringFromClass(QMChatRemindCell.class)];
    [self.chatTableView registerClass:QMChatXBotQuestionGroupCell.class forCellReuseIdentifier:NSStringFromClass(QMChatXBotQuestionGroupCell.class)];
    [self.chatTableView registerClass:QMChatXBobtSelectButtonRowCell.class forCellReuseIdentifier:NSStringFromClass(QMChatXBobtSelectButtonRowCell.class)];
    [self.chatTableView registerClass:QMChatCsrInviteCell.class forCellReuseIdentifier:NSStringFromClass(QMChatCsrInviteCell.class)];
    [self.chatTableView registerClass:QMChatXBotFLowListCell.class forCellReuseIdentifier:NSStringFromClass(QMChatXBotFLowListCell.class)];
    [self.chatTableView registerClass:QMChatXBotFingerCell.class forCellReuseIdentifier:NSStringFromClass(QMChatXBotFingerCell.class)];
    [self.chatTableView registerClass:QMChatXBotDoubleListCell.class forCellReuseIdentifier:NSStringFromClass(QMChatXBotDoubleListCell.class)];
    [self.chatTableView registerClass:QMChatXBotLevelCell.class forCellReuseIdentifier:NSStringFromClass(QMChatXBotLevelCell.class)];
    [self.chatTableView registerClass:QMChatXBotMultiRowCell.class forCellReuseIdentifier:NSStringFromClass(QMChatXBotMultiRowCell.class)];
    [self.chatTableView registerClass:QMChatXBotFormCell.class forCellReuseIdentifier:NSStringFromClass(QMChatXBotFormCell.class)];
    [self.chatTableView registerClass:QMChatOrderCardCell.class forCellReuseIdentifier:NSStringFromClass(QMChatOrderCardCell.class)];
    [self.chatTableView registerClass:QMChatLogistcsInfoCell.class forCellReuseIdentifier:NSStringFromClass(QMChatLogistcsInfoCell.class)];
    [self.chatTableView registerClass:QMChatListCardCell.class forCellReuseIdentifier:NSStringFromClass(QMChatListCardCell.class)];
    [self.chatTableView registerClass:QMChatQuickMenuCell.class forCellReuseIdentifier:NSStringFromClass(QMChatQuickMenuCell.class)];
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMChatMessage *model = self.dataSource[indexPath.row];
    model.newMsg = NO;
    if (self.scrollTo_indexPath == indexPath || self.dataSource.count <= self.scrollTo_indexPath.row) {
        [self hiddenMessageScrollButtopn];
    }
    NSString *cell_id = [self getCellidWithModel:model];

    if (indexPath.row == 0) {
        model.showDate = YES;
    } else {
        NSInteger index = indexPath.row - 1;
        QMChatMessage *lastModel = self.dataSource[index];
        NSTimeInterval disTime = model.createTimestamp - lastModel.createTimestamp;
        if (disTime > 80*2*1000 || model.showDate) {
            model.showDate = YES;
        }else {
            model.showDate = NO;
        }
    }
    
    if (model.type == ChatMessageSend && model.createTimestamp < self.readTimeIntervall) {
        model.isRead = @"1";
    }
    
    QMChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    [cell setCellData:model];
    [self handleBlockCell:cell indexPath:indexPath];
    
    return cell;
}

- (NSString *)getCellidWithModel:(QMChatMessage *)model {

    NSString *cell_id = NSStringFromClass(QMChatTextCell.class);

    switch (model.eMessageType) {
        case MessageTypeImage:
            cell_id = NSStringFromClass(QMChatImageCell.class);
            break;
        case MessageTypeFile:
            cell_id = NSStringFromClass(QMChatFileCell.class);
            break;
        case MessageTypeVideo:
            cell_id = NSStringFromClass(QMChatVideoCell.class);
            break;
        case MessageTypeAudio:
            cell_id = NSStringFromClass(QMChatAudioCell.class);
            break;
        case MessageTypeCard:
            cell_id = NSStringFromClass(QMChatCardCell.class);
            break;
        case MessageTypeRemind:
            cell_id = NSStringFromClass(QMChatRemindCell.class);
            break;
        case QMMessageTypeQuestion:
            cell_id = NSStringFromClass(QMChatXBotQuestionGroupCell.class);
            break;
        case QMMessageTypeSelect:
            cell_id = NSStringFromClass(QMChatXBobtSelectButtonRowCell.class);
            break;
        case QMMessageTypeCsrInvite:
            cell_id = NSStringFromClass(QMChatCsrInviteCell.class);
            break;
        case QMMessageTypeOrderCard:
            cell_id = NSStringFromClass(QMChatOrderCardCell.class);
            break;
        case QMMessageTypeMsgTask:
            if ([model.msgTaskModel.resp_type isEqualToString:@"1"]) {
                cell_id = NSStringFromClass(QMChatLogistcsInfoCell.class);
            } else {
                // 另一类型--未处理
                model.content = @"当前渠道不支持卡片";
                cell_id = NSStringFromClass(QMChatTextCell.class);
            }
            break;
        case QMMessageTypeListCard:
            cell_id = NSStringFromClass(QMChatListCardCell.class);
            break;
        case QMMessageTypeQuickMenu:
            cell_id = NSStringFromClass(QMChatQuickMenuCell.class);
            break;
            
        default:
            if (model.isShowHtml == 1) {
                if (model.robotMessageType == QMChatRobotMessageTypeFinger) {
                    cell_id = NSStringFromClass(QMChatXBotFingerCell.class);
                } else if (model.robotMessageType == QMChatRobotMessageTypeDoubleLine) {
                    cell_id = NSStringFromClass(QMChatXBotDoubleListCell.class);
                } else if (model.robotMessageType == QMChatRobotMessageTypeLevelScroll) {
                    cell_id = NSStringFromClass(QMChatXBotLevelCell.class);
                } else if (model.robotMessageType == QMChatRobotMessageTypeMultiSelect) {
                    cell_id = NSStringFromClass(QMChatXBotMultiRowCell.class);
                } else if (model.robotMessageType == QMChatRobotMessageTypeForm) {
                    cell_id = NSStringFromClass(QMChatXBotFormCell.class);
                } else if (model.robotMessageType == QMChatRobotMessageTypeQuestionsGroup) {
                    cell_id = NSStringFromClass(QMChatXBotQuestionGroupCell.class);
                } else if (model.robotMessageType == QMChatRobotMessageTypeSelectButtonRow) {
                    cell_id = NSStringFromClass(QMChatXBobtSelectButtonRowCell.class);
                } else {
                    cell_id = NSStringFromClass(QMChatXBotFLowListCell.class);
                }
            } else {
                cell_id = NSStringFromClass(QMChatTextCell.class);
            }
            break;
    }

    return cell_id;
}

- (void)handleBlockCell:(QMChatBaseCell *)cell indexPath:(NSIndexPath *)indexPath {
    QMChatMessage *model = self.dataSource[indexPath.row];

    __weak typeof(self)wSelf = self;

    cell.sendText = ^(NSString * _Nonnull text) {
        __strong typeof(wSelf)sSelf = wSelf;
        if ([text.lowercaseString containsString:@"m7_action_robottransferagent"]) {
            [sSelf customClick];
        } else {
            [sSelf sendTextMessage:text];
        }
    };
    
    cell.pushWebView = ^(NSURL * _Nonnull url) {
        __strong typeof(wSelf)sSelf = wSelf;
        QMWebViewController *webVC = [QMWebViewController new];
        webVC.url = url;
        [sSelf.navigationController pushViewController:webVC animated:YES];
    };
    
    if ([cell isKindOfClass:QMChatImageCell.class] || [cell isKindOfClass:QMChatTextCell.class]) {
        cell.upCellConstraint = ^(QMChatMessage *newModel){
            __strong typeof(wSelf)sSelf = wSelf;
            if (newModel) {

                [sSelf.dataSource enumerateObjectsUsingBlock:^(QMChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.messageId isEqualToString:newModel.messageId]) {
                        [sSelf.dataSource replaceObjectAtIndex:idx withObject:newModel];
                        *stop = YES;
                    }
                }];
            }
            [sSelf.chatTableView beginUpdates];
            [sSelf.chatTableView endUpdates];
        };
        
    } else if ([cell isKindOfClass:QMChatXBotQuestionGroupCell.class]) {
        QMChatXBotQuestionGroupCell *newCell = (QMChatXBotQuestionGroupCell *)cell;
        newCell.showAllAction = ^(NSDictionary *dict){
            [wSelf showAllQuestionAction:dict];
        };
        cell.upCellConstraint = ^(QMChatMessage *newModel){
            __strong typeof(wSelf)sSelf = wSelf;
            [sSelf.chatTableView beginUpdates];
            [sSelf.chatTableView endUpdates];
        };
    }else if ([cell isKindOfClass:QMChatCsrInviteCell.class]) {
        QMChatCsrInviteCell *newCell = (QMChatCsrInviteCell *)cell;
        newCell.inviteAction = ^{
            __weak typeof(wSelf) sSelf = wSelf;
            [sSelf satisfactionAction:model._id sessionId:model.sessionId];
        };
    }else if ([cell isKindOfClass:QMChatListCardCell.class]) {
        QMChatListCardCell *newCell = (QMChatListCardCell *)cell;
        newCell.selectItem = ^(NSString * _Nonnull clickText) {
            __strong typeof(wSelf) strongSelf = wSelf;
            [strongSelf sendTextMessage:clickText];
        };
    }else if ([cell isKindOfClass:QMChatXBotBaseCell.class]) {
        
        cell.upCellConstraint = ^(QMChatMessage *newModel){
            __strong typeof(wSelf)sSelf = wSelf;
            [sSelf.dataSource enumerateObjectsUsingBlock:^(QMChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.messageId isEqualToString:newModel.messageId]) {
                    [sSelf.dataSource replaceObjectAtIndex:idx withObject:newModel];
                    *stop = YES;
                }
            }];

            [sSelf.chatTableView beginUpdates];
            [sSelf.chatTableView endUpdates];
        };
        
        if ([cell isKindOfClass:QMChatXBotFLowListCell.class]) {
            QMChatXBotFLowListCell *flowCell = (QMChatXBotFLowListCell *)cell;
            flowCell.needRoloadCell = ^(QMChatMessage * newModel) {
                __strong typeof(wSelf)sSelf = wSelf;
                [sSelf.dataSource enumerateObjectsUsingBlock:^(QMChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.messageId isEqualToString:newModel.messageId]) {
                        [sSelf.dataSource replaceObjectAtIndex:idx withObject:newModel];
                        *stop = YES;
                    }
                }];

            };
        }
        
        if ([cell isKindOfClass:QMChatXBotFingerCell.class] || [cell isKindOfClass:QMChatXBotDoubleListCell.class]) {
            QMChatXBotFingerCell *xb2Cell = (QMChatXBotFingerCell *)cell;
            xb2Cell.updateFingerSelected = ^(QMChatMessage * _Nonnull message) {
                
                __strong typeof(wSelf)sSelf = wSelf;
                for (QMChatMessage *mg in sSelf.dataSource) {
                    if ([mg.messageId isEqualToString:message.messageId]) {
                        mg.fingerSelected = message.fingerSelected;
                        break;
                    }
                }

                sSelf.chatTableView.hidden = YES;
                [sSelf.chatTableView reloadData];
                sSelf.chatTableView.hidden = NO;
                if (sSelf.dataSource.count - 1 == indexPath.row) {
                    [sSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

                }

            };
        }
    }
    
    if ([cell isKindOfClass:[QMChatLogistcsInfoCell class]]) {
        
        QMChatLogistcsInfoCell *lcell = (QMChatLogistcsInfoCell *)cell;
        lcell.dataModel = model.msgTaskModel;
        QMLogistcsInfoModel *dataA = lcell.dataModel;
        lcell.showMore = ^{
            [wSelf showMoreLogistsView:dataA];
        };
        lcell.upCellConstraint = ^(QMChatMessage * message) {
            
            [wSelf.chatTableView beginUpdates];
            [wSelf.chatTableView endUpdates];
        };
    }
}

- (void)showMoreLogistsView:(QMLogistcsInfoModel *)model {
    QMLogistsMoreView *vc = [QMLogistsMoreView defualtView];
    [vc show:model];
}

- (void)showAllQuestionAction:(NSDictionary *)dict {
//    NSLog(@"点击显示更多");
    
    __weak typeof(self)wSelf = self;
    [QMMoreQuestionView.sharedView show:dict completion:^(NSString * text) {
        [wSelf sendTextMessage:text];
    }];
    

}




@end
