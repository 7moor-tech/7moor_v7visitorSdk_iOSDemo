//
//  QMConnect.h
//  moorV7SDK
//
//  Created by lishuijiao on 2021/1/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QMMessageDelegate.h"

@class QMMessageModel;

NS_ASSUME_NONNULL_BEGIN

@interface QMConnect : NSObject

+ (NSString *)getSDKVersion;

/// 获取历史消息
/// @param lastTime 最后一条消息时间
/// @param completion 成功
/// @param failure 失败
+ (void)sdkGetListMsg:(NSString *)lastTime completion:(void (^)(void))completion failure:(void (^)(NSError *))failure;


+ (void)sendMessage:(QMMessageModel *)message delegate:(id<QMServiceDelegate>)delegate;

+ (void)sendText:(NSString *)text;

+ (void)sendImage:(UIImage *)image;

+ (void)sendAudio:(NSString *)filePath duration:(NSString *)duration;

+ (void)sendFile:(NSString *)filePath fileName:(NSString *)fileName fileSize:(NSString *)fileSize progressHander:(void(^)(float,NSString*))progressHander;

+ (void)sendCsrInviteMessage:(NSString *)text;
+ (void)sendRemindMessage:(NSString *)text;

+ (void)sendOrderCard:(NSDictionary *)orderCard;

+ (void)sendListCard:(NSArray *)listCard;

+ (void)reSendMessage:(QMMessageModel *)message;

//+ (NSArray<QMMessageModel *> *)getAccessidAllDataFormDatabase:(int)number;

#pragma mark - 数据库
+ (NSArray<QMMessageModel *> *)getAllDataFormDatabase:(int)number;
// 向前取
+ (NSArray<QMMessageModel *> *)getDataFormDatabase:(int)number withCreatTime:(NSString *)creatTime;
// 
+ (QMMessageModel *)getDataFormDatabasewithMessageId:(NSString *)messageId;

// 取大于当前时间
+ (NSArray<QMMessageModel *> *)getNewDataFormDatabaseWithCreatTime:(NSString *)creatTime;

+ (BOOL)sdkUpdateMessageFingerSelected:(QMMessageModel *)model;
// 更改点赞消息能不能点击
+ (BOOL)sdkUpdateFingerMessageCannotSelected:(BOOL)cannotSelected;
+ (BOOL)sdkUpdateInviteStatus:(NSString *)invite withMessage:(NSString *)messageId;
+ (BOOL)sdkDeleteListCards;

#pragma mark - 聊天Emoji表情
+ (void)sdkGetEmojiRUL:(void (^)(NSDictionary *data))completion failure:(void (^)(NSDictionary *error))failure;

+ (void)sdkNewChat:(void (^)(NSDictionary *data))completion failure:(void (^)(NSDictionary *error))failure;
+ (void)sdkNewSession:(void (^)(NSDictionary *))completion failure:(void (^)(NSDictionary *))failure;
+ (void)sdkSatisfaction:(void (^)(NSDictionary *data))completion failure:(void (^)(NSDictionary *reason))failure;

+ (void)sdkCheckCSRStatus:(NSString *)messageId sessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *data))completion failure:(void (^)(NSDictionary *reason))failure;

+ (void)sdkSendCSRMsg:(NSDictionary *)satis completion:(void (^)(void))completion failure:(void (^)(NSDictionary *reason))failure;

+ (void)sdkInputSuggest:(NSString *)text completion:(void (^)(NSDictionary *data))completion failure:(void (^)(NSDictionary *reason))failure;

+ (void)sdkConvertManual:(void (^)(void))completion failure:(void (^)(NSDictionary *reason))failure;


+ (void)sdkSendFile:(NSDictionary *)fileDic progress:(void (^)(float, NSString *))progress success:(void (^)(NSString *))success failBlock:(void (^)(NSString *))failure;
/*
 更改表单消息
 0 消息第一次插入数据库 用于弹出消息
 1 已存在 不需要弹出
 2 已提交 不能点击弹出
 **/
+ (void)sdkUpdateFormStatus:(NSString *)status withMessageID:(NSString *)messageId;

/*
 提交表单消息
 **/
+ (void)sdkSubmitFormMessage:(NSDictionary *)dic completion:(void (^)(NSString * fileUrl))completion failure:(void (^)(NSString *reason))failure;

+ (void)sdkCloseChat:(void (^)(void))completion failure:(void (^)(NSDictionary *reason))failure;
/**
 下载消息中的文件：
 
 param message:         消息实例
 param localFilePath:   沙盒文件相对路径
 param progress:        下载进度回调
 param successBlock:    成功回调
 param failBlock:       失败回调
 */
+ (void)downloadFileWithMessage:(QMMessageModel *)message
                  localFilePath:(NSString *)filePath
                 progressHander:(void (^)(float))progress
                   successBlock:(void (^)(void))success
                      failBlock:(void (^)(NSString *))failure;


+ (void)downloadFileWithUrl:(NSString *)url
               successBlock:(void (^)(void))success
                  failBlock:(void (^)(NSString *))failure;

/**
  点赞点踩方法

 */
+ (void)sdkRobotfeedbackParam:(NSDictionary *)param completion:(void (^)(id dict))completion failure:(void (^)(NSError *))failure;

+ (void)sdkStatusDelegate:(id<QMChatStatusDelegate>)delegate;

+ (void)sdkConnectDelegate:(id<QMConnectStatusDelegate>)delegate;

+ (void)sdkServiceDelegate:(id<QMServiceDelegate>)delegate;

/**
 获取通用配置
 1.主题色
 2.按钮显示权限
 3.图标url地址
 */
+ (void)sdkGetThemeConfig:(NSDictionary *)param completion:(void (^)(id dict))completion failure:(void (^)(NSError *))failure;
/**
 取消排队
 参数 sessionId 
 */
+ (void)sdkCancelQueue:(NSString *)sessionId completion:(void (^)(id dict))completion failure:(void (^)(NSError *))failure;
/**
 访客预知输入
 */

+ (void)sdkInputTypeNotice:(NSString *)text completion:(void (^)(NSDictionary *))completion failure:(void (^)(NSError * _Nullable ))failure;
/**
 用于触发链接状态的代理
 点击状态栏时检查
 */
+ (void)sdkGetConnectStatus;

/**
 点击重连按钮使用
 */
+ (void)sdkReConnect;
+ (NSString *)sdkGetQiniuURL;
+ (NSString *)sdkGetCommonURL;

/**
 查询坐席的未消费的消息
 */
+ (NSArray *) sdkGetAgentMessageWithIsRead;

/**
 消费未读消息
 */
+ (void)sdkDealImMsgWithMessageID:(NSArray *)messageID;

/**
 传入 image boundle
 */
+ (void)sdkReceiveImageBundle:(NSBundle *)aBundle;

@end

NS_ASSUME_NONNULL_END
