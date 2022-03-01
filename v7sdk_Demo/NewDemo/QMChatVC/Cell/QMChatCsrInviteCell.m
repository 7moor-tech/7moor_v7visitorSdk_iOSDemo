//
//  QMChatCsrInviteCell.m
//  NewDemo
//
//  Created by lishuijiao on 2021/6/4.
//

#import "QMChatCsrInviteCell.h"

@interface QMChatCsrInviteCell ()

@property (nonatomic, strong) UIView *inviteView;

@property (nonatomic, strong) UILabel *remindLab;

@property (nonatomic, strong) UIButton *remindBtn;

@property (nonatomic, strong) UILabel *thankLabel;

@end

@implementation QMChatCsrInviteCell

- (void)setCellData:(QMChatMessage *)model {
    self.remindLab.text = @"满意度评价";
    
    NSString *invite = model.invite;
    
    if ([invite isEqualToString:@"1"]) {
        [self.remindBtn setTitle:@"评价" forState:UIControlStateNormal];
        [self.remindBtn setTitleColor:[QMThemeManager shared].mainColorModel.color forState:UIControlStateNormal];
        self.remindBtn.hidden = NO;
        self.inviteView.backgroundColor = [UIColor colorWithHexString:@"#D2D2D2"];
        self.thankLabel.text = @"";
        self.thankLabel.hidden = YES;
    }else if ([invite isEqualToString:@"2"]) {
        self.remindBtn.hidden = YES;
        self.remindLab.text = @"满意度评价 已评价";
        self.remindLab.textColor = [UIColor colorWithHexString:@"#999999"];
        self.inviteView.backgroundColor = [UIColor clearColor];
        self.thankLabel.text = @"";
        self.thankLabel.hidden = YES;
    }else if ([invite isEqualToString:@"3"]) {
        self.thankLabel.hidden = NO;
        self.remindBtn.hidden = YES;
        self.remindLab.text = @"";
        self.thankLabel.text = model.content;
        self.inviteView.backgroundColor = [UIColor clearColor];
    }

}

- (void)setupSubviews {
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.inviteView];
    [self.inviteView addSubview:self.remindLab];
    [self.inviteView addSubview:self.remindBtn];
    [self.contentView addSubview:self.thankLabel];
    
    [self.inviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(QM_kScreenWidth/2 - 70);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo(140);
    }];
    
    [self.remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inviteView).offset(20);
        make.top.equalTo(self.inviteView).offset(6);
        make.bottom.equalTo(self.inviteView).offset(-6);
    }];
    
    [self.remindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.remindLab.mas_right).offset(10);
        make.top.equalTo(self.remindLab);
        make.bottom.equalTo(self.remindLab);
    }];
    
    [self.thankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inviteView).offset(20);
        make.right.equalTo(self.inviteView).offset(-20);
        make.top.equalTo(self.inviteView).offset(6);
        make.bottom.equalTo(self.inviteView).offset(-6);
    }];
    
    [self.remindBtn addTarget:self action:@selector(remindAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)remindAction:(UIButton *)button {
    if (self.inviteAction) {
        self.inviteAction();
    }
}

- (UIView *)inviteView {
    if (!_inviteView) {
        _inviteView = [[UIView alloc] init];
        _inviteView.backgroundColor = [UIColor colorWithHexString:@"#D2D2D2"];
        _inviteView.layer.masksToBounds = YES;
        _inviteView.layer.cornerRadius = 5;
    }
    return _inviteView;
}

- (UILabel *)remindLab {
    if (!_remindLab) {
        _remindLab = [UILabel new];
        _remindLab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
        _remindLab.numberOfLines = 2;
        _remindLab.textAlignment = NSTextAlignmentCenter;
        _remindLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _remindLab;
}

- (UIButton *)remindBtn {
    if (!_remindBtn) {
        _remindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _remindBtn.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
    }
    return _remindBtn;
}

- (UILabel *)thankLabel {
    if (!_thankLabel) {
        _thankLabel = [[UILabel alloc] init];
        _thankLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
        _thankLabel.textAlignment = NSTextAlignmentCenter;
        _thankLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _thankLabel;
}

@end
