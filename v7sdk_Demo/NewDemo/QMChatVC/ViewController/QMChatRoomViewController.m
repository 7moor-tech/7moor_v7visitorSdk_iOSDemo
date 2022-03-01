//
//  QMChatRoomViewController.m
//  newDemo
//
//  Created by lishuijiao on 2021/2/2.
//

#import "QMChatRoomViewController.h"
//#import "QMRoomGlobaMacro.h"

#import "QMAttributedManager.h"
#import "QMChatRoomViewController+TableView.h"
#import "QMChatRoomViewController+ChatMessage.h"
#import "QMChatRoomViewController+QMChatQuickFAQ.h"
#import "QMChatRoomViewController+QMChatInput.h"
#import "QMChatEmojiManger.h"
#import <SDWebImage/SDWebImage.h>
#import <MoorV7SDK/MoorV7SDK.h>
#import "QMConnectStatusView.h"
#import "QMChatCsrInviteCell.h"
@interface QMChatRoomViewController ()<ConenctStatusDelegate>

@property (nonatomic, strong) QMNavButton *logoutButton; // 注销按钮

@property (nonatomic, assign) int dataNum;

@property (nonatomic, strong) QMConnectStatusView *connectView;

@property (nonatomic, strong) NSRecursiveLock *dataLock;


@end

int addCount = 10;

@implementation QMChatRoomViewController {
    CGRect keyBoardFrame; // 键盘位置
    
    CGFloat _navHeight; //导航高度
}

- (void)dealloc {
    [QMChatManager.shared removeMessageDelegate:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manualStatus) name:CUSTOM_MANUALBTN_STATUS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(associationInputAction) name:CUSTOM_ASSOCIATIONSINPUT_STATUS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImageAction:) name:@"qm_downImageCompleted" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageReadStatus:) name:CUSTOM_MESSAGERELOAD_STATUS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(withdrawMessage:) name:CUSTOM_MESSAGEWITHDRAW_STATUS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

// 基本配置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor  = k_QMRGB(238, 238, 238);
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
    self.view.backgroundColor = [UIColor colorWithHexString: @"#F6F6F6"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [QMConnect sdkDeleteListCards];
    
    self.dataLock = [[NSRecursiveLock alloc] init];
    self.dataSource = [NSMutableArray array];
    
    [self setupQuickFAQ:QMChatManager.shared.bottomList];
    
    if (@available(iOS 13.0, *)) {
        if (self.navigationController.navigationBar) {
            UINavigationBarAppearance *apperance = [UINavigationBarAppearance new];
            apperance.backgroundColor = UIColor.whiteColor;
            self.navigationController.navigationBar.standardAppearance = apperance;
            self.navigationController.navigationBar.scrollEdgeAppearance = apperance;
        }
    }
    
    [self layoutViews];
    [self createUI];
    [self newChat];

    [QMChatManager shared].kDelegate = self;
    [QMChatManager shared].messageDelegate = self;
    [QMChatManager shared].connectDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatBottomList:) name:@"CHATBOTTOMLIST" object:nil];

}

- (void)sendListCards {
    BOOL rel = [QMConnect sdkDeleteListCards];
    if (rel) {
        
        NSArray *listCards = @[
            @{
                @"imgUrl"    : @"https://v7-fs-im.7moor.com/1100480/im/20210622144141/1624344101865/8e4883a206314d5da623e7dd4fe684b1/%E6%A0%87%E7%AD%BE.png?imageView2/2/w/200/h/200",
                @"showName"  : @"订单查询1",
                @"clickText" : @"订单查询1",
                @"bgColor"   : @"#EE6C09"
            },
            @{
                @"imgUrl"    : @"https://v7-fs-im.7moor.com/1100480/im/20210622144138/1624344098217/db7c3728bee04dae9ce89f8b73042231/%E7%A4%BC%E5%93%81.png?imageView2/2/w/200/h/200",
                @"showName"  : @"订单2",
                @"clickText" : @"查询2",
                @"bgColor"   : @"#EE6C09"
            },
            @{
                @"imgUrl"    : @"https://v7-fs-im.7moor.com/1100480/im/20210622144133/1624344093778/a06c300f36a345dcae5f5d74e720b9a9/%E4%BC%9A%E5%91%98%E5%8D%A1.png?imageView2/2/w/200/h/200",
                @"showName"  : @"订单查询3",
                @"clickText" : @"订单查询3",
                @"bgColor"   : @"#EE6C09"
            },
            @{
                @"imgUrl"    : @"https://v7-fs-im.7moor.com/1100480/im/20210622144125/1624344085919/a6e258cdc62e4b6197faa62759d66f16/%E4%BC%98%E6%83%A0%E5%88%B8.png?imageView2/2/w/200/h/200",
                @"showName"  : @"订单查询4",
                @"clickText" : @"订单查询4",
                @"bgColor"   : @"#EE6C09"
            },
            @{
                @"imgUrl"    : @"https://v7-fs-im.7moor.com/1100480/im/20210622144121/1624344081904/80820af657ba48b4a464dd13eb41d647/%E9%80%89%E9%A1%B9.png?imageView2/2/w/200/h/200",
                @"showName"  : @"订单查询5",
                @"clickText" : @"订单查询5",
                @"bgColor"   : @"#EE6C09"
            },
            @{
                @"imgUrl"    : @"https://v7-fs-im.7moor.com/1100480/im/20210622144117/1624344077200/9be7460d081b4a85ae4795bc8e207471/%E4%BB%BB%E5%8A%A1%E6%9F%A5%E8%AF%A2.png?imageView2/2/w/200/h/200",
                @"showName"  : @"订单查询6",
                @"clickText" : @"订单查询6",
                @"bgColor"   : @"#EE6C09"
            }
        ];
        [QMConnect sendListCard:listCards];
    }
}

