//
//  QMSatisfactionView.m
//  NewDemo
//
//  Created by lishuijiao on 2021/7/19.
//

#import "QMSatisfactionView.h"

@interface QMSatisfactionView() <UITextViewDelegate, UIGestureRecognizerDelegate>

//@property (nonatomic, strong) UILabel *headerLabel;

//@property (nonatomic, strong) UIScrollView *coverView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *nameView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *reasonView;

//@property (nonatomic, strong) UITextView *remarkTView;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIButton *submitButton;

//@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSArray *radioArray;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) NSMutableArray *reasonArray;

@end

@implementation QMSatisfactionView {
    NSString *_thank;
    
    NSString *_type;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.tag = 10000;
        [self addSubview:self.headerLabel];

        [self addSubview:self.coverView];
        [self.coverView addSubview:self.titleLabel];
        [self.coverView addSubview:self.nameView];
        [self.coverView addSubview:self.lineView];
        [self.coverView addSubview:self.reasonView];
        [self.coverView addSubview:self.remarkTView];
        [self.coverView addSubview:self.countLabel];
        [self.coverView addSubview:self.submitButton];
        [self.coverView addSubview:self.cancelButton];

        [self.submitButton addTarget:self action:@selector(submitAciton:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton addTarget:self action:@selector(cancelAciton:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *coverGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        coverGesture.delegate = self;
        [self.coverView addGestureRecognizer:coverGesture];

        UITapGestureRecognizer *backGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
        backGesture.delegate = self;
        [self addGestureRecognizer:backGesture];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.coverView).offset(15);
            make.left.equalTo(self).offset(25);
            make.right.equalTo(self).offset(-25);
        }];
        
        [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(17);
            make.left.right.equalTo(self);
        }];

        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameView.mas_bottom).offset(10);
            make.left.equalTo(self).offset(25);
            make.right.equalTo(self).offset(-25);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.reasonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(10);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(57);
        }];
        
        [self.remarkTView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reasonView.mas_bottom).offset(15);
            make.left.equalTo(self).offset(25);
            make.right.equalTo(self).offset(-25);
            make.height.mas_equalTo(80);
        }];
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.remarkTView).offset(-15);
            make.right.equalTo(self.remarkTView).offset(-15);
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(13);
        }];
        
    }
    return self;
}

- (void)setSatisfactionModel:(QMSatisfactionModel *)SatisfactionModel {
    self.titleLabel.text = SatisfactionModel.title;
    _thank = SatisfactionModel.thank;
    _type = SatisfactionModel.radioTagText;
    self.radioArray = SatisfactionModel.radios;
    [self createRadio:SatisfactionModel.radios];
    
    self.coverView.frame = CGRectMake(0, 200, self.frame.size.width, QM_kScreenHeight - 200);
    self.headerLabel.frame = CGRectMake(0, CGRectGetMinY(self.coverView.frame) - 40, self.frame.size.width, 40);
}

- (void)createRadio:(NSArray *)radios {
    
    for (id item in self.nameView.subviews) {
        [item removeFromSuperview];
    }
    for (id item in self.reasonView.subviews) {
        [item removeFromSuperview];
    }
    
    self.remarkTView.text = @"";
    self.countLabel.text = @"0/50";
    [self.reasonView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    
    for (int i = 0; i < radios.count; i++) {
        QMSatisfactionRadio *radioModel = radios[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 200 + i;
        [button setTitle:radioModel.name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:QMColor_151515_text] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:14];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(nameAction:) forControlEvents:UIControlEventTouchUpInside];

        button.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);

        [self.nameView addSubview:button];

        UIView *bgView = [[UIView alloc] init];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 9;
        bgView.layer.borderWidth = 0.8;
        bgView.layer.borderColor = [UIColor colorWithHexString:QMColor_333333_text].CGColor;
        bgView.tag = 300 + i;
        bgView.userInteractionEnabled = YES;
//        [self.nameView addSubview:bgView];
        [button addSubview:bgView];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"qm_satis_nor"];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 600 + i;
        [bgView addSubview:imageView];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameView).offset(10 + 33*i);
//            make.left.equalTo(bgView.mas_right).offset(10);
            make.left.equalTo(self.nameView).offset(25);
            make.right.equalTo(self.nameView).offset(-25);
            make.height.mas_equalTo(18);
            if (i == radios.count - 1) {
                make.bottom.equalTo(self.nameView);
            }
            if ([radioModel.defaultName isEqualToString:radioModel.key]) {
                button.selected = YES;
                self.selectedButton = button;
                [self createReason:radioModel];
                bgView.backgroundColor = [QMThemeManager shared].mainColorModel.color;
                bgView.layer.borderColor = [QMThemeManager shared].mainColorModel.color.CGColor;
            }
        }];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(button);
            make.width.height.mas_equalTo(18);
        }];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(bgView);
        }];

    }
}

