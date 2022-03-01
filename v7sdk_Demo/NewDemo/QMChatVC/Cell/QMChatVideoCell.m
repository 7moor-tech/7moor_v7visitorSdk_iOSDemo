//
//  QMChatVideoCell.m
//  newDemo
//
//  Created by ZCZ on 2021/2/25.
//

#import "QMChatVideoCell.h"

@interface QMChatVideoCell ()
@property (nonatomic, strong) UIButton *playBtn;
@end

@implementation QMChatVideoCell

- (void)setupSubviews {
    [super setupSubviews];
    
    [self.showImageView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.showImageView);
        make.width.height.mas_equalTo(60);
    }];
}

- (void)playerAction:(UIButton *)sender {
    
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"chat_video_player"] forState:UIControlStateNormal];
        _playBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_playBtn addTarget:self action:@selector(playerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
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