- (void)createUI {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.manualButotn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.logoutButton];
//    [self chatStatus:QMChatManager.shared.information];

    if (QMThemeManager.shared.sdkTitleBarText.length > 0) {
        self.title = QMThemeManager.shared.sdkTitleBarText;
    }
    
    [self.view addSubview:self.chatTableView];
    [self.view addSubview:self.chatInputView];
    [self setupTableView];
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(_navHeight);
        make.bottom.equalTo(self.chatInputView.mas_top);
    }];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refresh];
    }];
    [mj_header.lastUpdatedTimeLabel setHidden:true];
    self.chatTableView.mj_header = mj_header;
    
    CGFloat offy = 0.0;
    if (QM_IS_iPHONEX) {
        offy = 14.0;
    }
    
    [self.chatInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-offy);
        make.height.mas_equalTo(kInputViewHeight);
    }];
    
        
    [self.view addSubview:self.satisfactionView];
    [self.satisfactionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.view addSubview:self.associationView];
    [self.associationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self setupNoticeView];
    
    for (QMChatInformation *objc in QMChatManager.shared.informations) {
        [self chatStatus:objc];
    }
    
    
}

- (void)updateMessageReadStatus:(NSNotification *)notif {
    NSTimeInterval readTimer = [notif.object doubleValue];
    self.readTimeIntervall = readTimer;
    NSArray *cells = self.chatTableView.visibleCells;
    for (QMChatBaseCell *cell in cells) {
        if (cell.message.type == ChatMessageSend) {
            cell.message.isRead = @"1";
            [cell setMessageIsRead:@"1"];
        }
    }
}

- (void)setupNoticeView {
    NSString *topNotice = QMThemeManager.shared.topNoticeText;
    if (topNotice.length > 0) {
        CGFloat notice_height = 45;
        
        UIView *topNoticeView = [UIView new];
        topNoticeView.tag = 431;
        [self.view addSubview:topNoticeView];
        [self.view insertSubview:topNoticeView aboveSubview:self.chatTableView];
        topNoticeView.backgroundColor = [QMThemeManager.shared.mainColorModel color:0.2];
        [topNoticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            if (self.navigationController.navigationBar.isTranslucent) {
                make.top.equalTo(self.view).offset(kStatusBarAndNavHeight).priorityHigh();
            } else {
                make.top.equalTo(self.view).priorityHigh();
            }
            make.height.mas_equalTo(notice_height);
        }];
        
        [self.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kStatusBarAndNavHeight + notice_height);
        }];
        
        UIImageView *tipView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_notice"]];
        tipView.image = [tipView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [tipView setTintColor:QMThemeManager.shared.mainColorModel.color];
        tipView.contentMode = UIViewContentModeScaleAspectFit;
        [topNoticeView addSubview:tipView];
        
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.centerY.equalTo(topNoticeView);
            make.width.height.mas_equalTo(17);
        }];
        
        
        UILabel *tipLab = [UILabel new];
        tipLab.text = topNotice;
        tipLab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:14];
        tipLab.textColor = QMThemeManager.shared.mainColorModel.color;
        [topNoticeView addSubview:tipLab];
        [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipView.mas_right).offset(10);
            make.centerY.equalTo(topNoticeView);
            make.right.lessThanOrEqualTo(topNoticeView).offset(30);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *tip_close_img = [UIImage imageNamed:@"tip_close"];
        tip_close_img = [tip_close_img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [closeBtn setImage:tip_close_img forState:UIControlStateNormal];
        
        [closeBtn.imageView setTintColor:QMThemeManager.shared.mainColorModel.color];

        closeBtn.QM_eventTimeInterval = 2;
        [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [topNoticeView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(topNoticeView).offset(-10);
            make.width.height.mas_equalTo(30);
            make.centerY.equalTo(topNoticeView);
        }];

        
    }
}
#pragma mark --进入前台消息监听
- (void)didBecomeActive {
    [self didConnected];
}

- (void)closeAction {
    
    UIView *topNoticeView = [self.view viewWithTag:431];
    [topNoticeView removeFromSuperview];
    [self.chatTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarAndNavHeight);
    }];
    
}

- (void)chatBottomList:(NSNotification *)notif {
    NSArray *bottomList = (NSArray *)notif.object;
    [self setupQuickFAQ:bottomList];
}

- (void)newChat {
    [self getListMsg];
    [self getSatisfaction];
}

- (void)getListMsg {
        
    NSString *lastTime = @"";
    if (self.dataSource.count > 0) {
        lastTime = @(self.dataSource.firstObject.createTimestamp).description;
    }
    
    [QMConnect sdkGetListMsg:lastTime completion:^{
        
        [self consumeUnReadMessage];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (lastTime.length > 0) {
                [self loadMoreData];
            } else {
                [self loadDatas];
            }
        
            [self.chatTableView.mj_header endRefreshing];
        });
    } failure:^(NSError * _Nonnull error) {
        
        if (self.chatTableView.mj_header.isRefreshing) {
            [self.chatTableView.mj_header endRefreshing];
            self.dataNum -= addCount;
        }
    }];
}

