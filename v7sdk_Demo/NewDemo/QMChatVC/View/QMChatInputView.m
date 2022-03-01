//
//  QMChatInputView.m
//  newDemo
//
//  Created by lishuijiao on 2021/2/3.
//

#import "QMChatInputView.h"
#import "QMChatInputView+Delegate.h"
#import "UIImage+Color.h"
@interface QMChatInputView ()
@property (nonatomic ,strong)UIButton *voiceButton; // 声音按钮
@property (nonatomic ,strong)UIButton *faceButton; // 表情按钮
@property (nonatomic ,strong)UIButton *addButton; // 扩展按钮

@end

@implementation QMChatInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:/*isQMDarkStyle ? @"#1E1E1E" : */@"#F6F6F6"];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
        
    [self addSubview:self.coverView];
    [self addSubview:self.backView];
    [self.backView addSubview:self.inputView];
    [self.backView addSubview: self.faceButton];
    [self addSubview:self.voiceButton];
    [self addSubview:self.recordBtn];
    [self addSubview: self.addButton];
    [self.backView addSubview:self.hintText];
    
    [self layoutViews];
    
    [self.hintText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(13);
        make.top.equalTo(self.backView).offset(10);
        make.bottom.equalTo(self.backView).offset(-10);
        make.width.equalTo(self.inputView);
    }];
    
    if ([QMThemeManager shared].inputViewHintText.length > 0) {
        self.hintText.hidden = NO;
    }else {
        self.hintText.hidden = YES;
    }

}

- (void)layoutViews {
    QMThemeManager *uiModel = QMThemeManager.shared;
    self.voiceButton.hidden = uiModel.isHiddenVoiceBtn;
    self.faceButton.hidden = uiModel.isHiddenFaceBtn;
    self.addButton.hidden = uiModel.isHiddenAddBtn;
    
    
    [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(kInputViewHeight);
    }];
    
    CGFloat vocieWidth = uiModel.isHiddenVoiceBtn ? 0 : 30;
    CGFloat faceWidth = uiModel.isHiddenFaceBtn ? 0 : 30;
    CGFloat addWidth = uiModel.isHiddenAddBtn ? 0 : 30;

    [self.voiceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self.inputView);
        make.width.height.mas_equalTo(vocieWidth);
    }];
    
    [self.addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(addWidth == 0 ? -12 : -42);
        make.centerY.equalTo(self.inputView);
        make.width.height.mas_equalTo(addWidth);
    }];
    
    CGFloat backWidth = QM_kScreenWidth - 12 - (vocieWidth == 0 ? 0 : 42) - 12 - (addWidth == 0 ? 0 : 42);
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceButton.mas_right).offset(vocieWidth == 0 ? 0 : 12);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(backWidth);
        make.height.mas_equalTo(45);
    }];
    
    [self.recordBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView);
    }];
    
    [self.faceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(7.5);
        make.left.equalTo(self.backView.mas_right).offset(faceWidth == 0 ? 0 : -37.5);
        make.width.height.mas_equalTo(faceWidth);
    }];
    
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(13);
        make.top.bottom.equalTo(self.backView);
        make.right.equalTo(self.addButton.mas_left).offset(faceWidth == 0 ? -13 : -45 - 13);
    }];
    
}

- (void)refreshInputView {
    [self layoutViews];
    
}

- (void)setChatInputDelegate:(id)delegate {
    self.addView.delegate = delegate;
}

- (void)setDarkModeColor {
    self.backgroundColor = [UIColor colorWithHexString:/*isQMDarkStyle ? @"#1E1E1E" : */@"#F6F6F6"];
    self.backView.backgroundColor = [UIColor colorWithHexString:/*isQMDarkStyle ? @"#2A2A2A" : */@"#FEFEFE"];
    self.recordBtn.backgroundColor = [UIColor colorWithHexString:/*isQMDarkStyle ? @"#2A2A2A" : */@"#FEFEFE"];
}

- (void)tapInputView {
    if (self.inputView.isFirstResponder == false) {
        [self.inputView becomeFirstResponder];
    }
    
    if ([self.inputView.inputView isKindOfClass:[QMChatFaceView class]]) {
        [self showEmotionView:NO];
        self.inputView.inputView = nil;
        [self.inputView reloadInputViews];
    } else if ([self.inputView.inputView isKindOfClass:[QMChatMoreView class]]) {
        [self showMoreView:NO];
        [self.inputView reloadInputViews];
    }

}

