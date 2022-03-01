//
//  SettingCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/3/16.
//

#import "SettingCell.h"

@interface SettingCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *showColorView;
@property (nonatomic, strong) UISwitch *switchBtn;


@end

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.showColorView];
    [self.contentView addSubview:self.switchBtn];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-15).priorityHigh();
        make.top.equalTo(self.contentView).offset(15).priorityHigh();
        make.height.mas_greaterThanOrEqualTo(20);
        make.left.mas_equalTo(18);
    }];
    
    [self.showColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.contentView);
    }];
    
}

- (void)setModel:(QMUIItem *)model {
    
    NSString *title = @"";
    switch (model.mode) {
        case SettModeNav:
            title = @"导航栏颜色";
            break;
    
        case SettModeCustomer:
            title = @"转人工按钮颜色";
            break;
            
        case SettModeLogout:
            title = @"注销返回颜色";
            break;
            
        case SettModeEmj:
            title = @"表情按钮隐藏";
            break;
            
        case SettModePic:
            title = @"发送图片按钮隐藏";
            break;
            
        case SettModeFile:
            title = @"发送文件按钮隐藏";
            break;
            
        case SettModeVoice:
            title = @"语音按钮隐藏";
            break;
        case SettModeVideo:
            title = @"视频按钮隐藏";
            break;
            
        case SettModeExtend:
            title = @"扩展按钮隐藏";
            break;
            
        case SettModeQuestion:
            title = @"常见问题按钮隐藏";
            break;
            
        case SettModeEvaluate:
            title = @"评价按钮隐藏";
            break;

    }
    
    self.titleLab.text = title;
    
    if (model.mode == SettModeNav || model.mode == SettModeLogout || model.mode == SettModeCustomer) {
        self.switchBtn.hidden = YES;
        self.showColorView.hidden = NO;
        self.showColorView.backgroundColor = model.color.color ? : UIColor.whiteColor;
    } else {
        self.switchBtn.hidden = NO;
        self.switchBtn.on = model.isHidden;
        self.showColorView.hidden = YES;
    }
    
    _model = model;
}

- (void)switchAction:(UISwitch *)sender {
    self.model.isHidden = sender.isOn;
    if (self.selectOn) {
        self.selectOn(sender.isOn, self.model.mode);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:18];
        
    }
    return _titleLab;
}

- (UIView *)showColorView {
    if (!_showColorView) {
        _showColorView = [UIView new];
        _showColorView.layer.borderWidth = 1;
        _showColorView.layer.cornerRadius = 15;
    }
    return _showColorView;
}

- (UISwitch *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [UISwitch new];
        [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

@end
