//
//  QMChatEmojiManger.m
//  NewDemo
//
//  Created by 张传章 on 2021/5/24.
//

#import "QMChatEmojiManger.h"

@interface QMChatEmojiManger ()
@property (nonatomic, strong) NSArray *emojisDict;
@end

@implementation QMChatEmojiManger

+ (instancetype)shared {
    static id _qm_chat_emoji_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _qm_chat_emoji_manager = [QMChatEmojiManger new];
    });
    return _qm_chat_emoji_manager;
}

- (NSArray *)emojiList {
    if (!_emojiList) {
        UIImage *image1 = [UIImage imageNamed:@"testemoji"];
        NSArray *imageArr = [image1 clipImage:CGSizeMake(50, 50)];
        int index = 0;
        NSMutableArray *items = [NSMutableArray array];
        for (UIImage *img in imageArr) {
            QMChatEmoji *item = [QMChatEmoji new];
            item.image = img;
            item.name = @(index).description;
            index ++;
            [items addObject:item];
        }
        
        _emojiList = items;
    }
    return _emojiList;
}


@end

@implementation QMChatEmoji



@end
