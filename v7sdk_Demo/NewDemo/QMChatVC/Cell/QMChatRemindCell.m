//
//  QMChatRemindCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/5/25.
//

#import "QMChatRemindCell.h"

@interface QMChatRemindCell ()

@property (nonatomic, strong) UILabel *remindLab;

@end

@implementation QMChatRemindCell

- (void)setCellData:(QMChatMessage *)model {
    self.remindLab.text = model.content;
}

- (void)setupSubviews {
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.remindLab];
    [self.remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(30);
        make.right.equalTo(self.contentView).offset(-30);
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)setupGestureRecognizer {
    
}

- (UILabel *)remindLab {
    if (!_remindLab) {
        _remindLab = [UILabel new];
        _remindLab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
        _remindLab.numberOfLines = 2;
        _remindLab.textAlignment = NSTextAlignmentCenter;
        _remindLab.textColor = k_QMRGB(153, 153, 153);
    }
    
    return _remindLab;
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
