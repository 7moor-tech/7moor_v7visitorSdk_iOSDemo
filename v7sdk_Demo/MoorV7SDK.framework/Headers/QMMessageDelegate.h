//
//  QMMessageDelegate.h
//  moorV7SDK
//
//  Created by lishuijiao on 2021/1/27.
//

#import <Foundation/Foundation.h>
#import "QMErrorCode.h"
#import "QMAgentInformation.h"
#import "QMMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QMRegisterDelegate <NSObject>

- (void)registerSuccess;

- (void)registerFailure:(NSDictionary *)reason;

@end

@protocol QMConnectStatusDelegate <NSObject>

- (void)socketConnectStatus:(QMSocketConnectStatus)status;

@end

@protocol QMServiceDelegate <NSObject>

@optional
- (void)newMessage:(NSString *)chatId;

@optional
- (void)newMessage:(NSString *)chatId messageId:(NSString *)messageId;

@optional
- (void)updateOneMessage:(QMMessageModel *)message withMessageIds:(NSArray *)messageIds;

@optional
- (void)sendMessageFailure:(NSString *)failureInformation;

@optional
- (void)updateMessageStatus:(NSDictionary *)statusInformation;

//@optional
//- (void)currentAgentStatus:(QMKStatus)status;
//
//@optional
//- (void)currentAgentInfo:(QMAgentInformation *)agent;
//
//@optional
//- (void)currentSessionWaitNumber:(int)number;
//
//@optional
//- (void)showSatisfactionBtn;
//
//@optional
///// 客服操作状态
///// @param status  客服操作项
///// @param array  返回参数
//- (void)agentOperationStatus:(QMKOperationStatus)status information:(NSArray *)array;
//
//////满意度评价
////@optional
////- (void)satisfactionEvaluation:(NSArray *)array;
//
////留言 -- 日程留言
//@optional
//- (void)leavemsg:(NSArray *)array;

@end

@protocol QMChatStatusDelegate <NSObject>

- (void)chatStatus:(QMChatInformation *)information;

@end
NS_ASSUME_NONNULL_END