- (void)loadMoreData {
    
    QMMessageModel *lMessage = self.dataSource.firstObject;
    NSArray <QMMessageModel *>*array = [QMConnect getDataFormDatabase:addCount withCreatTime:@(lMessage.createTimestamp).description];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (array.count > 0) {
            [self.dataLock lock];
            int index = 0;
            for (NSInteger i = 0; i < array.count; i++) {
                QMMessageModel *mode = array[i];
                QMChatMessage *model = [QMChatMessage initFromMessage:mode];
                if (model) {
                    [self.dataSource insertObject:model atIndex:0];
                    index++;
                }
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

            [UIView performWithoutAnimation:^{
                self.chatTableView.hidden = YES;
                [self.chatTableView reloadData];
                [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                self.chatTableView.hidden = NO;
            }];
            [self.dataLock unlock];
            [self.chatTableView.mj_header endRefreshing];
        }
        
    });
    
}

- (void)loadDatas {
    
    NSMutableArray *datas = [NSMutableArray array];
    NSArray <QMMessageModel *>*array = [QMConnect getAllDataFormDatabase:self.dataNum > 0 ? self.dataNum : 5];
    for (NSInteger i = array.count - 1; i >= 0; i --) {
        QMMessageModel *mode = array[i];
        QMChatMessage *model = [QMChatMessage initFromMessage:mode];
        if (model) {
            [datas addObject:model];
        }
    }
    
    CGFloat after = 0;
    if (@available(iOS 11.0, *)) {
        if (self.chatTableView.hasUncommittedUpdates == YES) {
            after = 1;
        }
    } else {
        // Fallback on earlier versions
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.dataLock lock];
        [self.dataSource setArray:datas];
        [UIView performWithoutAnimation:^{
            [self.chatTableView reloadData];
            [self scrollToBottom:YES];
        }];
        
//        if (self.dataSource.count > 2) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
//        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:true];
//            });
//        }
        
        [self.dataLock unlock];
    });
    
}

- (void)loadNewMessageData:(NSString *)messageId {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self consumeUnReadMessage];
        
        [self.dataLock lock];
        NSArray <QMMessageModel *>*array = nil;
        QMChatMessage *lastMsg = self.dataSource.lastObject;
        if (messageId && messageId.length > 0) {
            QMMessageModel *newMsg = [QMConnect getDataFormDatabasewithMessageId:messageId];
            if (newMsg) {
                array = @[newMsg];
            }
        } else if (lastMsg && lastMsg.createTimestamp) {
            array = [QMConnect getNewDataFormDatabaseWithCreatTime:@(lastMsg.createTimestamp).description];
        } else {
            array = [QMConnect getAllDataFormDatabase:1];
        }
        
        NSInteger lastCount = self.dataSource.count;
        if (array.count > 0) {
            
            // 删除历史本地listcard数据
            BOOL needDeletFastBtn = NO;
            BOOL needDeletquickMenuBtn = NO;

            for (QMMessageModel *mode in array) {
                if ([mode.messageType isEqualToString:@"moorFastBtn"]) {
                    needDeletFastBtn = YES;
                } else if ([mode.messageType isEqualToString:@"quickMenu"]) {
                    needDeletquickMenuBtn = YES;
                }
                
                if (needDeletFastBtn && needDeletquickMenuBtn) {
                    break;
                }
                
            }
            
            if (needDeletFastBtn) {
                for (QMChatMessage *model in self.dataSource) {
                    if (model.eMessageType == QMMessageTypeListCard) {
                        [self deleteRepetitionRow:model];
                        break;
                    }
                }
            }
            
            if (needDeletquickMenuBtn) {
                for (QMChatMessage *model in self.dataSource) {
                    if (model.eMessageType == QMMessageTypeQuickMenu) {
                        [self deleteRepetitionRow:model];
                        break;
                    }
                }
            }
            
            // 删除历史本地listcard数据 end
            BOOL containsCsrInvite = NO;
            NSMutableArray *indexPathArr = [NSMutableArray array];
            
            NSArray *oldSoures = self.dataSource.yy_modelToJSONObject;
            NSMutableArray *existIds = [NSMutableArray array];
            if (oldSoures.count && messageId.length) {
                NSArray *messageIdArrays = [oldSoures valueForKeyPath:@"_id"];
                for (QMChatMessage *model in array) {
                    if ([messageIdArrays containsObject:model._id]) {
                        [existIds addObject:messageId];
                    }
                }
            }
            
            for (QMMessageModel *mode in array) {
                QMChatMessage *model = [QMChatMessage initFromMessage:mode];
//                if (lastMsg == nil || lastMsg.createTimestamp < model.createTimestamp) {
                    if (model) {
                        if ([existIds containsObject:model._id]) {
 //                                NSLog(@"相同不添加");
                        } else {
                            [self.dataSource addObject:model];
                            
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
                            [indexPathArr addObject:indexPath];

                            if (model.eMessageType == QMMessageTypeCsrInvite) {
                                containsCsrInvite = YES;
                            }
                            
                        }
                    }
//                }
                
            }
            
            __block NSIndexPath *indexPath = indexPathArr.lastObject;

            if (containsCsrInvite) {
                [UIView performWithoutAnimation:^{
                    [self.chatTableView reloadData];
                }];
                if (self.dataSource.count > 5) {
                    [self scrollToBottom:YES];
                }

            } else if (self.chatTableView.visibleCells.count > 0 && self.dataSource.count == lastCount + indexPathArr.count) {

                [UIView performWithoutAnimation:^{
                    [self.chatTableView insertRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationNone];

                    if (self.dataSource.count != indexPath.row + 1) {
                        indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
                    }
                    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }];


            } else {
                [UIView performWithoutAnimation:^{
                    [self.chatTableView reloadData];
                }];
            }
        }
        
        [self.dataLock unlock];
    });
    
}

