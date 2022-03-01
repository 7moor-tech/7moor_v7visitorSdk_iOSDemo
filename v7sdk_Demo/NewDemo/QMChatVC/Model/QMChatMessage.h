//
//  QMChatMessage.h
//  newDemo
//
//  Created by ZCZ on 2021/2/24.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import <moorV7SDK/moorV7SDK.h>
#import "QMLogistcsInfoModel.h"
NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    ChatMessageRev = 0,
    ChatMessageSend,
} ChatMessageMode;

typedef enum : NSUInteger {
    MessageTypeText = 0,
    MessageTypeFile,
    MessageTypeImage,
    MessageTypeVideo,
    MessageTypeAudio, // 语音包
    MessageTypeCall, // 语音通话
    MessageTypeCard, // 语音通话
    MessageTypeRemind, // 提示
    QMMessageTypeQuestion,
    QMMessageTypeSelect, // 双行点选
    QMMessageTypeCsrInvite, //满意度
    QMMessageTypeOrderCard, //卡片
    QMMessageTypeMsgTask, // 物流信息
    QMMessageTypeListCard, //卡片数组
    QMMessageTypeQuickMenu // 快捷问题
} QMMessageType;

@interface QMChatMessage : QMMessageModel

@property (nonatomic, copy) NSString *messageId;

@property (nonatomic, assign) ChatMessageMode type;
/// 是否显示日期
@property (nonatomic, assign) BOOL showDate;

@property (nonatomic, assign) QMMessageType eMessageType;
@property (nonatomic, strong) QMLogistcsInfoModel *msgTaskModel;
@property (nonatomic, strong) NSArray *mutSelectArr;


+ (QMChatMessage *)initFromMessage:(QMMessageModel *)message;

@end

NS_ASSUME_NONNULL_END
