//
//  QMChatXBotFormCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/8.
//

#import "QMChatXBotFormCell.h"
#import "QMChatFormView.h"

@interface QMChatXBotFormCell ()
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIButton *makeForm;

@end

@implementation QMChatXBotFormCell


- (void)setupSubviews {
    [super setupSubviews];
    [self.bubblesBgView addSubview:self.titleLab];
    [self.bubblesBgView addSubview:self.makeForm];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubblesBgView).offset(3).priority(999);
        make.left.equalTo(self.bubblesBgView).offset(10);
        make.right.equalTo(self.bubblesBgView).offset(-10);
        make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
    }];
    
    [self.makeForm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).priority(999);
        make.left.equalTo(self.bubblesBgView).offset(10);
        make.right.equalTo(self.bubblesBgView).offset(-10);
        make.bottom.equalTo(self.bubblesBgView);
//        make.height.mas_greaterThanOrEqualTo(40).priorityHigh();
    }];
}


- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];
    self.titleLab.text = model.formDict[@"formPrompt"];
    [self.makeForm setTitle:model.formDict[@"formName"] forState:UIControlStateNormal];
}

- (void)makeFormAction:(UIButton *)sender {
    
}


- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = k_Chat_Font;
        _titleLab.textColor = UIColor.blackColor;
    }
    return _titleLab;
}

- (UIButton *)makeForm {
    if (!_makeForm) {
        _makeForm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_makeForm setTitleColor:k_QMRGB(0, 129, 255) forState:UIControlStateNormal];
        _makeForm.titleLabel.font = k_Chat_Font;
        [_makeForm addTarget:self action:@selector(makeFormAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _makeForm;
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
