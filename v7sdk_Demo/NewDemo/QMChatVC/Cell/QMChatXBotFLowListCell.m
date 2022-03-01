//
//  QMChatXBotCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/6.
//

#import "QMChatXBotFLowListCell.h"
#import <CoreFoundation/CoreFoundation.h>
#import "QMAttributedManager.h"
#import "QMChatShowImageViewController.h"
@interface QMChatXBotFLowListCell () 


@end

@implementation QMChatXBotFLowListCell

- (void)setupSubviews {
    [super setupSubviews];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImageAction:) name:@"qm_downImageCompleted" object:nil];
    self.contentLab.delegate = self;
    
    [self.bubblesBgView addSubview:self.containerView];
    [self.bubblesBgView addSubview:self.contentLab];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubblesBgView).priority(999);
        make.left.equalTo(self.bubblesBgView);
        make.right.equalTo(self.bubblesBgView);
        make.bottom.equalTo(self.contentLab).priority(999);
        make.height.mas_greaterThanOrEqualTo(45).priorityHigh();
    }];

    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubblesBgView).offset(2.5).priority(999);
        make.left.equalTo(self.bubblesBgView).offset(8);
        make.right.equalTo(self.bubblesBgView).offset(-8);
        make.bottom.equalTo(self.bubblesBgView).offset(-2.5).priorityHigh();
        make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
    }];

}

//- (void)loadImageAction:(NSNotification *)notif {
//    NSLog(@"收到qm_downImageCompleted通知");
//    if (self.message && self.message.attrAttachmentReplaced != 2) {
//        NSString *messageId = (NSString *)notif.object;
//        if ([messageId isKindOfClass:[NSString class]] && [self.message.messageId isEqualToString:messageId]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [self handleImage:self.message needReload:YES];
//            });
//        }
//    }
//}

- (void)handleImage:(QMChatMessage *)model {
    
    // 处理html替换成原本图片-原图片过大加载过慢
    __block BOOL needReload = NO;
    __block BOOL replacedAll = YES;
    
    [model.contentAttr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, model.contentAttr.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        
        if ([value isKindOfClass:[QMChatFileTextAttachment class]]) {
            QMChatFileTextAttachment *attach = (QMChatFileTextAttachment *)value;
            
            if ([attach.type isEqualToString:@"image"] && attach.need_replaceImage == YES) {
                NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
                path = [path stringByAppendingPathComponent:attach.url.lastPathComponent];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:path] == true) {
                    NSData *data = [[NSData alloc] initWithContentsOfFile:path options:NSDataReadingMappedAlways error:nil];
                    if (data.length > 0) {
                        UIImage *image = [[UIImage alloc] initWithData:data];
                        attach.image = image;
                        attach.need_replaceImage = NO;
                        needReload = YES;
                    }
                } else {
                    replacedAll = NO;
                }
            }
        }
    }];
    
    if (replacedAll) {
        model.attrAttachmentReplaced = 2;
    }
    
    if (needReload) {
        self.contentLab.attributedText = model.contentAttr;
        if (self.needRoloadCell) {
            self.needRoloadCell(model);
        }
    }

}

- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];

    self.contentLab.text = model.content;
    if (model.attrAttachmentReplaced == 1) {
        [self handleImage:model];
    }
    
    if (model.contentAttr && model.contentAttr.length > 0) {
        self.contentLab.attributedText = model.contentAttr;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            QMAttributedManager *magr = [QMAttributedManager shared];
            NSAttributedString *attr = [magr filterText:model.content skipFilterPhoneNum:model.type == ChatMessageSend];
            
            if (model.messageId == self.message.messageId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.contentLab.attributedText = attr;
                    self.message.contentAttr = attr;
                    if (self.upCellConstraint) {
                        self.upCellConstraint(self.message);
                    }
                });
            }
            
        });
    }

    if (model.type == ChatMessageRev) {
        if (QMThemeManager.shared.leftMsgTextColor.hasBeenSetColor) {
            self.contentLab.textColor = QMThemeManager.shared.leftMsgTextColor.color;
        }
        if (QMThemeManager.shared.leftMsgBgColor.hasBeenSetColor) {
            self.containerView.backgroundColor = QMThemeManager.shared.leftMsgBgColor.color;
        }
    } else {
        if (QMThemeManager.shared.rightMsgTextColor.hasBeenSetColor) {
            self.contentLab.textColor = QMThemeManager.shared.rightMsgTextColor.color;
        }
        if (QMThemeManager.shared.rightMsgBgColor.hasBeenSetColor) {
            self.containerView.backgroundColor = QMThemeManager.shared.rightMsgBgColor.color;
        }
    }
    
    self.bubblesBgView.backgroundColor = UIColor.clearColor;
    
}


