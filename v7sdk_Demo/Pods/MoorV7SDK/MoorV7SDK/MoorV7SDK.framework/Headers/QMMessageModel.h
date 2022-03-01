//
//  QMMessageModel.h
//  moorV7SDK
//
//  Created by lishuijiao on 2021/3/9.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    QMChatRobotMessageTypeFlowList = 0,
    QMChatRobotMessageTypeFinger,
    QMChatRobotMessageTypeSingleLine,
    QMChatRobotMessageTypeDoubleLine,
    QMChatRobotMessageTypeLevelScroll,
    QMChatRobotMessageTypeMultiSelect,
    QMChatRobotMessageTypeSelectButtonRow,
    QMChatRobotMessageTypeForm,
    QMChatRobotMessageTypeQuestionsGroup

} QMChatRobotMessageType;


@interface QMQuickMenu : NSObject
@property (nonatomic, assign) int button_type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) int enable;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *name;
@end

@interface QMMessageModel : NSObject

//@property (nonatomic, strong)QMClientModel *clientModel;

@property (nonatomic, copy) NSString *accessId;
// 头像
@property (nonatomic, copy) NSString *userHeadImg;

@property (nonatomic, copy) NSString *visitorHeadImg;

//注册时的userid
@property (nonatomic, copy) NSString *registUserId;

//消息体返回的userid
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *visitorId;
/**
 消息id
 */
@property (nonatomic, copy) NSString *_id;

/**
 消息类型
 */
@property (nonatomic, copy) NSString *messageType;

/**
 消息内容
 */
@property (nonatomic, copy) NSString *content;
// 其他链接
@property (nonatomic, copy) NSString *answer;
// 点赞点踩使用
@property (nonatomic, copy) NSString *questionId;
@property (nonatomic, strong) NSAttributedString *contentAttr;
// 两行显示中间有隔断时使用
@property (nonatomic, strong) NSAttributedString *contentAttr2;

@property (nonatomic, strong) NSDictionary *formDict;

// 常见问题
@property (nonatomic, strong) NSArray *commonQuestionsGroup;
// 常见问题
@property (nonatomic, copy) NSString *commonQuestionsImg;

// 富文本问题点击事件
@property (nonatomic, strong) NSArray *flowList;
// 问问题答案
@property (nonatomic, copy) NSString *flowTips;
// list 0 1 2
@property (nonatomic, copy) NSString *flowType;
//按钮形式时 一列布局“1” 二列布局“0” 文本链接布局"2"
@property (nonatomic, copy) NSString *flowStyle;

// 富文本图片是否替换成功 0/不需要替换 1/替换 2/替换成功
@property (nonatomic, assign) int attrAttachmentReplaced;

// 是否多选类型
@property (nonatomic, assign) BOOL flowMultiSelect;

// 点赞点踩
@property (nonatomic, copy) NSString *fingerDown;
@property (nonatomic, copy) NSString *fingerUp;
// 0 未点击，1 点赞，2 点踩
@property (nonatomic, assign) int fingerSelected;
// 是否是标签文本
@property (nonatomic, assign) int isShowHtml;
// 物流信息
@property (nonatomic, copy) NSString *msgTask;


@property (nonatomic, assign) QMChatRobotMessageType robotMessageType;

/**
 消息时间
 */
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSTimeInterval createTimestamp;
// 快速问题
@property (nonatomic, strong) NSArray *quickMenu;

// 消息已读
@property (nonatomic, copy) NSString *dealUser;

@property (nonatomic, copy) NSString *platform;

/**
 会话id(查询数据库消息)
 */
@property (nonatomic, copy)NSString *sessionId;

/**
 消息来源 访客 or 坐席@"1"
 */
@property (nonatomic, copy)NSString *fromType;

/**
 消息发送状态 成功 or 失败 or 发送中 0/发送成功。1/发送失败。2/发送中
 */
@property (nonatomic, copy)NSString *status;

/**
 消息是否来源于机器人  机器人@"1" 非机器人@"2"
 */
@property (nonatomic, copy)NSString *isRobot;

/**
 消息类型，系统消息-system、机器人消息-robot、人工消息-UUID、我自己发的消息-my
 */
@property (nonatomic, copy)NSString *userType;

/**
 消息是否已读 已读@"1" 未读@"0"
 */
@property (nonatomic, copy)NSString *isRead;

/**
 文件名
 */
@property (nonatomic, copy) NSString *fileName;

/**
 文件尺寸
 */
@property (nonatomic, copy) NSString *fileSize;

/**
 文件大小(KB、MB)
 */
@property (nonatomic, copy) NSString *qualitySize;

/**
 文件下载状态
 */
@property (nonatomic, copy) NSString *downloadState;

/**
 本地文件缓存相对路径
 */
@property (nonatomic, copy) NSString *localFilePath;

/**
 语音时长
 */
@property (nonatomic, copy) NSString *duration;

/**
 图片、语音、附件的远程地址
 */
@property (nonatomic, copy) NSString *fileUrl;


/**
 满意度是否评价
 */
@property (nonatomic, copy) NSString *invite;

// 标识不能处理点击-点赞之类的消息
@property (nonatomic, assign) BOOL cannotSelectMessage;


/**
 机器人点踩点赞问题
 */
@property (nonatomic, copy) NSString *robotId;
@property (nonatomic, copy) NSString *robotType;
@property (nonatomic, copy) NSString *oriQuestion;
@property (nonatomic, copy) NSString *stdQuestion;
@property (nonatomic, copy) NSString *confidence;

/**
 订单卡片
 */
@property (nonatomic, copy) NSDictionary *orderCard;

/**
 卡片列表
 */
@property (nonatomic, copy) NSArray *listCards;


+ (instancetype)jsonDataToQMMessageModel:(NSDictionary *)dictionary;


@end






NS_ASSUME_NONNULL_END
