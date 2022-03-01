//
//  QMChatBaseCell.h
//  newDemo
//
//  Created by lishuijiao on 2021/2/4.
//

#import <UIKit/UIKit.h>
#import "QMChatMessage.h"
#import "QMCircleView.h"
NS_ASSUME_NONNULL_BEGIN

@interface QMChatBaseCell : UITableViewCell

//左侧头像(接收消息的头像)
@property (nonatomic, strong) UIImageView *avaterView;
@property (nonatomic, strong) UILabel *serviceLab;

//右侧头像(自己发送消息的头像)
//@property (nonatomic, strong) UIImageView *rightImage;

//消息发送状态
@property (nonatomic, strong) UIButton *sendStatus;

//消息背景
@property (nonatomic, strong) UIView *bubblesBgView;

//时间
@property (nonatomic, strong) UILabel *timeLabel;

//已读状态
@property (nonatomic, strong) UIImageView *readStatus;

//未读状态
@property (nonatomic, strong) QMCircleView *unReadStatus;

@property (nonatomic, strong) QMChatMessage *message;

// 更新布局 设置QMChatMessage 会更新数据源
@property (nonatomic, copy) void(^upCellConstraint)(QMChatMessage * _Nullable);
// 发送消息
@property (nonatomic, copy) void(^sendText)(NSString *text);
// 打开url
@property (nonatomic, copy) void(^pushWebView)(NSURL *url);

- (void)setCellData:(QMChatMessage *)model;
- (void)setupSubviews;
- (void)setupGestureRecognizer;
// 单点事件
- (void)setupTapRecognizer;
- (void)tapRecognizerAction;
- (void)revocation:(id)sender;
- (void)setMessageIsRead:(NSString *)isRead;

@end

NS_ASSUME_NONNULL_END
