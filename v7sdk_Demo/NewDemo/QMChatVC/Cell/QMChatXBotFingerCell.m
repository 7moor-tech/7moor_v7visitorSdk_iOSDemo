//
//  QMChatXBotFingerCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/7.
//

#import "QMChatXBotFingerCell.h"
#import <MoorV7SDK/MoorV7SDK.h>

@interface QMChatXBotFingerCell ()
@property (nonatomic, strong) UIButton *fingerUpBtn;
@property (nonatomic, strong) UIButton *fingerDown;
@property (nonatomic, strong) QMChatTextView *answerLab;
@property (nonatomic, strong) UIView *answerBgView;
@end

@implementation QMChatXBotFingerCell

- (void)setupSubviews {
    [super setupSubviews];
    
    self.answerBgView = [UIView new];
    self.answerBgView.layer.cornerRadius = 10;
    self.answerBgView.clipsToBounds = YES;
    [self.contentView addSubview:self.answerBgView];
    
    [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubblesBgView).offset(2.5).priority(999);
        make.left.equalTo(self.bubblesBgView).offset(8);
        make.right.equalTo(self.bubblesBgView).offset(-8);
        make.width.greaterThanOrEqualTo(self.serviceLab);
//        make.bottom.equalTo(self.bubblesBgView).priority(999);
        make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
    }];
    
    
    [self.answerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(8).priority(999);
        make.left.equalTo(self.bubblesBgView);
        make.right.equalTo(self.bubblesBgView);
        make.bottom.equalTo(self.bubblesBgView).priority(999);
    }];
    
    [self.answerBgView addSubview:self.answerLab];
    
    
    [self.answerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.answerBgView).offset(2.5).priority(999);
        make.left.equalTo(self.answerBgView).offset(5);
        make.right.equalTo(self.answerBgView).offset(-5);
        make.bottom.equalTo(self.answerBgView).offset(-2.5).priority(999);
    }];
    
    [self.contentView addSubview:self.fingerUpBtn];
    [self.contentView addSubview:self.fingerDown];
    
    [self.fingerDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentLab).priorityHigh();
        make.left.equalTo(self.bubblesBgView.mas_right).offset(10).priorityHigh();
        make.right.lessThanOrEqualTo(self.contentView);
        make.width.height.mas_equalTo(30).priorityHigh();
    }];
    
    [self.fingerUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.width.equalTo(self.fingerDown);
        make.bottom.equalTo(self.fingerDown.mas_top).offset(-10).priorityHigh();
        make.top.greaterThanOrEqualTo(self.contentView).priorityHigh();
    }];
    
    self.contentLab.layer.cornerRadius = 10;
    self.contentLab.clipsToBounds = YES;
//    self.contentLab.contentInset = UIEdgeInsetsMake(8, 10, 8, 10);

}

- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];
    
    if (model.type == ChatMessageRev) {
        if (QMThemeManager.shared.leftMsgTextColor.hasBeenSetColor) {
            self.contentLab.textColor = QMThemeManager.shared.leftMsgTextColor.color;
        }
        if (QMThemeManager.shared.leftMsgBgColor.hasBeenSetColor) {
            self.containerView.backgroundColor = QMThemeManager.shared.leftMsgBgColor.color;
            self.answerBgView.backgroundColor = QMThemeManager.shared.leftMsgBgColor.color;

        }
    } else {
        if (QMThemeManager.shared.rightMsgTextColor.hasBeenSetColor) {
            self.contentLab.textColor = QMThemeManager.shared.rightMsgTextColor.color;
        }
        if (QMThemeManager.shared.rightMsgBgColor.hasBeenSetColor) {
            self.containerView.backgroundColor = QMThemeManager.shared.rightMsgBgColor.color;
            self.answerBgView.backgroundColor = QMThemeManager.shared.rightMsgBgColor.color;
        }
    }
    
    if (model.cannotSelectMessage) {
//        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.bubblesBgView).offset(2.5).priority(999);
//            make.left.equalTo(self.bubblesBgView).offset(8);
//            make.right.equalTo(self.bubblesBgView).offset(-8);
//            make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
//        }];
        self.fingerUpBtn.userInteractionEnabled = NO;
        self.fingerDown.userInteractionEnabled = NO;
        self.fingerDown.hidden = YES;
        self.fingerUpBtn.hidden = YES;
        [self.answerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLab.mas_bottom).priority(999);
            make.left.equalTo(self.bubblesBgView);
            make.right.lessThanOrEqualTo(self.contentView).offset(-12);
            make.bottom.equalTo(self.bubblesBgView).priority(999);
            make.height.mas_equalTo(0);
        }];
    } else {
//        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.bubblesBgView).offset(2.5).priority(999);
//            make.left.equalTo(self.bubblesBgView).offset(8);
//            make.right.equalTo(self.bubblesBgView).offset(-8);
//            make.width.greaterThanOrEqualTo(self.serviceLab);
//            make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
//        }];
        self.fingerDown.hidden = NO;
        self.fingerUpBtn.hidden = NO;
        self.fingerUpBtn.userInteractionEnabled = YES;
        self.fingerDown.userInteractionEnabled = YES;
        
        self.answerLab.text = @"";
        self.answerLab.hidden = NO;
        [self.answerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLab.mas_bottom).offset(8).priority(999);
            make.left.equalTo(self.bubblesBgView);
            make.right.lessThanOrEqualTo(self.contentView).offset(-12);
            make.bottom.equalTo(self.bubblesBgView).priority(999);
        }];
        
        if (model.fingerSelected == 1) {
            self.fingerUpBtn.selected = YES;
            self.fingerDown.selected = NO;
            self.answerLab.text = self.message.fingerUp;
            [self.answerLab sizeToFit];
            self.fingerUpBtn.userInteractionEnabled = NO;
            self.fingerDown.userInteractionEnabled = NO;
            
        } else if (model.fingerSelected == 2) {
            self.fingerDown.selected = YES;
            self.fingerUpBtn.selected = NO;
            self.fingerUpBtn.userInteractionEnabled = NO;
            self.fingerDown.userInteractionEnabled = NO;
            self.answerLab.text = self.message.fingerDown;
            [self.answerLab sizeToFit];
        } else {
            self.fingerDown.selected = NO;
            self.fingerUpBtn.selected = NO;
            self.fingerUpBtn.userInteractionEnabled = YES;
            self.fingerDown.userInteractionEnabled = YES;
            self.answerLab.hidden = YES;
            [self.answerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentLab.mas_bottom).priority(999);
                make.left.equalTo(self.bubblesBgView);
                make.right.lessThanOrEqualTo(self.contentView).offset(-12);
                make.bottom.equalTo(self.bubblesBgView).priority(999);
                make.height.mas_equalTo(0);
            }];
            
        }
        
    }
    
    self.bubblesBgView.backgroundColor = [UIColor clearColor];
           
}