- (void)select:(id)sender {
    [self.contentLab becomeFirstResponder];
    
    [self.contentLab select:sender];
    
}

- (void)copy:(id)sender {
    UIPasteboard.generalPasteboard.string = self.contentLab.text;
    [self endEditing:YES];
//    [self.contentLab copy:sender];
}

- (QMChatTextView *)contentLab {
    if (!_contentLab) {
        _contentLab = [QMChatTextView new];
//        _contentLab.numberOfLines = 0;
        _contentLab.font = k_Chat_Font;
        _contentLab.textAlignment = NSTextAlignmentLeft;
        _contentLab.textColor = [UIColor blackColor];
        _contentLab.backgroundColor = UIColor.clearColor;
        _contentLab.editable = false;
        _contentLab.scrollEnabled = false;
        _contentLab.layer.cornerRadius = 10;
        _contentLab.clipsToBounds = YES;
        _contentLab.delegate = self;

        
    }
    return _contentLab;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.layer.cornerRadius = 10;
        _containerView.clipsToBounds = YES;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)handelTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRang {
    if ([textAttachment isKindOfClass:[QMChatFileTextAttachment class]]) {
        QMChatFileTextAttachment *attach = (QMChatFileTextAttachment *)textAttachment;
        if ([attach.type isEqualToString:@"image"]) {
            QMChatShowImageViewController * showPicVC = [[QMChatShowImageViewController alloc] init];
            showPicVC.modalPresentationStyle = UIModalPresentationFullScreen;
                NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
                path = [path stringByAppendingPathComponent:attach.url.lastPathComponent];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path] == true) {
                    NSData *data = [[NSData alloc] initWithContentsOfFile:path options:NSDataReadingMappedAlways error:nil];
                    if (data.length > 0) {
                        UIImage *image = [[UIImage alloc] initWithData:data];
                        showPicVC.image = image;
                    }
                }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicVC animated:true completion:nil];
        } else {
            if (self.pushWebView) {
                self.pushWebView([NSURL URLWithString:attach.url]);
            }
            
        }
        return false;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    return [self handelTextAttachment:textAttachment inRange:characterRange];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)) {
    return [self handelTextAttachment:textAttachment inRange:characterRange];
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([URL.absoluteString hasPrefix:@"http"]) {
        NSString *text = URL.absoluteString;
        /// ulr =  http://7moor_param=(value)QM_recogType+http
        if ([text hasPrefix:@"http://7moor_param="]) {
            text = [[text stringByReplacingOccurrencesOfString:@"http://7moor_param=" withString:@""] stringByRemovingPercentEncoding];
            NSArray *items = [text componentsSeparatedByString:@"QM_recogType"];
            if (items.count > 1) {
                NSString *recogType = items.firstObject;
                if ([recogType isEqualToString:@"4"]) {
                    // 自定义事件
                } else {
                    NSString *value = items.lastObject;
                    if (self.sendText) {
                        self.sendText(value);
                    }
                }
            } else {
                
                if (self.sendText) {
                    self.sendText(text);
                }
            }
        } else {
            if (self.pushWebView) {
                self.pushWebView(URL);
            }
        }
    } else {

        NSString *text = URL.absoluteString;
        if ([text hasPrefix:@"tel:"]) {
            if ([text containsString:@"tel://"] == NO) {
                text = [text stringByReplacingOccurrencesOfString:@"tel:" withString:@"tel://"];
            }
            NSURL *url = [NSURL URLWithString:text];
            [UIApplication.sharedApplication openURL:url];
        } else {
            if (self.sendText) {
                self.sendText(text);
            }
        }
    }
    return false;
}

@end
