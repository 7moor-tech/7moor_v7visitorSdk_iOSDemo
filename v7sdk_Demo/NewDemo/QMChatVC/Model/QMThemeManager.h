//
//  QMRoomUIModel.h
//  newDemo
//
//  Created by lishuijiao on 2021/2/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class QMIconModel;
@class QMColorModel;

typedef enum : NSUInteger {
    QMMsgHeadImgAngleTypeRectAngle,
    QMMsgHeadImgAngleTypeRound,
    QMMsgHeadImgAngleTypeNone,
} QMMsgHeadImgAngleType;

@interface QMThemeManager : NSObject <NSCopying>

// 访客预知输入开关
@property (nonatomic, assign) BOOL isVisitorTypeNotice;

//导航颜色
@property (nonatomic, strong) QMColorModel *naviColorModel;
@property (nonatomic, strong) QMColorModel *mainColorModel;
@property (nonatomic, strong) QMColorModel *leftMsgBgColor;
@property (nonatomic, strong) QMColorModel *rightMsgBgColor;

@property (nonatomic, strong) QMColorModel *leftMsgTextColor;
@property (nonatomic, strong) QMColorModel *rightMsgTextColor;

@property (nonatomic, copy) NSString *sdkTitleBarText;
@property (nonatomic, copy) NSString *leftTitleBtnText;

@property (nonatomic, copy) NSString *leftTitleBtnImgUrl;

@property (nonatomic, copy) NSString *topNoticeText;


@property (nonatomic, assign) BOOL isTransferSeatsShow;
@property (nonatomic, assign) BOOL isCloseSeatsSessionShow;



//转人工文字
@property (nonatomic, copy) NSString *transferSeatsBtnText;
@property (nonatomic, copy) NSString *transferSeatsBtnImgUrl;

@property (nonatomic, copy) NSString *closeSeatsSessionBtnText;
@property (nonatomic, copy) NSString *closeSeatsSessionBtnImgUrl;


@property (nonatomic, copy) NSString *sysMsgHeadImgUrl;

@property (nonatomic, copy) NSString *msgHeadImgType;
@property (nonatomic, assign) QMMsgHeadImgAngleType msgHeadImgAngle;


@property (nonatomic, copy) NSString *inputViewHintText;

@property (nonatomic, assign) BOOL isVoiceBtnShow;
@property (nonatomic, copy) NSString *isVoiceBtnImgUrl;
@property (nonatomic, assign) BOOL isEmojiBtnShow;
@property (nonatomic, copy) NSString *isEmojiBtnImgUrl;

@property (nonatomic, copy) NSString *moreFunctionImgUrl;

@property (nonatomic, copy) NSString *showKeyboardImgUrl;
@property (nonatomic, copy) NSString *sendMsgBtnImgUrl;
@property (nonatomic, copy) NSString *account;


//转人工颜色
@property (nonatomic, strong) UIColor *manualColor;

//注销文字
@property (nonatomic, copy) NSString *logoutTitle;

//注销颜色
@property (nonatomic, strong) UIColor *logoutColor;

//声音按钮是否显示
@property (nonatomic, assign) BOOL isHiddenVoiceBtn;

//表情按钮是否显示
@property (nonatomic, assign) BOOL isHiddenFaceBtn;

//扩展按钮是否显示
@property (nonatomic, assign) BOOL isHiddenAddBtn;

//图片按钮是否显示
@property (nonatomic, assign) BOOL isHiddenPictureBtn;

//拍照按钮是否显示
@property (nonatomic, assign) BOOL isHiddenCameraBtn;
//视频按钮是否显示
@property (nonatomic, assign) BOOL isHiddenVideoBtn;

//文件按钮是否显示
@property (nonatomic, assign) BOOL isHiddenFileBtn;

//常见问题按钮是否显示
@property (nonatomic, assign) BOOL isHiddenQuestionBtn;

//满意度评价按钮是否显示
@property (nonatomic, assign) BOOL isHiddenEvaluateBtn;

//已读未读 UI 是否显示
@property (nonatomic, assign) BOOL isShowRead;

//卡片按钮是否显示
@property (nonatomic, assign) BOOL isHiddenCardBtn;
//聊天头像
@property (nonatomic, strong) QMIconModel *iconModel;


@property (nonatomic, assign) BOOL qmDarkStyle;

+ (instancetype)shared;

+ (void)setNavigationColor:(UIColor *)color;
- (void)saveNavColorToDoc;

- (void)handelNetThemeColor:(NSDictionary *)themes;

@end


@interface QMIconModel : NSObject

//聊天头像是否显示
@property (nonatomic, assign) BOOL isIcon;

//是否圆角
@property (nonatomic, assign) BOOL isToBounds;

//圆角值
@property (nonatomic, assign) NSInteger cornerRadius;

@end

@interface QMColorModel : NSObject <NSCopying>

@property (nonatomic, copy) NSString *hexColor;
@property (nonatomic, assign, readonly) NSUInteger red;
@property (nonatomic, assign, readonly) NSUInteger green;
@property (nonatomic, assign, readonly) NSUInteger blue;
@property (nonatomic, assign, readonly) NSUInteger alpha;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL hasBeenSetColor;

// 0~1;
- (UIColor *)color:(CGFloat)alpha;

@end


NS_ASSUME_NONNULL_END