- (void)fingerDownAction:(UIButton *)sender {
    self.fingerDown.userInteractionEnabled = NO;
    self.fingerUpBtn.userInteractionEnabled = NO;

    sender.selected = YES;
    NSString *answer = @"";
    BOOL isUseful = NO;
    if (sender == self.fingerDown) {
        answer = self.message.fingerDown;
        self.message.fingerSelected = 2;
    } else {
        self.message.fingerSelected = 1;
        answer = self.message.fingerUp;
        isUseful = YES;
    }
    
    self.answerLab.text = answer;
    self.answerLab.hidden = NO;
    self.answerBgView.hidden = NO;
    [self.answerLab sizeToFit];
    
    
    if (self.updateFingerSelected) {
        self.updateFingerSelected(self.message);
    }
    
    [QMConnect sdkUpdateMessageFingerSelected:self.message];
    
    double conf = self.message.confidence.doubleValue;
    
    NSDictionary *dict = @{
        @"robotId"      : self.message.robotId ?: @"",
        @"robotType"    : self.message.robotType ?: @"",
        @"sessionId"    : self.message.sessionId ?: @"",
        @"oriQuestion"  : self.message.oriQuestion ?: @"",
        @"stdQuestion"  : self.message.stdQuestion ?: @"",
        @"answer"       : answer,
        @"confidence"   : @(conf),
        @"messageId"    : self.message.messageId ?: @"",
        @"isUseful"     : @(isUseful)
    };
    
    [QMConnect sdkRobotfeedbackParam:dict completion:^(id  _Nonnull dict) {
        NSLog(@"dict =%@", dict);
//        [self fingerDownUpdateCell:YES text:answer];
    } failure:^(NSError * error) {
        NSLog(@"error =%@", error.localizedDescription);
        [self fingerDownUpdateCell:NO text:answer];

    }];
    
}

- (void)fingerDownUpdateCell:(BOOL)update text:(NSString *)text {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (update && text.length > 0) {
            self.answerLab.text = text;
            self.answerLab.hidden = NO;
            self.answerBgView.hidden = NO;
            [self.answerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentLab.mas_bottom).offset(8).priority(999);
                make.left.equalTo(self.bubblesBgView);
                make.right.lessThanOrEqualTo(self.contentView).offset(-12);
                make.bottom.equalTo(self.bubblesBgView).priority(999);
            }];
            
            if (self.updateFingerSelected) {
                self.updateFingerSelected(self.message);
            }
            
            [QMConnect sdkUpdateMessageFingerSelected:self.message];
        } else {
            self.answerLab.hidden = YES;
            self.answerBgView.hidden = YES;
            self.fingerDown.userInteractionEnabled = YES;
            self.fingerUpBtn.userInteractionEnabled = YES;
            self.fingerUpBtn.selected = NO;
            self.fingerDown.selected = NO;
        }
    });

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIButton *)fingerDown {
    if (!_fingerDown) {
        _fingerDown = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fingerDown setImage:[UIImage imageNamed:@"chatFingerDown"] forState:UIControlStateNormal];
        [_fingerDown setImage:[UIImage imageNamed:@"chatFingerDown_sel"] forState:UIControlStateSelected];
        _fingerDown.layer.cornerRadius = 15;
        _fingerDown.clipsToBounds = YES;
        [_fingerDown addTarget:self action:@selector(fingerDownAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fingerDown;
}

- (UIButton *)fingerUpBtn {
    if (!_fingerUpBtn) {
        _fingerUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fingerUpBtn setImage:[UIImage imageNamed:@"chatFingerUp"] forState:UIControlStateNormal];
        [_fingerUpBtn setImage:[UIImage imageNamed:@"chatFingerUp_sel"] forState:UIControlStateSelected];
        _fingerUpBtn.layer.cornerRadius = 15;
        _fingerUpBtn.clipsToBounds = YES;
        [_fingerUpBtn addTarget:self action:@selector(fingerDownAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fingerUpBtn;
}

- (QMChatTextView *)answerLab {
    if (!_answerLab) {
        _answerLab = [QMChatTextView new];
        _answerLab.font = k_Chat_Font;
        _answerLab.layer.cornerRadius = 10;
        _answerLab.clipsToBounds = YES;
        _answerLab.backgroundColor = UIColor.clearColor;
        _answerLab.delegate = self;
//        _answerLab.contentInset = UIEdgeInsetsMake(8, 10, 8, 10);
        
    }
    return _answerLab;
}

@end
