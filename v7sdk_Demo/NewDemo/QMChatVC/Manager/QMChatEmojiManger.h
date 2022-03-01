//
//  QMChatEmojiManger.h
//  NewDemo
//
//  Created by ZCZ on 2021/5/24.
//

#import <Foundation/Foundation.h>
#import "QMChatEmoji.h"

NS_ASSUME_NONNULL_BEGIN



@interface QMChatEmojiManger : NSObject

@property (nonatomic, strong) NSArray <QMChatEmoji *>*emojiList;
// key:value = name:image
@property (nonatomic, strong) NSDictionary *emojisDict;

+ (instancetype)shared;


- (void)handleEmojiData:(NSDictionary *)dataDict completion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