#pragma mark --消费未读消息
- (void)consumeUnReadMessage {
    NSArray *arr = [QMConnect sdkGetAgentMessageWithIsRead];
    [QMConnect sdkDealImMsgWithMessageID:arr];
}

#pragma mark --删除重复卡片
- (void)deleteRepetitionRow:(QMChatMessage*)model {
    NSInteger index = [self.dataSource indexOfObject:model];
    if (index == NSNotFound)
        return;
    [self.dataSource removeObject:model];
    [self.chatTableView beginUpdates];
    [self.chatTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.chatTableView endUpdates];
}

#pragma mark --滚动到底部
- (void)scrollToBottom:(BOOL)animate
{
    if (self.dataSource.count > 0) {
        [UIView performWithoutAnimation:^{
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:animate];
        }];
    }
}

- (void)layoutViews {
 
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect NavRect = self.navigationController.navigationBar.frame;
    _navHeight = StatusRect.size.height + NavRect.size.height;
    if (self.navigationController.navigationBar.isTranslucent) {
        _navHeight = 0;
    }

}

#pragma mark - 下拉加载更多
- (void)refresh {
    if (self.dataNum > self.dataSource.count) {
        [self.chatTableView.mj_header endRefreshing];
        return;
    }
    
    self.dataNum += addCount;
    [self getListMsg];
}

#pragma mark - 满意度模板
- (void)getSatisfaction {
    [QMConnect sdkSatisfaction:^(NSDictionary * _Nonnull data) {
        self.satisfactionModel = [[QMSatisfactionModel alloc] init];
        
        NSArray *radioTagArr = [data objectForKey:@"radioTagText"];
        NSMutableArray *array = [NSMutableArray array];
        
        NSNumber *defaultNumber = 0;
        NSString *defaultName = @"";
        for (int i = 0; i < radioTagArr.count; i++) {
            NSDictionary *dic = radioTagArr[i];
//            BOOL isUse = [[dic valueForKey:@"isUse"] boolValue];
            if (i == 0) {
                defaultNumber = [dic valueForKey:@"defaultIndex"];
            }
            
            if ([defaultNumber intValue] == i+1) {
                defaultName = [dic valueForKey:@"key"];
            }
        }
        
        for (id radioItem in radioTagArr) {
            QMSatisfactionRadio *radio = [[QMSatisfactionRadio alloc] init];
            radio.key = [radioItem valueForKey:@"key"];
            radio.name = [radioItem valueForKey:@"name"];
            radio.reason = [radioItem valueForKey:@"reason"];
            radio.defaultName = defaultName;
            radio.proposalStatus = [radioItem valueForKey:@"proposalStatus"];
            BOOL isUse = [[radioItem valueForKey:@"isUse"] boolValue];
            if (isUse) {
                [array addObject:radio];
            }
        }
        
        self.satisfactionModel.radios = array;
        self.satisfactionModel.title = [data objectForKey:@"satisfyTitle"];
        self.satisfactionModel.thank = [data objectForKey:@"satisfyThank"];
        self.satisfactionModel.radioTagText = [data objectForKey:@"type"];
                
    } failure:^(NSDictionary * _Nonnull reason) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [QMRemind showMessage:@"满意度获取失败"];
        });
    }];
}

#pragma mark - 各种
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
   [super traitCollectionDidChange:previousTraitCollection];
   if (@available(iOS 13.0, *)) {
       UIUserInterfaceStyle style = [UITraitCollection currentTraitCollection].userInterfaceStyle;
       isQMDarkStyle = style == UIUserInterfaceStyleDark;
       [self changeUserInfaceStyle];
   }
}

- (void)changeUserInfaceStyle {

//    [self.chatTableView reloadData];

}

- (CGFloat)navHeight {
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect NavRect = self.navigationController.navigationBar.frame;
    CGFloat navHeight = StatusRect.size.height + NavRect.size.height;
    return navHeight;
}

#pragma mark - 转人工按钮
- (void)manualStatus {
    self.manualButotn.hidden = NO;
    self.manualButotn.tag = 1001;
}

#pragma mark - 联想输入
- (void)associationInputAction {
    self.isAssociationInput = YES;
}

- (void)loadImageAction:(NSNotification *)notif {
    NSString *messageId = (NSString *)notif.object;
    if (self.dataSource.count > 0) {
        [self.dataSource enumerateObjectsUsingBlock:^(QMChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageId isEqualToString:messageId]) {
                *stop = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    [self.chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            }
        }];
    }
}

#pragma mark - 键盘操作
//取消键盘
- (void)hideKeyboard {
//    self.chatInputView.addButton.tag = 3;
    [self.chatInputView.inputView resignFirstResponder];
    self.chatInputView.inputView.inputView = nil;
    [self.chatInputView showMoreView:NO];
//    [self.chatInputView showEmotionView:NO];

}

