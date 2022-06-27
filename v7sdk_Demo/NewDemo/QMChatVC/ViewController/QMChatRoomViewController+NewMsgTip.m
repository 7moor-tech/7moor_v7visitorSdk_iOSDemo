//
//  QMChatRoomViewController+NewMsgTip.m
//  NewDemo
//
//  Created by ZCZ on 2022/4/25.
//

#import "QMChatRoomViewController+NewMsgTip.h"
#import "UIImage+Color.h"

static void *key_nMsgScrollButton = &key_nMsgScrollButton;
static void *key_scrollTo_indexPath = &key_scrollTo_indexPath;
static void *key_settedEdgeInsets = &key_settedEdgeInsets;
static void *key_settedEnterColseTime = &key_settedEnterColseTime;
static void *key_settedEnterTimer = &key_settedEnterTimer;

static void *key_customEnteringView = &key_customEnteringView;


@interface QMChatRoomViewController ()
// newMessage scrollTip
@property (nonatomic, strong) UIButton *nMessageScrollButton;

// 预知输入
@property (nonatomic, strong) UILabel *customEnteringView;
@property (nonatomic, strong) NSTimer *enteringTimer;
@property (nonatomic, assign) int enterColseTime;
@end

@implementation QMChatRoomViewController (NewMsgTip)

- (BOOL)checkCanScroolCurrentOffSet {
    CGPoint offset = self.chatTableView.contentOffset;
    CGSize contentSize = self.chatTableView.contentSize;
    
    
    // 当当前offset 小于 contentSize 300时，在看历史不下移到最新
    BOOL canScroll = YES;
    if (contentSize.height - offset.y - self.chatTableView.frame.size.height > 300) {
        canScroll = NO;
    }
    
    if (canScroll == NO) {
        // 不可以滑动说明要显示tip了。而此时检测不用处理隐藏问题
        [self showNewMsgScrollButton];
    }
    
    return canScroll;
}

- (void)showNewMsgScrollButton {
    if (!self.nMessageScrollButton) {
        UIButton *scrollButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [scrollButton addTarget:self action:@selector(scrollToNewMessageLocal:) forControlEvents:UIControlEventTouchUpInside];        
        scrollButton.backgroundColor = [UIColor whiteColor];
        [scrollButton setImage:[UIImage imageNamed:@"show_more"] forState:UIControlStateNormal];
        scrollButton.clipsToBounds = YES;
        self.nMessageScrollButton = scrollButton;
    }
    
    if ([self.view.subviews containsObject:self.nMessageScrollButton] == NO) {
        [self.view addSubview:self.nMessageScrollButton];
        [self.nMessageScrollButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.chatInputView.mas_top).offset(-20);
            make.width.mas_equalTo(114);
            make.height.mas_equalTo(35);
        }];
        
        [self.nMessageScrollButton layoutIfNeeded];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.nMessageScrollButton.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft) cornerRadii:CGSizeMake(17.5, 17.5)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.nMessageScrollButton.bounds;
        maskLayer.path = maskPath.CGPath;
        self.nMessageScrollButton.layer.mask = maskLayer;

    }
    
    NSArray *msgDatas = self.dataSource;
    int count = 0;
    for (NSUInteger index = msgDatas.count - 1; index >= 0; index--) {
        QMChatMessage *model = msgDatas[index];
        if (model.newMsg == NO) {
            break;
        } else {
            self.scrollTo_indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            count += 1;
        }
    }
    
    NSString *buttonStr = [NSString stringWithFormat:@"  %d条新消息", count];
    [self.nMessageScrollButton setTitle:buttonStr forState:UIControlStateNormal];
    
}

- (void)hiddenMessageScrollButtopn {
    if (self.nMessageScrollButton.superview) {
        [self.nMessageScrollButton removeFromSuperview];
        [self handleDataMessageNewMsg];
    }
}

- (void)handleDataMessageNewMsg {
    
    // 尝试枷锁，未成功--说明已经在loadnew函数中执行，已在锁中
    BOOL isLocked = self.dataLock.tryLock;
    
    for (NSUInteger index = self.dataSource.count - 1; index > 0; index--) {
        QMChatMessage *model = self.dataSource[index];
        if (model.newMsg == YES) {
            model.newMsg = NO;
        }
    }
    
    if (isLocked) {
        NSLog(@"锁上了");
        [self.dataLock unlock];
    } else {
        NSLog(@"没锁上了");
    }
}

