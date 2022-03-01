//
//  QMChatOrderCardCell.m
//  NewDemo
//
//  Created by lishuijiao on 2021/6/15.
//

#import "QMChatOrderCardCell.h"

@interface QMChatOrderCardCell ()

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UILabel *orderNum;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *content;

@property (nonatomic, strong) UILabel *price;

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) NSDictionary *cardDic;
@property (nonatomic, strong) NSDictionary *listOneDic;
@end

@implementation QMChatOrderCardCell

- (void)setupSubviews {
    [super setupSubviews];
    
    [self.bubblesBgView addSubview:self.title];
    [self.bubblesBgView addSubview:self.orderNum];
    [self.bubblesBgView addSubview:self.line];
    [self.bubblesBgView addSubview:self.imgView];
    [self.bubblesBgView addSubview:self.content];
    [self.bubblesBgView addSubview:self.price];
    [self.bubblesBgView addSubview:self.leftBtn];
    [self.bubblesBgView addSubview:self.rightBtn];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bubblesBgView).offset(15);
        make.right.equalTo(self.bubblesBgView).offset(-15);
        make.height.mas_equalTo(16);
    }];
    
    [self.orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(14);
        make.left.equalTo(self.bubblesBgView).offset(15);
        make.right.equalTo(self.bubblesBgView).offset(-15);
        make.height.mas_equalTo(13);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNum.mas_bottom).offset(15);
        make.left.right.equalTo(self.bubblesBgView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(15);
        make.left.equalTo(self.bubblesBgView).offset(15);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(13);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.right.equalTo(self.bubblesBgView).offset(-15);
        make.height.mas_lessThanOrEqualTo(60);
    }];
    
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imgView.mas_bottom);
        make.left.equalTo(self.imgView.mas_right).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(11);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(20);
        make.left.equalTo(self.bubblesBgView.mas_right).offset(-85);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
        make.bottom.equalTo(self.bubblesBgView).offset(-15);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightBtn);
        make.left.equalTo(self.rightBtn.mas_left).offset(-80);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
    }];
}

- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];

    self.bubblesBgView.backgroundColor = UIColor.whiteColor;
    
    self.cardDic = model.orderCard;
    NSDictionary *dic = model.orderCard;
    NSString *title = [dic objectForKey:@"orderTitle"];
    NSString *orderNumName = [dic objectForKey:@"orderNumName"];
    NSString *orderNum = [dic objectForKey:@"orderNum"];
    NSArray *orderList = [dic objectForKey:@"orderList"];

    if (title.length) {
        self.title.text = title;
    }
    
    if (orderNumName.length && orderNum.length) {
        self.orderNum.text = [NSString stringWithFormat:@"%@ %@",orderNumName, orderNum];
    }
    
    if (orderList.count) {
        self.listOneDic = [orderList firstObject];
        NSDictionary *listDic = [orderList firstObject];
        self.content.text = [listDic objectForKey:@"content"];
        if ([listDic objectForKey:@"price"]) {
            self.price.text = [listDic objectForKey:@"price"];
        }
        NSString *imgStr = [listDic objectForKey:@"imgUrl"];
        if (imgStr.length) {
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"chat_image_placeholder"]];
        }
    }
    
    BOOL leftBtnShow = [[dic objectForKey:@"btnLeftShow"] boolValue];
    BOOL rightBtnShow = [[dic objectForKey:@"btnRightShow"] boolValue];

    if (rightBtnShow) {
        [self.rightBtn setTitle:[dic objectForKey:@"btnRightText"] forState:UIControlStateNormal];
        self.rightBtn.layer.borderWidth = 0.5;
        [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(20);
            make.left.equalTo(self.bubblesBgView.mas_right).offset(-85);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(25);
            make.bottom.equalTo(self.bubblesBgView).offset(-15);
        }];
    }else {
        self.rightBtn.layer.borderWidth = 0.0;
        [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(20);
            make.left.equalTo(self.bubblesBgView.mas_right).offset(-5);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(25);
            make.bottom.equalTo(self.bubblesBgView).offset(-15);
        }];
    }

    if (leftBtnShow) {
        self.leftBtn.layer.borderWidth = 0.5;
        [self.leftBtn setTitle:[dic objectForKey:@"btnLeftText"] forState:UIControlStateNormal];
        
        [self.leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rightBtn);
            make.left.equalTo(self.rightBtn.mas_left).offset(-80);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(25);
        }];
    }else {
        self.leftBtn.layer.borderWidth = 0.0;
        [self.leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rightBtn);
            make.left.equalTo(self.rightBtn.mas_left).offset(-80);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];

    }
    
    if (leftBtnShow == false && rightBtnShow == false) {
        [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(20);
            make.left.equalTo(self.bubblesBgView.mas_right).offset(-5);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
            make.bottom.equalTo(self.bubblesBgView);
        }];
    }
}

