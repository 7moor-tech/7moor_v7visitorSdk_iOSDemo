//
//  QMChatXBotDoubleListCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/8.
//

#import "QMChatXBotDoubleListCell.h"
#import "QMChatTextView.h"

@interface QMChatXBotDoubleListCell ()
@property (nonatomic, strong) QMChatTextView *tipLab;
@property (nonatomic, strong) UIView *containerView0;

//添加 可能出现类型-多行可点踩-和点踩cell有重复-暂时使用6.22
@property (nonatomic, strong) UIButton *fingerUpBtn;
@property (nonatomic, strong) UIButton *fingerDown;
@property (nonatomic, strong) QMChatTextView *answerLab;
@property (nonatomic, strong) UIView *answerBgView;

@end

@implementation QMChatXBotDoubleListCell

- (void)setupSubviews {
    [super setupSubviews];

    [self.bubblesBgView addSubview:self.containerView0];
    
    [self.containerView0 addSubview:self.tipLab];
    
    [self.containerView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubblesBgView).priority(999);
        make.left.equalTo(self.bubblesBgView);
        make.right.equalTo(self.bubblesBgView).priority(999);
        make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
    }];


    
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView0).offset(3).priority(999);
        make.left.equalTo(self.containerView0).offset(8);
        make.right.equalTo(self.containerView0).offset(-8);
        make.bottom.equalTo(self.containerView0).offset(-2);
        make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
    }];
        
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView0.mas_bottom).offset(10).priority(999);
        make.left.equalTo(self.bubblesBgView);
        make.right.equalTo(self.bubblesBgView).priority(999);
        make.bottom.equalTo(self.bubblesBgView).priority(999);
        make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
    }];

    
    [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(3).priority(999);
        make.left.equalTo(self.containerView).offset(8);
        make.right.equalTo(self.containerView).offset(-8);
        make.bottom.equalTo(self.containerView).offset(-2);
        make.width.mas_greaterThanOrEqualTo(120);
        make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
    }];
    
    self.contentLab.layer.cornerRadius = 10;
    self.contentLab.clipsToBounds = YES;
    self.contentLab.backgroundColor = [UIColor clearColor];
    self.bubblesBgView.backgroundColor = [UIColor clearColor];
}

- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];
    
    if (model.type == ChatMessageRev) {
        if (QMThemeManager.shared.leftMsgTextColor.hasBeenSetColor) {
            UIColor *color = QMThemeManager.shared.leftMsgTextColor.color;
            self.contentLab.textColor = color;
            self.tipLab.textColor = color;

        }
        if (QMThemeManager.shared.leftMsgBgColor.hasBeenSetColor) {
            UIColor *bgColor = QMThemeManager.shared.leftMsgBgColor.color;
            self.containerView0.backgroundColor = bgColor;
            self.containerView.backgroundColor = bgColor;
            self.answerBgView.backgroundColor = bgColor;
        }
    } else {
        if (QMThemeManager.shared.rightMsgTextColor.hasBeenSetColor) {
            UIColor *color = QMThemeManager.shared.rightMsgTextColor.color;
            self.contentLab.textColor = color;
            self.tipLab.textColor = color;
        }
        if (QMThemeManager.shared.rightMsgBgColor.hasBeenSetColor) {
            UIColor *bgColor = QMThemeManager.shared.rightMsgBgColor.color;
            self.containerView0.backgroundColor = bgColor;
            self.containerView.backgroundColor = bgColor;
            self.answerBgView.backgroundColor = bgColor;
        }
    }
    
    
    self.tipLab.attributedText = model.contentAttr;
    self.contentLab.attributedText = model.contentAttr2;
    self.bubblesBgView.backgroundColor = [UIColor clearColor];
    
    if (model.fingerUp.length > 0 && model.fingerDown.length > 0 && model.cannotSelectMessage == NO) {
        [self setupFingerView:model];
        [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(self.serviceLab);
        }];
    } else {
        [self.answerBgView removeFromSuperview];
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView0.mas_bottom).offset(10).priority(999);
            make.left.equalTo(self.bubblesBgView);
            make.right.equalTo(self.bubblesBgView).priority(999);
            make.bottom.equalTo(self.bubblesBgView).priority(999);
            make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
        }];
        if ([self.contentView.subviews containsObject:self.answerBgView]) {
            [self.answerBgView removeFromSuperview];
        }
        
        if (self.fingerDown.superview) {
            [self.fingerDown removeFromSuperview];
        }
        if (self.fingerUpBtn) {
            [self.fingerUpBtn removeFromSuperview];
        }

    }

}

