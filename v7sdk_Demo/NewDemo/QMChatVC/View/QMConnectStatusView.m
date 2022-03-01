//
//  QMConnectStatusView.m
//  NewDemo
//
//  Created by lishuijiao on 2021/6/16.
//

#import "QMConnectStatusView.h"

@interface QMConnectStatusView ()

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *reConnectButton;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation QMConnectStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.coverView];
    [self.coverView addSubview:self.headerLabel];
    [self.coverView addSubview:self.titleLabel];
    [self.coverView addSubview:self.reConnectButton];
    [self.coverView addSubview:self.cancelButton];
    
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(QM_IS_iPHONEX?230:190);
        make.bottom.equalTo(self);
    }];

    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.coverView);
        make.height.mas_equalTo(40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerLabel.mas_bottom).offset(24.5);
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
        make.height.mas_equalTo(20);
    }];

    CGFloat btnWidth = (QM_kScreenWidth - 140 - 15)/2;

    [self.reConnectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(35);
        make.left.equalTo(self.coverView).offset(70);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(40);

    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reConnectButton);
        make.left.equalTo(self.reConnectButton.mas_right).offset(15);
        make.width.height.equalTo(self.reConnectButton);
        make.bottom.equalTo(self.coverView).offset(QM_IS_iPHONEX?-65:-35);
    }];
}

- (void)reConnectAction {
    self.reConnectBlock();
}

- (void)cancelAction {
    self.cancelBlock();
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _coverView;
}

- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _headerLabel.text = @"提示";
        _headerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headerLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"网络不稳定，请重连";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)reConnectButton {
    if (!_reConnectButton) {
        _reConnectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reConnectButton.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:15];
        [_reConnectButton setTitleColor:[QMThemeManager shared].mainColorModel.color forState:UIControlStateNormal];
        [_reConnectButton setBackgroundColor:[[QMThemeManager shared].mainColorModel color:0.1]];
        [_reConnectButton setTitle:@"立即重连" forState:UIControlStateNormal];
        [_reConnectButton addTarget:self action:@selector(reConnectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reConnectButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:15];
        _cancelButton.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
