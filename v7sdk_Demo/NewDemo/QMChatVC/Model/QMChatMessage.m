//
//  QMChatMessage.m
//  newDemo
//
//  Created by ZCZ on 2021/2/24.
//

#import "QMChatMessage.h"
#import "QMAttributedManager.h"
#import "QMChatEmojiManger.h"

@implementation QMChatMessage




- (ChatMessageMode)type {
    return [self.fromType isEqualToString:@"in"] ? ChatMessageSend : ChatMessageRev;
}

- (QMMessageType)eMessageType {
    QMMessageType mode = MessageTypeText;
    
    if ([self.messageType isEqualToString:@"image"]) {
        mode = MessageTypeImage;
    } else if ([self.messageType isEqualToString:@"video"]) {
        mode = MessageTypeVideo;
    } else if ([self.messageType isEqualToString:@"file"]) {
        mode = MessageTypeFile;
    } else if ([self.messageType isEqualToString:@"audio"] || [self.messageType isEqualToString:@"voice"]) {
        mode = MessageTypeAudio;
    } else if ([self.messageType isEqualToString:@"card"]) {
        mode = MessageTypeCard;
    } else if ([self.messageType isEqualToString:@"remind"]) {
        mode = MessageTypeRemind;
    } else if ([self.messageType isEqualToString:@"question"]) {
        mode = QMMessageTypeQuestion;
    } else if ([self.messageType isEqualToString:@"select"]) {
        mode = QMMessageTypeSelect;
    } else if ([self.messageType isEqualToString:@"csrInvite"]) {
        mode = QMMessageTypeCsrInvite;
    } else if ([self.messageType isEqualToString:@"orderCardInfo"]) {
        mode = QMMessageTypeOrderCard;
    } else if ([self.messageType isEqualToString:@"msgTask"]) {
        mode = QMMessageTypeMsgTask;
    } else if ([self.messageType isEqualToString:@"moorFastBtn"]) {
        mode = QMMessageTypeListCard;
    } else if ([self.messageType isEqualToString:@"quickMenu"]) {
        mode = QMMessageTypeQuickMenu;
    }
    
    return mode;
}

+ (QMChatMessage *)initFromMessage:(QMMessageModel *)message {
    NSString *dict = [message yy_modelToJSONString];
    QMChatMessage *msg = [QMChatMessage yy_modelWithJSON:dict];
    UIColor *textColor = [UIColor blackColor];
    if (msg.type == ChatMessageRev) {
        if (QMThemeManager.shared.leftMsgTextColor.hasBeenSetColor) {
            UIColor *color = QMThemeManager.shared.leftMsgTextColor.color;
            textColor = color;
        }
    } else {
        if (QMThemeManager.shared.rightMsgTextColor.hasBeenSetColor) {
            UIColor *color = QMThemeManager.shared.rightMsgTextColor.color;
            textColor = color;
        }
    }
    if (msg.isShowHtml) {
        
        NSMutableAttributedString *attr = message.contentAttr.mutableCopy;
        NSMutableAttributedString *att2 = message.contentAttr2.mutableCopy;
//        [attr addAttributes:@{NSForegroundColorAttributeName: textColor} range:NSMakeRange(0, attr.length)];
//        [att2 addAttributes:@{NSForegroundColorAttributeName: textColor} range:NSMakeRange(0, att2.length)];
        
        msg.contentAttr = attr;
        msg.contentAttr2 = att2;
    } else {
        if (QMChatEmojiManger.shared.emojisDict.count > 0) {
            QMAttributedManager *magr = [QMAttributedManager shared];
            
            NSMutableAttributedString *attr = [magr filterText:msg.content skipFilterPhoneNum:msg.type == ChatMessageSend].mutableCopy;
//            [attr addAttributes:@{NSForegroundColorAttributeName: textColor} range:NSMakeRange(0, attr.length)];
            msg.contentAttr = attr;
        }

    }
    
    if (message.msgTask.length > 0) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[message.msgTask dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSString *resp_type = dict[@"resp_type"];
        if ([resp_type isKindOfClass:NSString.class] && [resp_type isEqualToString:@"1"]) {
            NSDictionary *listDict = dict[@"data"];
            if (listDict.count > 0) {
//                msg.msgTaskModel = [[QMLogistcsInfoModel alloc] initWithDictionary:listDict error:nil];
                msg.msgTaskModel = [QMLogistcsInfoModel yy_modelWithDictionary:listDict];
            }
            msg.msgTaskModel.resp_type = @"1";
        } else {
            // 另一个类型
        }
        
    }
    return msg;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"type"]) {
        return YES;
    }
    return NO;
}


- (NSString *)messageId {
    return self._id;
}


@end