- (void)nameAction:(UIButton *)button {
    [self.remarkTView resignFirstResponder];

    if (button != self.selectedButton) {
        
        NSInteger tag = button.tag - 200;
        if (tag >= self.radioArray.count) {
            return;
        }
        [self.reasonArray removeAllObjects];
        
        UIView *afView = [self.nameView viewWithTag:self.selectedButton.tag + 100];
        afView.backgroundColor = [UIColor clearColor];
        afView.layer.borderColor = [UIColor colorWithHexString:QMColor_333333_text].CGColor;

        UIView *bgView = [self.nameView viewWithTag:tag + 300];
        bgView.backgroundColor = [QMThemeManager shared].mainColorModel.color;
        bgView.layer.borderColor = [QMThemeManager shared].mainColorModel.color.CGColor;
        
        self.selectedButton.selected = !self.selectedButton.selected;
        button.selected = !button.selected;
        self.selectedButton = button;

        QMSatisfactionRadio *radioModel = self.radioArray[tag];
        [self createReason:radioModel];
    }
}

- (void)createReason:(QMSatisfactionRadio *)radio {

    NSMutableArray *reason = radio.reason.mutableCopy;
    
    for (UIView *subView in self.reasonView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat buttonHeight = 35;
    CGFloat originX = 25;
    CGFloat originY = 10;
    CGFloat maxWidth = QM_kScreenWidth - 50 - 32;
    CGFloat height = 0;

    for (int i = 0; i < reason.count; i++) {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:reason[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#151515"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
        [button setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
        button.titleLabel.lineBreakMode = 0;
        button.tag = 400 + i;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = buttonHeight/2;
        [self.reasonView addSubview:button];
        
        [button addTarget:self action:@selector(reasonAction:) forControlEvents:UIControlEventTouchUpInside];
                
        CGSize size = [self calculateText:reason[i] fontName:QM_PingFangSC_Med fontSize:13 maxWidth:maxWidth maxHeight:13];

        CGFloat buttonWidth = size.width + 32;
        if ((originX + buttonWidth) > (QM_kScreenWidth - 25)) {
            originX = 25;
            originY += buttonHeight + 12;
            button.frame = CGRectMake(originX, originY, buttonWidth, buttonHeight);
        }else {
            button.frame = CGRectMake(originX, originY, buttonWidth, buttonHeight);
        }
        originX += buttonWidth + 12;
        
        height = CGRectGetMaxY(button.frame);
    }
    
    [self.reasonView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height + 10);
    }];
    
    if ([radio.proposalStatus isEqualToString:@"notShow"]) {
        [self.remarkTView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reasonView.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }];
        
        [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else {
        [self.remarkTView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reasonView.mas_bottom).offset(15);
            make.height.mas_equalTo(80);
        }];
        
        [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.remarkTView).offset(-15);
            make.height.mas_equalTo(13);
        }];
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat btnWidth = (QM_kScreenWidth - 140 - 15)/2;
        
        self.submitButton.frame = CGRectMake(70, CGRectGetMaxY(self.remarkTView.frame) + 20, btnWidth, 40);
        self.cancelButton.frame = CGRectMake(70 + btnWidth + 15, CGRectGetMaxY(self.remarkTView.frame) + 20, btnWidth, 40);

        CGFloat maxY = CGRectGetMaxY(self.cancelButton.frame) + (QM_IS_iPHONEX?40:20);
        self.coverView.contentSize = CGSizeMake(self.frame.size.width, maxY);
        self.headerLabel.frame = CGRectMake(0, CGRectGetMinY(self.coverView.frame) - 40, self.frame.size.width, 40);
    });
}

- (void)reasonAction:(UIButton *)button {
    [self.remarkTView resignFirstResponder];
    button.selected = !button.selected;

    if (button.selected) {
        [button setTitleColor:[QMThemeManager shared].mainColorModel.color forState:UIControlStateNormal];
        [button setBackgroundColor:[[QMThemeManager shared].mainColorModel color:0.1]];
        if (![self.reasonArray containsObject:button.titleLabel.text]) {
            [self.reasonArray addObject:button.titleLabel.text];
        }
    }else {
        [button setTitleColor:[UIColor colorWithHexString:QMColor_151515_text] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithHexString:@"#F8F8F8"]];
        if ([self.reasonArray containsObject:button.titleLabel.text]) {
            [self.reasonArray removeObject:button.titleLabel.text];
        }
    }
}