//键盘通知
- (void)keyboardFrameChange:(NSNotification *)notification {
    NSDictionary * userInfo =  notification.userInfo;
    NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect newFrame = [value CGRectValue];

    if (!self.satisfactionView.hidden) {

        if (ceil(newFrame.origin.y) == [UIScreen mainScreen].bounds.size.height) {
            CGRect rt = self.satisfactionView.coverView.frame;
            rt.origin.y = 200;
            rt.size.height = QM_kScreenHeight - 200;
            self.satisfactionView.coverView.frame = rt;
            self.satisfactionView.headerLabel.frame = CGRectMake(0, CGRectGetMinY(self.satisfactionView.coverView.frame) - 40, QM_kScreenWidth, 40);
            CGFloat maxY = CGRectGetMaxY(self.satisfactionView.cancelButton.frame) + (QM_IS_iPHONEX?40:20);
            self.satisfactionView.coverView.contentSize = CGSizeMake(QM_kScreenWidth, maxY);
        }else {
            CGRect cancelRT = self.satisfactionView.cancelButton.frame;
            CGRect rt = self.satisfactionView.coverView.frame;
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            CGRect rect = [self.satisfactionView.cancelButton convertRect:self.satisfactionView.cancelButton.bounds toView:window];
            if ((QM_kScreenHeight - rect.origin.y - cancelRT.size.height - newFrame.size.height) > 0) {
                NSLog(@"不需要移动");
            }else {
                NSLog(@"需要移动");
                CGFloat moveHeight = QM_kScreenHeight - rect.origin.y - cancelRT.size.height;
                NSLog(@"moveHeight - %f", moveHeight);
                if (moveHeight > 0) {
                    moveHeight = newFrame.size.height - moveHeight;
                }else {
                    moveHeight = newFrame.size.height;
                }

                if (moveHeight > rt.origin.y && (rt.origin.y - moveHeight - 40) >= kStatusBarAndNavHeight) {
                    rt.origin.y -= moveHeight;
                }else {
                    rt.origin.y = kStatusBarAndNavHeight + 40;
                }
                
                CGFloat contentHeight = self.satisfactionView.coverView.contentSize.height;
                self.satisfactionView.coverView.contentSize = CGSizeMake(QM_kScreenWidth, contentHeight + newFrame.size.height);
                self.satisfactionView.coverView.frame = rt;
                self.satisfactionView.headerLabel.frame = CGRectMake(0, CGRectGetMinY(self.satisfactionView.coverView.frame) - 40, QM_kScreenWidth, 40);
                
                CGRect rect2 = [self.satisfactionView.cancelButton convertRect:self.satisfactionView.cancelButton.bounds toView:window];
                
                CGFloat windowHeight = [UIScreen mainScreen].bounds.size.height;

                if (windowHeight - rect2.origin.y > newFrame.size.height) {
                    NSLog(@"不处理contentSize");
                    self.satisfactionView.coverView.contentSize = CGSizeMake(QM_kScreenWidth, rt.size.height);
                }else {
                    NSLog(@"需要处理contentSize");
                    
                    CGFloat move = rect2.origin.y  + (newFrame.size.height - (windowHeight - rect2.origin.y)) - kStatusBarAndNavHeight - 40;

                    NSLog(@"move - %f - rect2 - %f", move, rect2.origin.y);
                    NSLog(@"newFrame.origin.y - %f", newFrame.size.height);
                    self.satisfactionView.coverView.contentSize = CGSizeMake(QM_kScreenWidth, move);
                    
                    CGRect remarkRT = [self.satisfactionView.remarkTView convertRect:self.satisfactionView.remarkTView.bounds toView:window];

                    NSLog(@"与键盘的比较 - %f - %f", windowHeight - remarkRT.origin.y - 80, newFrame.size.height);
                    if (windowHeight - remarkRT.origin.y - 80 > newFrame.size.height) {
                        NSLog(@"不更改point");
                    }else {
                        CGFloat remarkY = (newFrame.size.height - (windowHeight - remarkRT.origin.y - 80));
                        NSLog(@"remarkY - %f", remarkY);
                        CGPoint point;
                        point = CGPointMake(0, remarkY);
                        self.satisfactionView.coverView.contentOffset = point;
                    }
                }
                
            }

            return;
        }
    }

    if (ceil(newFrame.origin.y) == [UIScreen mainScreen].bounds.size.height) {

        CGPoint point = self.chatTableView.contentOffset;
        [self.chatTableView setContentOffset:point];
        CGFloat offy = 0.0;
        if (QM_IS_iPHONEX) {
            offy = 14.0;
        }
        [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-offy);
        }];

        [self.associationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-offy - self.chatInputView.frame.size.height);
        }];

        [self.satisfactionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
    } else {

        [self.chatInputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-newFrame.size.height);
        }];

        [self.associationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-newFrame.size.height - self.chatInputView.frame.size.height);
        }];

        if (keyBoardFrame.origin.y != newFrame.origin.y) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self scrollToBottom:YES];
//                if (self.dataSource.count >0 ) {
//                    NSInteger count = [self.chatTableView numberOfRowsInSection:0];
//                    if (count > 1) {
//                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
//                        [UIView performWithoutAnimation:^{
//                            [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                        }];
//                    }
//                }
            });

        }

    }

    keyBoardFrame = newFrame;

}

