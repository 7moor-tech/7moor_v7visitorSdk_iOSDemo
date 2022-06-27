//
//  QMChatRoomViewController.h
//  newDemo
//
//  Created by lishuijiao on 2021/2/2.
//

#import <UIKit/UIKit.h>
#import "QMChatMessage.h"
#import "QMChatInputView.h"
//view
#import "QMChatMoreView.h"
#import "QMChatFaceView.h"
#import "QMSatisfactionModel.h"
#import "QMSatisfactionView.h"
#import "QMAssociationInputView.h"

//#import "QMSatisfactionView1.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    QMNavButtonImagePointLift,
    QMNavButtonImagePointRight,
    QMNavButtonImagePointCenter,
} QMNavButtonImagePoint;

typedef enum : NSUInteger {
    QMChatServiceModeNone,
    QMChatServiceModeRobot,
    QMChatServiceModeCustomer,
} QMChatServiceMode;

@interface QMNavButton : UIControl

@property (nonatomic, strong) UIImageView *imageView;

- (void)setTextIsEmptyImagePoint:(QMNavButtonImagePoint)point;

- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state;                     // default is nil. title is assumed to be single line
- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state UI_APPEARANCE_SELECTOR; // default is nil. use opaque white
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state;                      // default is nil. should be same size if different for different states
- (void)setImageWithURL:(nullable NSURL *)url forState:(UIControlState)state;                      // default is nil. should be same size if different for different states


@end



@interface QMChatRoomViewController : UIViewController

@property (nonatomic, strong) NSMutableArray <QMChatMessage *>*dataSource;
@property (nonatomic, strong) UITableView *chatTableView; //消息列表
@property (nonatomic, strong) QMChatInputView *chatInputView;


@property (nonatomic, strong) QMSatisfactionView *satisfactionView; //满意度view
//@property (nonatomic, strong) QMSatisfactionView1 *satisfactionView; //满意度view

@property (nonatomic, strong) QMSatisfactionModel *satisfactionModel;

@property (nonatomic, strong) QMAssociationInputView *associationView; //联想输入view

@property (nonatomic, copy) void(^progressBlock)(NSString *, float);

@property (nonatomic, strong) QMNavButton *manualButotn; // 转人工按钮

@property (nonatomic, assign) BOOL isRobot;

@property (nonatomic, assign) QMChatServiceMode serviceMode;

@property (nonatomic, strong) QMChatInformation *currentChatInfor; //当前服务对象信息

@property (nonatomic, assign) BOOL isAssociationInput; //联想输入是否开启
@property (nonatomic, strong) NSRecursiveLock *dataLock;


// 已读时间点--之前全部标记已读
@property (nonatomic, assign) NSTimeInterval readTimeIntervall;

//@property (nonatomic, strong) UIButton *nMessageScrollButton;


// 第一次加载数据
- (void)loadDatas;
// 新消息
- (void)loadNewMessageData:(nullable NSString *)messageId;
- (void)customClick;
- (void)setCannotSelectFingerAndMutiSelect;
- (void)inputSuggest:(NSString *)text;
- (void)sendListCards;
//+ (instancetype)initRoomVC:(void(^)(QMRoomUIModel *server))block;

@end


NS_ASSUME_NONNULL_END