- (void)submitAciton:(UIButton *)button {
    [self.remarkTView resignFirstResponder];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *name = self.selectedButton.titleLabel.text;
    NSString *proposal = self.remarkTView.text ? : @"";
    if (name.length) {
        [dic setValue:name forKey:@"satisfactionName"];
    }else {
        [QMRemind showMessage:@"请选择满意度"];
        return;
    }
    
    NSInteger tag = self.selectedButton.tag - 200;
    QMSatisfactionRadio *radioModel = self.radioArray[tag];
        
    
    proposal = [proposal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([radioModel.proposalStatus isEqualToString:@"required"] && proposal.length == 0 ) {
        [QMRemind showMessage:@"备注为必填"];
        return;
    }

    [dic setValue:proposal forKey:@"satisfactionProposal"];
    
    NSString *account = [QMThemeManager shared].account ?: @"";
    
    [dic setValue:_type forKey:@"satisfactionType"];
    [dic setValue:radioModel.key forKey:@"satisfactionKey"];
    [dic setValue:self.reasonArray forKey:@"satisfactionReason"];
    NSMutableDictionary *satisfactionData = [NSMutableDictionary dictionary];
    [satisfactionData setValue:dic forKey:@"satisfactionData"];
    [satisfactionData setValue:self.messageId forKey:@"messageId"];
    [satisfactionData setValue:account forKey:@"account"];

    if (self.sessionId.length) {
        [satisfactionData setValue:self.sessionId forKey:@"sessionId"];
    }
    [QMConnect sdkSendCSRMsg:satisfactionData completion:^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.messageId.length) {
                [QMConnect sdkUpdateInviteStatus:@"2" withMessage:self.messageId];
            }
            self.sendTanksText(self->_thank);
            self.hidden = YES;
        });
    } failure:^(NSDictionary * _Nonnull reason) {
        
    }];
}

- (void)cancelAciton:(UIButton *)button {
    [self.remarkTView resignFirstResponder];
    self.hidden = YES;
}

- (void)tapAction {
    [self.remarkTView resignFirstResponder];
}

- (void)backAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.remarkTView resignFirstResponder];
        self.hidden = YES;
    });
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (1000 <= touch.view.tag && touch.view.tag <= 10000) {
        return YES;
    }else {
        if ([touch.view isKindOfClass:[UIImageView class]]) {
            
            UIButton *button = (UIButton *)[self.nameView viewWithTag:touch.view.tag - 400];
            
            [self nameAction:button];
            
            return NO;
        }
        return NO;
    }
}

- (UIScrollView *)coverView {
    if (!_coverView) {
        _coverView = [[UIScrollView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _coverView.tag = 10000;
    }
    return _coverView;
}

- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _headerLabel.text = @"满意度评价";
        _headerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headerLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIView *)nameView {
    if (!_nameView) {
        _nameView = [[UIView alloc] init];
        _nameView.tag = 2000;
    }
    return _nameView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    }
    return _lineView;
}

- (UIView *)reasonView {
    if (!_reasonView) {
        _reasonView = [[UIView alloc] init];
        _reasonView.tag = 3000;
    }
    return _reasonView;
}

- (UITextView *)remarkTView {
    if (!_remarkTView) {
        _remarkTView = [[UITextView alloc] init];
        _remarkTView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _remarkTView.layer.masksToBounds = true;
        _remarkTView.layer.cornerRadius = 5;
        _remarkTView.delegate = self;
    }
    return _remarkTView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _countLabel.backgroundColor = UIColor.clearColor;
        _countLabel.text = @"0/50";
        _countLabel.tag = 212;
    }
    return _countLabel;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:15];
        _submitButton.backgroundColor = [[QMThemeManager shared].mainColorModel color:0.1];
        [_submitButton setTitle:@"提交评价" forState:UIControlStateNormal];
        _submitButton.QM_eventTimeInterval = 1;
        [_submitButton setTitleColor:[QMThemeManager shared].mainColorModel.color forState:UIControlStateNormal];
    }
    return _submitButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:15];
        _cancelButton.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (NSArray *)radioArray {
    if (!_radioArray) {
        _radioArray = [[NSArray alloc] init];
    }
    return _radioArray;
}

- (NSMutableArray *)reasonArray {
    if (!_reasonArray) {
        _reasonArray = [[NSMutableArray alloc] init];
    }
    return _reasonArray;
}

- (CGSize)calculateText:(NSString *)text fontName:(NSString *)fontName fontSize:(NSInteger)fontSize maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:fontName size:fontSize]};
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect labelRect = [text boundingRectWithSize:maxSize options: options attributes:attribute context:nil];
    return labelRect.size;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.text.length >= 50 && text.length > 0) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *str = textView.text;
    if (str.length > 50) {
        str = [str substringToIndex:50];
        textView.text = str;
    }
    UILabel *countLab = (UILabel *)[self.coverView viewWithTag:212];
    if (countLab) {
        countLab.text = [NSString stringWithFormat:@"%ld字",(long)(50 - str.length)];
    }
}


@end
