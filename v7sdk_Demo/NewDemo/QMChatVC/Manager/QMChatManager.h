//
//  QMChatManager.h
//  NewDemo
//
//  Created by lishuijiao on 2021/6/9.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


@protocol KStatusDelegate <NSObject>

- (void)chatStatus:(QMChatInformation *)information;

@end


@protocol ChatMessageDelegate <NSObject>

- (void)oneMessage:(NSString *)sessionId;
// 建议使用
- (void)oneMessage:(NSString *)sessionId messageId:(NSString *)messageId;

- (void)updateOneMessage:(QMMessageModel *)message withMessageIds:(NSArray *)messageIds;

- (void)updateMessageStatus:(NSDictionary *)statusInformation;

@end


@protocol ConenctStatusDelegate <NSObject>

- (void)connectStatus:(QMSocketConnectStatus)status;

@end


@interface QMChatManager : NSObject

+ (instancetype)shared;

@property (nonatomic, weak) id<KStatusDelegate> kDelegate;

// 消息delegate和addMessageDelegate 一样效果
@property (nonatomic, weak) id<ChatMessageDelegate> messageDelegate;

@property (nonatomic, weak) id<ConenctStatusDelegate> connectDelegate;

@property (nonatomic, strong) NSMutableArray <QMChatInformation*>*informations;

@property (nonatomic, strong) NSArray *bottomList;

- (void)setDelegate;

// 移除消息 delegate
- (void)removeMessageDelegate:(id<ChatMessageDelegate>)delegate;

// 添加消息 delegate
- (void)addMessageDelegate:(id<ChatMessageDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
