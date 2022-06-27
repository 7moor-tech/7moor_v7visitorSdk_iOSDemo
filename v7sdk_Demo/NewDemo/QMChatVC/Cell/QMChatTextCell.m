//
//  QMChatTextCell.m
//  newDemo
//
//  Created by lishuijiao on 2021/2/4.
//

#import "QMChatTextCell.h"
#import <CoreFoundation/CoreFoundation.h>
#import "QMChatTextView.h"

#import "QMAttributedManager.h"

@interface QMChatTextCell () <UITextViewDelegate>

@property (nonatomic, strong) QMChatTextView *contentLab;

@end

@implementation QMChatTextCell

- (void)setupSubviews {
    [super setupSubviews];
    self.contentLab.delegate = self;
    
    [self.bubblesBgView addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubblesBgView).offset(3).priority(999);
        make.left.equalTo(self.bubblesBgView).offset(10);
        make.right.equalTo(self.bubblesBgView).offset(-10);
        make.bottom.equalTo(self.bubblesBgView).priority(999);
        make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
    }];


}

- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];

//    NSString *fromType = dic[@"fromType"];
    self.contentLab.text = model.content;

    
    UIColor *textColor = [UIColor blackColor];
    if (model.type == ChatMessageRev) {
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
    
    self.contentLab.textColor = textColor;
    
    if (model.contentAttr && model.contentAttr.length > 0) {
        self.contentLab.attributedText = model.contentAttr;
    }
    else {
        QMAttributedManager *magr = [QMAttributedManager shared];
        NSMutableAttributedString *attr = [magr filterString:model.content font:self.contentLab.font skipFilterPhoneNum:model.type == ChatMessageSend].mutableCopy;
        
        [attr addAttributes:@{NSForegroundColorAttributeName: textColor} range:NSMakeRange(0, attr.length)];
        
        if (model.messageId == self.message.messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.contentLab.attributedText = attr;
                self.message.contentAttr = attr;
                if (self.upCellConstraint) {
                    self.upCellConstraint(self.message);
                }
            });
        }
        
    }
    
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
        _contentLab = [[QMChatTextView alloc] init];
//        _contentLab.numberOfLines = 0;
        _contentLab.font = k_Chat_Font;
        _contentLab.textAlignment = NSTextAlignmentLeft;
        _contentLab.textColor = [UIColor blackColor];
        _contentLab.backgroundColor = UIColor.clearColor;
        _contentLab.editable = false;
        _contentLab.scrollEnabled = false;
        _contentLab.delegate = self;
//        _contentLab.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    }
    return _contentLab;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)) {
    return false;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([URL.absoluteString hasPrefix:@"http"]) {
        NSString *text = URL.absoluteString;
        if ([text hasPrefix:@"http://7moor_param="]) {
            text = [[text stringByReplacingOccurrencesOfString:@"http://7moor_param=" withString:@""] stringByRemovingPercentEncoding];
            if (self.sendText) {
                self.sendText(text);
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