- (void)leftAction {
    NSString *btnLeftTarget = self.cardDic[@"btnLeftTarget"];
    NSString *btnLeftUrl = self.cardDic[@"btnLeftUrl"];
    if ([btnLeftTarget isEqualToString:@"url"] && btnLeftUrl.length) {
        if (self.pushWebView) {
            self.pushWebView([NSURL URLWithString:btnLeftUrl]);
        }
    }
}

- (void)rightAction {
    NSString *btnRightTarget = self.cardDic[@"btnRightTarget"];
    NSString *btnRightUrl = self.cardDic[@"btnRightUrl"];
    if ([btnRightTarget isEqualToString:@"url"] && btnRightUrl.length) {
        if (self.pushWebView) {
            self.pushWebView([NSURL URLWithString:btnRightUrl]);
        }
    }
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    BOOL isPoint = [super pointInside:point withEvent:event];
//
//    CGFloat maxY = CGRectGetMaxY(self.bubblesBgView.frame);
//    if (point.y < maxY - 50) {
//        [self clickAction];
//    }
//
//    return isPoint;
//}

- (void)tapRecognizerAction {
    [super tapRecognizerAction];
    [self clickAction];
}

- (void)clickAction {
    if (_listOneDic.count) {
        NSString *clickTarget = _listOneDic[@"clickTarget"];
        NSString *clickUrl = _listOneDic[@"clickUrl"];
        if ([clickTarget isEqualToString:@"url"] && clickUrl.length > 0) {
            if (self.pushWebView) {
                self.pushWebView([NSURL URLWithString:clickUrl]);
            }
        }
    }
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont fontWithName:QM_PingFangSC_Med size:16];
        _title.textColor = [UIColor colorWithHexString:QMColor_151515_text];
    }
    return _title;
}

- (UILabel *)orderNum {
    if (!_orderNum) {
        _orderNum = [[UILabel alloc] init];
        _orderNum.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
        _orderNum.textColor = [UIColor colorWithHexString:QMColor_999999_text];
    }
    return _orderNum;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
    }
    return _line;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 8;
        _imgView.layer.borderWidth = 0.5;
        _imgView.layer.borderColor = [UIColor colorWithHexString:@"#ededed"].CGColor;
    }
    return _imgView;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.font = [UIFont fontWithName:QM_PingFangSC_Reg size:14];
        _content.textColor = [UIColor colorWithHexString:QMColor_666666_text];
        _content.numberOfLines = 2;
    }
    return _content;
}

- (UILabel *)price {
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.font = [UIFont fontWithName:QM_PingFangSC_Reg size:14];
        _price.textColor = [QMThemeManager shared].mainColorModel.color;
    }
    return _price;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.layer.cornerRadius = 12.5;
        _leftBtn.layer.borderWidth = 0.5;
        _leftBtn.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
        _leftBtn.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:QMColor_666666_text] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.layer.cornerRadius = 12.5;
        _rightBtn.layer.borderWidth = 0.5;
        _rightBtn.layer.borderColor = [[QMThemeManager shared].mainColorModel color:0.1].CGColor;
        _rightBtn.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
        [_rightBtn setTitleColor:[QMThemeManager shared].mainColorModel.color forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (NSDictionary *)cardDic {
    if (!_cardDic) {
        _cardDic = [[NSDictionary alloc] init];
    }
    return _cardDic;
}

- (NSDictionary *)listOneDic {
    if (!_listOneDic) {
        _listOneDic = [[NSDictionary alloc] init];
    }
    return _listOneDic;
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