#pragma mark - UITextViewDelegate && xbot联想输入
- (void)inputSuggest:(NSString *)text {
    [QMConnect sdkInputSuggest:text completion:^(NSDictionary * _Nonnull data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *questions = [data objectForKey:@"questions"];
            NSString *keyword = [data objectForKey:@"keyword"];

            NSString *newStr = [self.chatInputView.inputView.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
            if (questions.count && newStr.length > 0 && [newStr containsString:keyword]) {
                [self.view bringSubviewToFront: self.associationView];
                self.associationView.hidden = NO;
                self.associationView.keyword = text;
                self.associationView.dataSource = questions;
            }else {
                self.associationView.hidden = YES;
            }
        });
    } failure:^(NSDictionary * _Nonnull reason) {
        
    }];
}

#pragma mark - ConenctStatusDelegate
- (void)connectStatus:(QMSocketConnectStatus)status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatInputView.inputView resignFirstResponder];
    });
    [self netWorkReachability:status];
}

- (void)netWorkReachability:(QMSocketConnectStatus)connectStatus {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];

    __weak typeof(self)wSelf = self;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        __strong typeof(wSelf)sSelf = wSelf;
        
//        NSLog(@"setReachabilityStatusChangeBlock - %ld - %ld", (long)status, (long)connectStatus);
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [sSelf setNetView:connectStatus isLoad:YES];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [sSelf setNetView:connectStatus isLoad:YES];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [sSelf setNetView:connectStatus isLoad:NO];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [sSelf setNetView:connectStatus isLoad:NO];
                break;
            default:
                break;
        }
    }];
}

- (void)setNetView:(QMSocketConnectStatus)connectStatus isLoad:(BOOL)isLoad {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (connectStatus) {
            case QMSocketConnectStatusDisconnected:
                if (isLoad) {
                    //没网断开连接
                    [QMLoadingHUD hidden];
                    [self createConnectView:isLoad];
                }else {
                    //有网断开连接 - 自动重连
                    [QMLoadingHUD hidden];
                    [QMConnect sdkReConnect];
                }
                break;
            case QMSocketConnectStatusConnecting:
                if (isLoad) {
                    [self createConnectView:isLoad];
                    [QMLoadingHUD hidden];
                }else {
                    [self.connectView removeFromSuperview];
                    [QMLoadingHUD loading];
                }
                break;
            case QMSocketConnectStatusConnected:
                [self.connectView removeFromSuperview];
                [QMLoadingHUD hidden];
                [self didConnected];
                break;
            default:
                break;
        }
    });
}

#pragma mark --重连加载
-(void)didConnected {
    QMWeakSelf
    [QMConnect sdkGetListMsg:@"" completion:^{
        [self consumeUnReadMessage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self_weak_.dataSource removeAllObjects];
            [self_weak_.chatTableView reloadData];
            self_weak_.dataNum = 0;
            [self_weak_ loadDatas];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"didConnected - %@", error);
    }];
}

- (void)createConnectView:(BOOL)isBack {
    __weak typeof(self) weakSelf = self;
    
    [self.view addSubview:self.connectView];
    [self.connectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.connectView.reConnectBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (isBack) {
            [strongSelf.connectView removeFromSuperview];
            [[QMClient shared] disconnectSocket];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [QMConnect sdkReConnect];
        }
    };
    self.connectView.cancelBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.connectView removeFromSuperview];
        [[QMClient shared] disconnectSocket];
        [strongSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"tag"] && object == self.manualButotn) {
        NSInteger btnTag = [change[NSKeyValueChangeNewKey] intValue];
        if (![QMThemeManager shared].isTransferSeatsShow && btnTag == 1001) {
            self.manualButotn.hidden = YES;
        }else if (![QMThemeManager shared].isCloseSeatsSessionShow && btnTag == 1002) {
            self.manualButotn.hidden = YES;
        }
    }
}

- (void)withdrawMessage:(NSNotification *)notif {
    NSDictionary *dict = (NSDictionary *)notif.object;
    if ([dict isKindOfClass:NSDictionary.class] && self.dataSource.count > 0) {
        NSString *messageId = dict[@"messageId"];
        [self.dataSource enumerateObjectsUsingBlock:^(QMChatMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageId isEqualToString:messageId]) {
                *stop = YES;
                obj.messageType = @"remind";
                NSString *timeString = dict[@"createTime"] ? : @"";
                NSString *name = self.currentChatInfor.customerName ? : @"";
                obj.content = [NSString stringWithFormat:@"%@ %@ [%@] 撤回一条消息", timeString, obj.userName, name];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                    [self.chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            }
        }];
    }
}

#pragma mark -  转人工事件
// 转人工客服
- (void)customClick {
    NSInteger tag = self.manualButotn.tag - 1000;
    if (tag == 1) {
        [QMConnect sdkConvertManual:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.manualButotn.hidden = YES;
                self.isRobot = NO;
            });
        } failure:^(NSDictionary * _Nonnull reason) {
            
        }];
    }else if (tag == 2) {
        [QMLoadingHUD loading];
        [QMConnect sdkCloseChat:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [QMLoadingHUD hidden];
                self.manualButotn.hidden = YES;
                self.manualButotn.tag = 1000;
                [QMThemeManager shared].isHiddenEvaluateBtn = YES;
                self.isAssociationInput = NO;
                [QMThemeManager shared].isHiddenAddBtn = YES;
                [self.chatInputView refreshInputView];
                [self setCannotSelectFingerAndMutiSelect];
                [QMConnect sdkUpdateFingerMessageCannotSelected:YES];
            });
        } failure:^(NSDictionary * _Nonnull reason) {
            [QMLoadingHUD hidden];
        }];
    }
}

