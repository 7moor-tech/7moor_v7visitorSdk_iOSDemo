//
//  QMChatRoomViewController+ChatMessage.h
//  NewDemo
//
//  Created by ZCZ on 2021/5/20.
//

#import "QMChatRoomViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMChatRoomViewController (ChatMessage) <AVAudioRecorderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, KStatusDelegate, ChatMessageDelegate>
// 发送消息
- (void)sendTextMessage:(NSString *)text;
- (void)sendImage:(UIImage *)image;
- (void)sendAudioMesage:(NSString *)fileName duration:(NSString *)duration;
- (void)sendCard;
//发送图片

// 发送附件
- (void)sendFileMessageWithName:(NSString *)fileName AndSize:(NSString *)fileSize AndPath:(NSString *)filePath;

- (void)sendCsrInviteMessage:(NSString *)text;

//- (void)satisfactionAction:(NSString *)messageId;
- (void)satisfactionAction:(NSString *)messageId sessionId:(NSString *)sessionId;

@end

NS_ASSUME_NONNULL_END