//切换
- (void)voiceButtonAction:(UIButton *)button {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(inputButtonAction:index:)]) {
//        [self.delegate inputButtonAction:button index:QMInputViewModeVoice];
//    }
    //2021、5、29修改
    button.selected = !button.selected;
    [self showRecordButton:button.isSelected];
}

//取消录音
- (void)recordBtnCancel:(UIButton *)button {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(inputButtonAction:index:)]) {
//        [self.delegate inputButtonAction:button index:QMInputViewModeRecordCancel];
//    }
    //2021、5、29修改
    [QMAudioRecorder.sharedInstance cancelAudioRecord];
    [self changeRecordButtonStatus:NO];
    
}

//开始录音
- (void)recordBtnBegin:(UIButton *)button {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(inputButtonAction:index:)]) {
//        [self.delegate inputButtonAction:button index:QMInputViewModeRecordBegin];
//    }
    //2021、5、29修改
    NSString *fileName = [[NSUUID new] UUIDString];
    // 验证权限
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                
            }];
            break;
        case AVAuthorizationStatusAuthorized:
            self.recordeView.isCount = false;
            [self.recordeView changeViewStatus:QMIndicatorStatusNormal];
            [[UIApplication sharedApplication].keyWindow addSubview:self.recordeView];
            [self changeRecordButtonStatus:YES];
            [[QMAudioRecorder sharedInstance] startAudioRecord:fileName maxDuration:60.0 delegate:self];
            break;
        case AVAuthorizationStatusRestricted:
            NSLog(@"麦克风访问受限!");
            break;
        case AVAuthorizationStatusDenied:
            NSLog(@"设置允许访问麦克风");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒".toLocalized message:@"应用相机权限受限,请在设置中启用".toLocalized preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancle];
            [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
            
            break;
    }
    
    
}

//结束录音
- (void)recordBtnEnd:(UIButton *)button {
    //2021、5、29修改
    [[QMAudioRecorder sharedInstance] stopAudioRecord];

}

- (void)recordBtnExit:(UIButton *)button {
    //2021、5、29修改
    [self.recordeView changeViewStatus:QMIndicatorStatusCancel];

}

- (void)recordBtnEnter:(UIButton *)button {
    //2021、5、29修改
    [self.recordeView changeViewStatus:QMIndicatorStatusNormal];
}

// 更改按钮状态
- (void)changeRecordButtonStatus:(BOOL)down {
    if (down == YES) {
        [self.recordBtn setTitle:NSLocalizedString(@"松开 发送", nil) forState:UIControlStateNormal];
    }else {
        [self.recordBtn setTitle:NSLocalizedString(@"按住  说话", nil) forState:UIControlStateNormal];
    }
}

//表情
- (void)faceButtonAction:(UIButton *)button {
    //2021、5、29修改
    button.selected = !button.selected;
    [self showEmotionView:button.isSelected];
}

//加号
- (void)addButtonAction:(UIButton *)button {
    //2021、5、29修改
    button.selected = !button.selected;
    [self showMoreView:button.isSelected];
}

// 显示录音按钮
- (void)showRecordButton:(BOOL)show {
    self.inputView.hidden = show;
    self.recordBtn.hidden = !show;
    if (show) {
        [self.recordBtn setTitle:NSLocalizedString(@"按住  说话", nil) forState:UIControlStateNormal];
        self.voiceButton.selected = YES;
        [self showEmotionView:NO];
        [self showMoreView:NO];
        self.recordBtn.hidden = NO;
    }else {
        self.inputView.inputView = nil;
        self.voiceButton.selected = NO;
        self.recordBtn.hidden = YES;
        [self showEmotionView:YES];
    }
}

// 显示表情面板
- (void)showEmotionView:(BOOL)show {
    self.recordBtn.hidden = YES;
    self.inputView.hidden = NO;
    if (show) {
        self.faceButton.selected = YES;
        self.voiceButton.selected = NO;
        self.addButton.selected = NO;
        self.inputView.inputView = self.emojiView;
        if (!self.inputView.isFirstResponder) {
            [self.inputView becomeFirstResponder];
        }
        [self.inputView reloadInputViews];
//        [self showRecordButton:NO];
//        [self showMoreView:NO];
    }else {
        self.faceButton.selected = NO;
        self.addButton.selected = NO;
        self.inputView.inputView = nil;
        if (!self.inputView.isFirstResponder) {
            [self.inputView becomeFirstResponder];
        }
        [self.inputView reloadInputViews];
    }
}