- (void)setCannotSelectFingerAndMutiSelect {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *reloadIndexPaths = [NSMutableArray array];
        for (int i = 0; i < self.dataSource.count; i++) {
            
            QMChatMessage *model = self.dataSource[i];
            model.cannotSelectMessage = YES;
            if (model.type == QMChatRobotMessageTypeFinger || model.type == QMChatRobotMessageTypeDoubleLine || model.type == QMChatRobotMessageTypeMultiSelect) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 - i inSection:0];
                [reloadIndexPaths addObject:indexPath];
            }
        }
        
        if (reloadIndexPaths.count > 0) {
            [UIView performWithoutAnimation:^{
                [self.chatTableView reloadData];
            }];
        }
    });
}

@end


@implementation QMChatRoomViewController (GetterSetter)

#pragma mark  Setting 方法
- (QMNavButton *)manualButotn {
    if (!_manualButotn) {
        _manualButotn = [QMNavButton new];
        
        if (QMThemeManager.shared.transferSeatsBtnText.length > 0) {
            [_manualButotn setTitle: QMThemeManager.shared.transferSeatsBtnText forState:UIControlStateNormal];
        }


        NSString *url = QMThemeManager.shared.transferSeatsBtnImgUrl ? : @"";
        
        url = [[QMConnect sdkGetQiniuURL] stringByAppendingPathComponent:url].stringByRemovingPercentEncoding;
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *uRL = [NSURL URLWithString:url];
        [_manualButotn setImageWithURL:uRL forState:UIControlStateNormal];
        _manualButotn.QM_eventTimeInterval = 2;
        [_manualButotn addTarget:self action:@selector(customClick) forControlEvents:UIControlEventTouchUpInside];
        _manualButotn.hidden = YES;
        _manualButotn.tag = 1000;
     
        [_manualButotn setTextIsEmptyImagePoint:QMNavButtonImagePointRight];
        
        [_manualButotn addObserver:self forKeyPath:@"tag" options:NSKeyValueObservingOptionNew context:nil];
    }

    return _manualButotn;
}

- (QMNavButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [[QMNavButton alloc] init];
//        _logoutButton.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:14];
        if (QMThemeManager.shared.leftTitleBtnText.length > 0) {
            [_logoutButton setTitle:QMThemeManager.shared.leftTitleBtnText forState:UIControlStateNormal];
        }

        [_logoutButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        NSString *url = QMThemeManager.shared.leftTitleBtnImgUrl ? : @"";
//        if (url.length > 0) {
            url = [[QMConnect sdkGetQiniuURL] stringByAppendingPathComponent:url].stringByRemovingPercentEncoding;
            url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *uRL = [NSURL URLWithString:url];
            [_logoutButton setImageWithURL:uRL forState:UIControlStateNormal];
//        } else {
//            [_logoutButton setImage:[UIImage imageNamed:@"qm_chat_back"] forState:UIControlStateNormal];
//        }
        _logoutButton.QM_eventTimeInterval = 2;
        [_logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _logoutButton;
}

- (UITableView *)chatTableView {
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, QM_kScreenWidth, QM_kScreenHeight-kInputViewHeight-[self navHeight]) style:UITableViewStylePlain];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
//        _chatTableView.backgroundColor = [UIColor colorWithHexString:isQMDarkStyle ? QMColor_Main_Bg_Dark : QMColor_Main_Bg_Light];
        _chatTableView.backgroundColor = [UIColor colorWithHexString:QMColor_Main_Bg_Light];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.rowHeight = UITableViewAutomaticDimension;
        _chatTableView.estimatedRowHeight = 80;
        _chatTableView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        
        UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        [_chatTableView addGestureRecognizer:gestureRecognizer];
        gestureRecognizer.cancelsTouchesInView = NO;

    }
    return _chatTableView;
}

- (QMChatInputView *)chatInputView {
    if (!_chatInputView) {
        self.chatInputView = [[QMChatInputView alloc] initWithFrame:CGRectMake(0, QM_kScreenHeight-kInputViewHeight-[self navHeight], QM_kScreenWidth, kInputViewHeight)];
        self.chatInputView.delegate = self;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.chatInputView.coverView addGestureRecognizer:tapGesture];
        [self.chatInputView.coverView setHidden:YES];
//        self.chatInputView.inputView.delegate = self;
    }
    return _chatInputView;
}

- (QMSatisfactionView *)satisfactionView {
    if (!_satisfactionView) {
        _satisfactionView = [[QMSatisfactionView alloc] init];
        _satisfactionView.hidden = YES;
    }
    return _satisfactionView;
}

//- (QMSatisfactionView1 *)satisfactionView {
//    if (!_satisfactionView) {
//        _satisfactionView = [[QMSatisfactionView1 alloc] init];
//        _satisfactionView.hidden = YES;
//    }
//    return _satisfactionView;
//}

- (QMAssociationInputView *)associationView {
    if (!_associationView) {
        _associationView = [[QMAssociationInputView alloc] init];
        _associationView.hidden = YES;
        __weak typeof(self)weakSelf = self;
        _associationView.associationBlock = ^(NSString * _Nonnull text) {
            [weakSelf sendTextMessage:text];
            weakSelf.associationView.hidden = YES;
            weakSelf.chatInputView.inputView.text = @"";
        };
    }
    return _associationView;
}

