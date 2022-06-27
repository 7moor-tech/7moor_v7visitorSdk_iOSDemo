//
//  QMChatEmojiManger.m
//  NewDemo
//
//  Created by ZCZ on 2021/5/24.
//

#import "QMChatEmojiManger.h"
#import <SDWebImage/SDWebImage.h>
@interface QMChatEmojiManger ()
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

- (void)handleEmojiData:(NSDictionary *)dataDict completion:(void(^)(void))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *elvesFigureUrl = dataDict[@"elvesFigureUrl"];
        NSString *url = [QMConnect sdkGetQiniuURL];
        url = [url stringByAppendingPathComponent:elvesFigureUrl];

        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        double emjoiSize = [dataDict[@"emojiSize"] doubleValue] * 2;
     
        NSArray *imageArr = [image clipImage:CGSizeMake(emjoiSize, emjoiSize)];
        NSArray *bookArray = dataDict[@"bookArray"];
        
        NSMutableArray *items = [NSMutableArray array];
        NSMutableDictionary *emjDict = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < bookArray.count; i++) {
            QMChatEmoji *item = [QMChatEmoji new];
            if (i > imageArr.count) {
                break;
            }
            item.image = imageArr[i];
            NSDictionary *dic = bookArray[i];
            item.name = dic[@"str"];
            [items addObject:item];
            if (item.image) {
                [emjDict setObject:item.image forKey:item.name];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:emjDict.copy];
            [defaults setObject:data forKey:@"emojisDict"];
            [defaults synchronize];
            
            self.emojiList = items.copy;
            self.emojisDict = emjDict.copy;
            if (completion) {
                completion();
            }
        });
    });
    
//    NSLog(@"dd = %@",dataDict);
}


@end
