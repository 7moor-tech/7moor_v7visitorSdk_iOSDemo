//
//  QMChatCardCell.m
//  newDemo
//
//  Created by ZCZ on 2021/2/26.
//

#import "QMChatCardCell.h"

@interface QMChatCardCell ()

@property (nonatomic, strong) UIImageView *cardIcon;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *decLabel;
@property (nonatomic, strong) UILabel *priceLab;

@end

@implementation QMChatCardCell

- (void)setupSubviews {
    [super setupSubviews];
    
    [self.bubblesBgView addSubview:self.cardIcon];
    [self.bubblesBgView addSubview:self.titleLab];
    [self.bubblesBgView addSubview:self.decLabel];
    [self.bubblesBgView addSubview:self.priceLab];
    
    
    [self.cardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubblesBgView).offset(10);
        make.top.equalTo(self.bubblesBgView).offset(10);
        make.width.height.mas_equalTo(50);
        make.bottom.lessThanOrEqualTo(self.bubblesBgView).offset(-10);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cardIcon.mas_right).offset(10);
        make.top.equalTo(self.cardIcon);
        make.right.equalTo(self.bubblesBgView).offset(-10);
        make.width.mas_equalTo(170);
    }];
    
    [self.decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
        make.right.lessThanOrEqualTo(self.bubblesBgView).offset(-10);
        make.width.mas_equalTo(170);
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bubblesBgView).offset(-10);
        make.top.equalTo(self.decLabel);
        make.left.lessThanOrEqualTo(self.decLabel.mas_right);
    }];
    
}

- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];
    
    self.cardIcon.image = [UIImage imageNamed:@"chat_image_placeholder"];
    self.titleLab.text = @"卡片信息";
    self.decLabel.text = @"详情唯有";
    self.priceLab.text = @"$230.0";
}

- (UIImageView *)cardIcon {
    if (!_cardIcon) {
        _cardIcon = [UIImageView new];
        _cardIcon.contentMode = UIViewContentModeScaleAspectFill;
        _cardIcon.clipsToBounds = YES;
    }
    return _cardIcon;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:14];
    }
    return _titleLab;
}

- (UILabel *)decLabel {
    if (!_decLabel) {
        _decLabel = [UILabel new];
        _decLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
        _decLabel.textColor = isQMDarkStyle ? k_QMRGB(66, 66, 66) : UIColor.grayColor;
    }
    return _decLabel;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [UILabel new];
        _priceLab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
        _priceLab.textColor = [UIColor redColor];
    }
    return _priceLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
