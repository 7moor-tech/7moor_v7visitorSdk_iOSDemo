//
//  QMClient.h
//  moorV7SDK
//
//  Created by lishuijiao on 2021/1/5.
//

#import <Foundation/Foundation.h>
#import "QMMessageDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class QMClientModel;
@class QMClient;

@protocol QMClientDelegate <NSObject>

@end

typedef void(^QMServerConnectBlock)(QMClient *client);

@interface QMClient : NSObject

@property (nonatomic, strong) id<QMClientDelegate> delegete;

@property (nonatomic, strong) QMServerConnectBlock serverConnectBlock;

@property (nonatomic, strong) NSBundle *bundle;

+ (instancetype)shared;

- (void)initSDK:(void(^)(QMClientModel *server))block;
// 注册sdk 代理回调
- (void)initSDK:(id<QMRegisterDelegate>)delegate block:(void(^)(QMClientModel *server))block;
// 注册sdk block回调 目前@{success : value} value 0/1 1成功
- (void)initSDKWithModel:(void(^)(QMClientModel *server))block completion:(nullable void(^)(NSDictionary *))completion;


- (void)disconnectSocket;

- (void)disconnectSocket:(void(^)(BOOL isClose))completion;


@end

NS_ASSUME_NONNULL_END
