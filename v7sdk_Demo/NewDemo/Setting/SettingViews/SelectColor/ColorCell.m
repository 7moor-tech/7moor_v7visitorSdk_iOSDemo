//
//  ColorCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/3/17.
//

#import "ColorCell.h"

@interface ColorCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *selectLab;


@end

@implementation ColorCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.selectLab];
        self.layer.cornerRadius = 30;
        self.layer.borderWidth = 1;
        self.clipsToBounds = true;
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.selectLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (UIColor *)getSelectColor {
    return self.bgView.backgroundColor;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectLab.hidden = !selected;
    if (self.selected) {
        self.layer.borderColor = UIColor.redColor.CGColor;
    } else {
        self.layer.borderColor = UIColor.blackColor.CGColor;
    }
}

- (void)setCellData:(UIColor *)color {
    self.bgView.backgroundColor = color;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}

- (UILabel *)selectLab {
    if (!_selectLab) {
        _selectLab = [UILabel new];
        _selectLab.textColor = UIColor.whiteColor;
        _selectLab.backgroundColor = UIColor.clearColor;
        _selectLab.text = @"✓";
        _selectLab.textAlignment = NSTextAlignmentCenter;
        _selectLab.font = [UIFont systemFontOfSize:30];
        _selectLab.hidden = true;
    }
    return _selectLab;
}


@end