- (void)scrollToNewMessageLocal:(UIButton *)sender {
    [self handleDataMessageNewMsg];
    if (self.scrollTo_indexPath.row < self.dataSource.count) {
        self.settedEdgeInsets = self.chatTableView.contentInset;
        UIEdgeInsets edgeInsets = self.settedEdgeInsets;
        if (self.scrollTo_indexPath.row < self.dataSource.count - 1 && edgeInsets.bottom < 20) {
            edgeInsets.bottom += 25;
        }
        UITableViewScrollPosition position = UITableViewScrollPositionBottom;
        [UIView performWithoutAnimation:^{
            self.chatTableView.contentInset = edgeInsets;
            [self.chatTableView scrollToRowAtIndexPath:self.scrollTo_indexPath atScrollPosition:position animated:YES];
        }];
        
        if (edgeInsets.bottom != self.settedEdgeInsets.bottom) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.chatTableView.contentInset = self.settedEdgeInsets;
            });
        }
    }
}

- (void)setNMessageScrollButton:(UIButton *)nMessageScrollButton {
    objc_setAssociatedObject(self, &key_nMsgScrollButton, nMessageScrollButton, OBJC_ASSOCIATION_RETAIN);
}

- (UIButton *)nMessageScrollButton {
    return objc_getAssociatedObject(self, &key_nMsgScrollButton);
}

- (void)setScrollTo_indexPath:(NSIndexPath *)scrollTo_indexPath {
    objc_setAssociatedObject(self, &key_scrollTo_indexPath, scrollTo_indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)scrollTo_indexPath {
    return objc_getAssociatedObject(self, &key_scrollTo_indexPath);
}

- (void)setSettedEdgeInsets:(UIEdgeInsets)settedEdgeInsets {
    objc_setAssociatedObject(self, &key_settedEdgeInsets, [NSValue valueWithUIEdgeInsets:settedEdgeInsets], OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)settedEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &key_settedEdgeInsets);
    UIEdgeInsets edgeInsets = [value UIEdgeInsetsValue];
    return edgeInsets;
}



// 预知输入开始
- (void)addToPredicttheInputNotification {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(predictTheInputNotification:) name:CUSTOM_PredictTheInputNotification object:nil];
}

- (void)removeToPredicttheInputNotification {
    [NSNotificationCenter.defaultCenter removeObserver:self name:CUSTOM_PredictTheInputNotification object:nil];
}

- (void)predictTheInputNotification:(NSNotification *)notification {
//    NSDictionary *objc = notification.object;
//    if (objc && [objc isKindOfClass:NSDictionary.class]) {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.enterColseTime = 4;
        [self addCustomEnteringView];
        if (self.enteringTimer == nil || self.enteringTimer.isValid == false) {
            __weak typeof(self)wSelf = self;
            self.enteringTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                wSelf.enterColseTime -= 1;
                if (wSelf.enterColseTime <= 0) {
                    [timer invalidate];
                    [wSelf removeCustomEnteringView];
                }
            }];
        }
    });
//    } else {
//        [self removeCustomEnteringView];
//    }
}

- (void)addCustomEnteringView {
    
    if (!self.customEnteringView) {
        UILabel *lab = [UILabel new];
        lab.backgroundColor = UIColor.clearColor;
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = QMHEXRGB(0x999999);
        lab.text = @"客服正在输入...".toLocalized;
        self.customEnteringView = lab;
    }
    
    if (![self.view.subviews containsObject:self.customEnteringView]) {
        [self.view addSubview:self.customEnteringView];
        [self.customEnteringView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(8);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.chatTableView);
        }];
    }
    
    [self.view bringSubviewToFront:self.customEnteringView];
    
}

- (void)removeCustomEnteringView {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.enteringTimer) {
            [self.enteringTimer invalidate];
            self.enteringTimer = nil;
        }
        [self.customEnteringView removeFromSuperview];
    });
}

- (void)setCustomEnteringView:(UILabel *)customEnteringView {
    objc_setAssociatedObject(self, &key_customEnteringView, customEnteringView, OBJC_ASSOCIATION_RETAIN);
}

- (UILabel *)customEnteringView {
    return objc_getAssociatedObject(self, &key_customEnteringView);
}

- (void)setEnterColseTime:(int)enterColseTime {
    objc_setAssociatedObject(self, &key_settedEnterColseTime, @(enterColseTime), OBJC_ASSOCIATION_ASSIGN);
}

- (int)enterColseTime {
    int time = [objc_getAssociatedObject(self, &key_settedEnterColseTime) intValue];
    return time;
}

- (void)setEnteringTimer:(NSTimer *)enteringTimer {
    objc_setAssociatedObject(self, &key_settedEnterTimer, enteringTimer, OBJC_ASSOCIATION_RETAIN);
}

- (NSTimer *)enteringTimer {
    return objc_getAssociatedObject(self, &key_settedEnterTimer);
}

@end