// 显示扩展面板
/// <#Description#>
/// @param show <#show description#>
- (void)showMoreView:(BOOL)show {
    self.addButton.selected = show;
    self.recordBtn.hidden = YES;
    self.inputView.hidden = NO;
    if (show) {
        [self.addView refreshMoreBtn];
        self.faceButton.selected = NO;
        self.voiceButton.selected = NO;
        self.inputView.inputView = self.addView;
        if (!self.inputView.isFirstResponder) {
            [self.inputView becomeFirstResponder];
        }
        [self.inputView reloadInputViews];
    }else {
        self.faceButton.selected = NO;
        self.inputView.inputView = nil;
        [self.inputView endEditing:YES];
    }
    
}

- (QMChatMoreView *)addView {
    if (!_addView) {
//        CGFloat addViewHeight = QM_IS_iPHONEX ? 144 : 110;
        CGFloat addViewHeight = QM_IS_iPHONEX ? 250 : 216;
        self.addView = [[QMChatMoreView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, QM_kScreenWidth, addViewHeight)];
        self.addView.delegate = self;
    }
    return _addView;
}

- (QMChatFaceView *)emojiView {
    if (!_emojiView) {
        _emojiView = [[QMChatFaceView alloc] init];
        _emojiView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, QM_kScreenWidth, QM_IS_iPHONEX ? 250 : 216);
        _emojiView.delegate = self;
        _emojiView.delegate = self;
    }
    [_emojiView loadData];
    [_emojiView setButtonEnble:self.inputView.text.length > 0];

    return _emojiView;
}

- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_voiceButton setImage:[UIImage imageNamed:@"QM_ToolBar_Voice"] forState:UIControlStateNormal];
        NSString *voiceString = QMThemeManager.shared.isVoiceBtnImgUrl ? : @"";
        if ([voiceString hasPrefix:@"http"] == false) {
            voiceString = [NSString stringWithFormat:@"%@/%@",[QMConnect sdkGetQiniuURL], voiceString];
        }
        if ([voiceString.stringByRemovingPercentEncoding isEqualToString:voiceString]) {
            voiceString = [voiceString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        }
        [_voiceButton sd_setImageWithURL:[NSURL URLWithString:voiceString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"QM_ToolBar_Voice"]];
        NSString *keyString = QMThemeManager.shared.showKeyboardImgUrl ? : @"";
        if ([keyString hasPrefix:@"http"] == false) {
            keyString = [NSString stringWithFormat:@"%@%@",[QMConnect sdkGetQiniuURL], keyString];
        }
        if ([keyString.stringByRemovingPercentEncoding isEqualToString:keyString]) {
            keyString = [keyString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        }
        [_voiceButton sd_setImageWithURL:[NSURL URLWithString:keyString] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"QM_ToolBar_Keyboard"]];

        
        [_voiceButton addTarget:self action:@selector(voiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _voiceButton.hidden = !QMThemeManager.shared.isVoiceBtnShow;
    }
    return _voiceButton;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.backgroundColor = [UIColor colorWithHexString:/*isQMDarkStyle ? @"#2A2A2A" : */@"#FEFEFE"];
        _recordBtn.hidden = YES;
        _recordBtn.layer.cornerRadius = 45/2;
        _recordBtn.layer.masksToBounds = YES;
        [_recordBtn setTitle:NSLocalizedString(@"按住  说话", nil) forState:UIControlStateNormal];
        [_recordBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//        [_recordBtn setTitleColor:[UIColor colorWithRed:50/255.0f green:167/255.0f blue:255/255.0f alpha:1.0] forState:UIControlStateSelected];
        [_recordBtn addTarget:self action:@selector(recordBtnCancel:) forControlEvents:UIControlEventTouchUpOutside];
        [_recordBtn addTarget:self action:@selector(recordBtnBegin:) forControlEvents:UIControlEventTouchDown];
        [_recordBtn addTarget:self action:@selector(recordBtnEnd:) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn addTarget:self action:@selector(recordBtnExit:) forControlEvents:UIControlEventTouchDragExit];
        [_recordBtn addTarget:self action:@selector(recordBtnEnter:) forControlEvents:UIControlEventTouchDragEnter];
        _recordBtn.hidden = YES;
    }
    return _recordBtn;
}

- (UIButton *)faceButton {
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceButton.frame = CGRectMake(CGRectGetWidth(self.backView.frame) - 30 - 7.5, 7.5, 30, 30);
        _faceButton.tag = 1;
        NSString *faceString = QMThemeManager.shared.isEmojiBtnImgUrl ? : @"";
        if ([faceString hasPrefix:@"http"] == false) {
            faceString = [NSString stringWithFormat:@"%@/%@",[QMConnect sdkGetQiniuURL], faceString];
        }
        if ([faceString.stringByRemovingPercentEncoding isEqualToString:faceString]) {
            faceString = [faceString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        }
        [_faceButton sd_setImageWithURL:[NSURL URLWithString:faceString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"QM_ToolBar_Emotion"]];
        NSString *keyString = QMThemeManager.shared.showKeyboardImgUrl ? : @"";
        
        if ([keyString hasPrefix:@"http"] == false) {
            keyString = [NSString stringWithFormat:@"%@/%@",[QMConnect sdkGetQiniuURL], keyString];
        }
        if ([keyString.stringByRemovingPercentEncoding isEqualToString:keyString]) {
            keyString = [keyString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        }
        [_faceButton sd_setImageWithURL:[NSURL URLWithString:keyString] forState:UIControlStateSelected placeholderImage:[UIImage imageNamed:@"QM_ToolBar_Keyboard"]];
        _faceButton.hidden = !QMThemeManager.shared.isEmojiBtnShow;
        [_faceButton addTarget:self action:@selector(faceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.tag = 3;
//        [_addButton setImage:[UIImage imageNamed:@"QM_ToolBar_Add"] forState:UIControlStateNormal];
        NSString *faceString = QMThemeManager.shared.moreFunctionImgUrl ? : @"";
        if ([faceString.stringByRemovingPercentEncoding isEqualToString:faceString]) {
            faceString = [faceString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        }
        if ([faceString hasPrefix:@"http"] == false) {
            faceString = [NSString stringWithFormat:@"%@/%@",[QMConnect sdkGetQiniuURL], faceString];
        }
        [_addButton sd_setImageWithURL:[NSURL URLWithString:faceString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"QM_ToolBar_Add"]];

        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UILabel *)hintText {
    if (!_hintText) {
        _hintText = [[UILabel alloc] init];
        _hintText.text = [QMThemeManager shared].inputViewHintText;
        _hintText.adjustsFontSizeToFitWidth = YES;
        _hintText.textColor = [UIColor colorWithHexString:QMColor_999999_text];
    }
    return _hintText;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
//        _coverView.frame = CGRectMake(0, 0, QM_kScreenWidth, kInputViewHeight);
        _coverView.backgroundColor = UIColor.clearColor;
        [_coverView setHidden:YES];
    }
    return _coverView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
//        _backView.frame = CGRectMake(54, 15, QM_kScreenWidth - 54 * 2, 45);
        _backView.backgroundColor = [UIColor colorWithHexString:/*isQMDarkStyle ? @"#2A2A2A" : */@"#FEFEFE"];
        _backView.layer.cornerRadius = 45/2;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UITextView *)inputView {
    if (!_inputView) {
        _inputView = [[UITextView alloc] init];
        _inputView.returnKeyType = UIReturnKeySend;
        _inputView.contentInset = UIEdgeInsetsMake(2, 0, 0, 0);
        _inputView.font = [UIFont systemFontOfSize:18];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInputView)];
        tap.delegate = self;
        [_inputView addGestureRecognizer:tap];
    }
    return _inputView;
}


- (QMRecordIndicatorView *)recordeView {
    if (!_recordeView) {
        _recordeView = [[QMRecordIndicatorView alloc] init];
        _recordeView.frame = CGRectMake((QM_kScreenWidth-150)/2, (QM_kScreenHeight-150-50)/2, 150, 150);
    }
    return _recordeView;
}






@end

