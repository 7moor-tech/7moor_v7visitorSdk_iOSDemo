//
//  QMChatManager.m
//  NewDemo
//
//  Created by lishuijiao on 2021/6/9.
//

#import "QMChatManager.h"
#import "QMChatRoomViewController.h"
@interface QMChatManager () <QMServiceDelegate, QMChatStatusDelegate, QMConnectStatusDelegate>
@property (nonatomic, strong) NSHashTable *delegateArr;
@property (nonatomic, strong) NSLock *delegateLock;

@end

@implementation QMChatManager

+ (instancetype)shared {
    static QMChatManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];

        [instance setDelegate];
    });
    return instance;
}

- (void)setDelegate {
    self.informations = [NSMutableArray array];
    [QMConnect sdkStatusDelegate:self];
    [QMConnect sdkConnectDelegate:self];
    [QMConnect sdkServiceDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatBottomList:) name:@"CHATBOTTOMLIST" object:nil];
}

- (void)chatBottomList:(NSNotification *)notif {
    NSArray *bottomList = (NSArray *)notif.object;
    self.bottomList = bottomList;
}

- (void)setMessageDelegate:(id<ChatMessageDelegate>)messageDelegate {
    if (messageDelegate) {
        [self.delegateLock lock];
        [self.delegateArr addObject:messageDelegate];
        [self.delegateLock unlock];
    }
}

- (void)addMessageDelegate:(id<ChatMessageDelegate>)delegate {
    if (delegate) {
        [self.delegateLock lock];
        [self.delegateArr addObject:delegate];
        [self.delegateLock unlock];
    }
}

- (void)removeMessageDelegate:(id<ChatMessageDelegate>)delegate {
    if (delegate) {
        [self.delegateLock lock];
        [self.delegateArr removeObject:delegate];
        [self.delegateLock unlock];
    }
}

#pragma mark -- QMChatStatusDelegate
- (void)chatStatus:(QMChatInformation *)information {
    if (self.kDelegate && [self.kDelegate respondsToSelector:@selector(chatStatus:)]) {
        [self.kDelegate chatStatus:information];
    } else {
        if (information) {
            [self.informations addObject:information];
        }
    }
}

#pragma mark -- QMServiceDelegate
- (void)newMessage:(NSString *)chatId messageId:(nonnull NSString *)messageId {
    
    NSHashTable *set = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];

    for (id objct in self.delegateArr) {
        
        if ([objct conformsToProtocol:@protocol(ChatMessageDelegate)]) {
            if ([objct respondsToSelector:@selector(oneMessage:messageId:)]) {
                [objct oneMessage:chatId messageId:messageId];
            } else if ([objct respondsToSelector:@selector(oneMessage:)]) {
                [objct oneMessage:chatId];
            }
        } else {
            [set addObject:objct];
        }
    }

    [self removeRepetitionDelete:set];
}

- (void)newMessage:(NSString *)chatId {
    
    NSHashTable *set = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    
    for (id objct in self.delegateArr) {
        
        if ([objct conformsToProtocol:@protocol(ChatMessageDelegate)]) {
            if ([objct respondsToSelector:@selector(oneMessage:)]) {
                [objct oneMessage:chatId];
            }
        } else {
            [set addObject:objct];
        }
    }
    
    [self removeRepetitionDelete:set];
}

- (void)updateMessageStatus:(NSDictionary *)statusInformation {

    NSHashTable *set = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    for (id objct in self.delegateArr) {
 
        if ([objct conformsToProtocol:@protocol(ChatMessageDelegate)]) {
            if ([objct respondsToSelector:@selector(updateMessageStatus:)]) {
                [objct updateMessageStatus:statusInformation];
            }
        } else {
            [set addObject:objct];
        }
    }

    [self removeRepetitionDelete:set];
}

- (void)updateOneMessage:(QMMessageModel *)message withMessageIds:(NSArray *)messageIds {

    NSHashTable *set = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    for (id objct in self.delegateArr) {

        if ([objct conformsToProtocol:@protocol(ChatMessageDelegate)]) {
            
            if ([objct respondsToSelector:@selector(updateOneMessage:withMessageIds:)]) {
                [objct updateOneMessage:message withMessageIds:messageIds];
            }
        } else {
            [set addObject:objct];
        }
    }
    [self removeRepetitionDelete:set];
}

- (void)removeRepetitionDelete:(NSHashTable *)set {
    if (set.count > 0) {
        for (id value in set) {
            [self.delegateArr removeObject:value];
        }
    }
}

#pragma mark -- QMConnectStatusDelegate
- (void)socketConnectStatus:(QMSocketConnectStatus)status {
    if (self.connectDelegate && [self.connectDelegate respondsToSelector:@selector(connectStatus:)]) {
        [self.connectDelegate connectStatus:status];
    }
}

#pragma mark -- setter
- (NSHashTable *)delegateArr {
    if (!_delegateArr) {
        _delegateArr = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return _delegateArr;
}

- (NSLock *)delegateLock {
    if (!_delegateLock) {
        _delegateLock = [[NSLock alloc] init];
    }
    return _delegateLock;
}

@end