- (QMConnectStatusView *)connectView {
    if (!_connectView) {
        _connectView = [[QMConnectStatusView alloc] init];
    }
    return _connectView;
}


- (void)logoutAction {
    [[QMClient shared] disconnectSocket];
    [self.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)closeChat {
    [QMConnect sdkCloseChat:^{
        
    } failure:^(NSDictionary * _Nonnull reason) {
        
    }];
}

#pragma mark - tapAction
// 继续咨询
- (void)tapAction {

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    UIMenuController *menuVC = [UIMenuController sharedMenuController];
    if (menuVC.isMenuVisible) {
        if (@available(iOS 13.0, *)) {
            [menuVC hideMenu];
        } else {
            // Fallback on earlier versions
            [menuVC setMenuVisible:NO];
        }
    }
}

@end

@interface QMNavButton ()

@property (nonatomic, strong) NSMutableDictionary *titles;
@property (nonatomic, strong) NSMutableDictionary *images;
@property (nonatomic, strong) NSMutableDictionary *colors;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, assign) QMNavButtonImagePoint imagePoint;
@end

@implementation QMNavButton

- (instancetype)init {
    if (self = [super init]) {
        [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
        self.imagePoint = QMNavButtonImagePointLift;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.titleLab];
    [self addSubview:self.imageView];
//    self.layer.borderWidth = 3;
//    self.imageView.layer.borderWidth = 1;
//    self.titleLab.layer.borderWidth = 1;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).priorityHigh();
        make.width.height.mas_lessThanOrEqualTo(16).priorityHigh();
        make.right.lessThanOrEqualTo(self).offset(-30);
        make.top.equalTo(self).offset(8).priorityHigh();
        make.bottom.equalTo(self).offset(-8).priorityHigh();
        make.centerY.equalTo(self).priorityHigh();
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(4);
        make.right.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(1);
        make.centerY.equalTo(self);
    }];
    
}

- (void)setTextIsEmptyImagePoint:(QMNavButtonImagePoint)point {
    self.imagePoint = point;
    if (self.titleLab.text.length == 0) {
        [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(4);
            make.right.equalTo(self).offset(-5);
            make.width.mas_greaterThanOrEqualTo(1);
            make.centerY.equalTo(self);
        }];
        
        switch (point) {
            case QMNavButtonImagePointRight: {
                [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.mas_lessThanOrEqualTo(16).priorityHigh();
                    make.right.equalTo(self).priorityHigh();
                    make.top.equalTo(self).offset(8).priorityHigh();
                    make.left.equalTo(self).offset(10);
                    make.bottom.equalTo(self).offset(-8).priorityHigh();
                    make.centerY.equalTo(self).priorityHigh();
                }];
            }
                break;
                
            case QMNavButtonImagePointCenter: {
                [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self).priorityHigh();
                    make.width.height.mas_lessThanOrEqualTo(16).priorityHigh();
                    make.right.lessThanOrEqualTo(self).offset(-30);
                    make.top.equalTo(self).offset(8).priorityHigh();
                    make.bottom.equalTo(self).offset(-8).priorityHigh();
                    make.centerY.equalTo(self).priorityHigh();
                }];
            }
                break;
                
            default: {
                [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).priorityHigh();
                    make.width.height.mas_lessThanOrEqualTo(16).priorityHigh();
                    make.right.lessThanOrEqualTo(self).offset(-30);
                    make.top.equalTo(self).offset(8).priorityHigh();
                    make.bottom.equalTo(self).offset(-8).priorityHigh();
                    make.centerY.equalTo(self).priorityHigh();
                }];
            }
                break;
        }
    } else {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).priorityHigh();
            make.width.height.mas_lessThanOrEqualTo(16).priorityHigh();
            make.right.lessThanOrEqualTo(self).offset(-30);
            make.top.equalTo(self).offset(8).priorityHigh();
            make.bottom.equalTo(self).offset(-8).priorityHigh();
            make.centerY.equalTo(self).priorityHigh();
        }];
        [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(4);
            make.right.equalTo(self);
            make.width.mas_greaterThanOrEqualTo(1);
            make.centerY.equalTo(self);
        }];
    }
}


- (void)dealloc {
//    [self removeObserver:self forKeyPath:@"state"];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [self.titles setValue:title forKey:@(state).description];
    if (self.state == UIControlStateNormal) {
        self.titleLab.text = self.titles[@(UIControlStateNormal).description];
    }
    [self setTextIsEmptyImagePoint:self.imagePoint];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    if (image) {
        [self.images setObject:image forKey:@(state).description];
        if (self.state == UIControlStateNormal) {
            self.imageView.image = self.images[@(UIControlStateNormal).description];
        }
    } else {
        
    }
}

- (void)setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    if (url) {
        [self.imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [self.images setObject:image forKey:@(state).description];
            }
        }];
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    if (color) {
        [self.colors setObject:color forKey:@(state).description];
    }
    if (self.state == UIControlStateNormal) {
        self.titleLab.textColor = self.colors[@(UIControlStateNormal).description];
    }

}

- (NSMutableDictionary *)titles {
    if (!_titles) {
        _titles = [NSMutableDictionary dictionary];
    }
    return _titles;
}

- (NSMutableDictionary *)images {
    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (NSMutableDictionary *)colors {
    if (!_colors) {
        _colors = [NSMutableDictionary dictionary];
    }
    return _colors;
    
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:14];
    }
    return _titleLab;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return self;
}

@end