- (void)setupFingerView:(QMMessageModel *)model {
    self.fingerUpBtn.userInteractionEnabled = YES;
    self.fingerDown.userInteractionEnabled = YES;
    if (![self.answerBgView.subviews containsObject:self.answerLab]) {
        [self.answerBgView addSubview:self.answerLab];

        [self.answerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.answerBgView).offset(2.5).priority(999);
            make.left.equalTo(self.answerBgView).offset(5);
            make.right.equalTo(self.answerBgView).offset(-5);
            make.bottom.equalTo(self.answerBgView).offset(-2.5).priority(999);
        }];
    }

    if (![self.contentView.subviews containsObject:self.answerBgView]) {
        [self.contentView addSubview:self.answerBgView];
        [self.answerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_bottom).offset(8).priority(999);
            make.left.equalTo(self.bubblesBgView);
            make.right.lessThanOrEqualTo(self.contentView).offset(-12);
            make.bottom.equalTo(self.bubblesBgView).priority(999);
        }];
        
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView0.mas_bottom).offset(10).priority(999);
            make.left.equalTo(self.bubblesBgView);
            make.right.equalTo(self.bubblesBgView).priority(999);
//            make.bottom.equalTo(self.bubblesBgView).priority(999);
            make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
        }];

    }
    
    if (![self.contentView.subviews containsObject:self.fingerDown]) {
        [self.contentView addSubview:self.fingerDown];
        [self.fingerDown mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.containerView0).priorityHigh();
            make.left.equalTo(self.bubblesBgView.mas_right).offset(10).priorityHigh();
            make.right.lessThanOrEqualTo(self.contentView);
            make.width.height.mas_equalTo(30).priorityHigh();
        }];
        
    }
    
    if (![self.contentView.subviews containsObject:self.fingerUpBtn]) {
        [self.contentView addSubview:self.fingerUpBtn];

        [self.fingerUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.width.equalTo(self.fingerDown);
            make.bottom.equalTo(self.fingerDown.mas_top).offset(-10).priorityHigh();
            make.top.greaterThanOrEqualTo(self.contentView).priorityHigh();
        }];
    }
    

    self.answerLab.text = @"";
    self.answerLab.hidden = NO;
    self.answerBgView.hidden = NO;
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
        self.answerLab.hidden = YES;
        [self.answerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_bottom).offset(8).priority(999);
            make.left.equalTo(self.bubblesBgView);
            make.right.lessThanOrEqualTo(self.contentView).offset(-12);
            make.bottom.equalTo(self.bubblesBgView).priority(999);
            make.height.mas_equalTo(0);
        }];

    }
    
    if (model.cannotSelectMessage) {
        self.fingerUpBtn.userInteractionEnabled = NO;
        self.fingerDown.userInteractionEnabled = NO;
    }

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
    [self.answerLab sizeToFit];
    
    [self.answerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).offset(8).priority(999);
        make.left.equalTo(self.bubblesBgView);
        make.right.lessThanOrEqualTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.bubblesBgView).priority(999);
    }];
    
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
        
        if (update) {
            self.answerLab.text = text;
            self.answerLab.hidden = NO;
            self.answerBgView.hidden = NO;

            [self.answerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.containerView.mas_bottom).offset(8).priority(999);
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

- (QMChatTextView *)tipLab {
    if (!_tipLab) {
        _tipLab = [QMChatTextView new];
        _tipLab.font = k_Chat_Font;
        _tipLab.textColor = k_QMRGB(21, 21, 21);
        _tipLab.backgroundColor = [UIColor clearColor];
        _tipLab.layer.cornerRadius = 10;
        _tipLab.clipsToBounds = YES;
        _tipLab.delegate = self;
    }
    return _tipLab;
}

- (UIView *)containerView0 {
    if (!_containerView0) {
        _containerView0 = [UIView new];
        _containerView0.layer.cornerRadius = 10;
        _containerView0.clipsToBounds = YES;
        _containerView0.backgroundColor = [UIColor whiteColor];
    }
    return _containerView0;
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

- (UIView *)answerBgView {
    if (!_answerBgView) {
        _answerBgView = [UIView new];
        _answerBgView.layer.cornerRadius = 10;
        _answerBgView.clipsToBounds = YES;
    }
    return _answerBgView;
}

@end
