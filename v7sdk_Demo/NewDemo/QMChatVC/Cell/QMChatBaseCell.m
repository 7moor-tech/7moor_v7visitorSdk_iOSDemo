//
//  QMChatBaseCell.m
//  newDemo
//
//  Created by lishuijiao on 2021/2/4.
//

#import "QMChatBaseCell.h"
#import <SDWebImage.h>
#import "UIImage+Clip.h"


CGFloat kChatDateHeight = 45.0;

@implementation QMChatBaseCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        [self setupGestureRecognizer];
        [self setupTapRecognizer];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.avaterView];
    [self.contentView addSubview:self.sendStatus];
    [self.contentView addSubview:self.bubblesBgView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.readStatus];
    [self.contentView addSubview:self.serviceLab];
    
    
    CGFloat iconWidth = QMThemeManager.shared.iconModel.isIcon ? 0 : 45;
//    CGFloat iconWidth = 40;

    if (QMThemeManager.shared.iconModel.isToBounds) {
        self.avaterView.layer.masksToBounds = true;
        self.avaterView.clipsToBounds = YES;
    }
    if (QMThemeManager.shared.iconModel.cornerRadius > 0) {
        self.avaterView.layer.cornerRadius = QMThemeManager.shared.iconModel.cornerRadius;
    }
    
    if (QMThemeManager.shared.msgHeadImgAngle == QMMsgHeadImgAngleTypeRound) {
        self.avaterView.layer.cornerRadius = iconWidth/2.0;
    } else if (QMThemeManager.shared.msgHeadImgAngle == QMMsgHeadImgAngleTypeRectAngle) {
        self.avaterView.layer.cornerRadius = 8;
    }
    

    /// 布局****************************开始
    

    [self.avaterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(25).priorityHigh();
        make.width.height.mas_equalTo(iconWidth).priority(999);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-10);
    }];
    
    [self.serviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(iconWidth + 20);
        make.top.equalTo(self.avaterView).priority(999);
        make.height.mas_equalTo(14).priority(999);
        make.right.lessThanOrEqualTo(self.contentView);
    }];
    
    [self.bubblesBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(iconWidth + 15);
        make.right.equalTo(self.contentView).offset(-iconWidth - 15);
        make.top.equalTo(self.avaterView).offset(21).priority(999);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(20);
    }];
    
}

- (void)setupTapRecognizer {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerAction)];
    [self.bubblesBgView addGestureRecognizer:tapRecognizer];
}

- (void)setupGestureRecognizer {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 3;
    [self.bubblesBgView addGestureRecognizer:longPress];

    
}

- (void)tapRecognizerAction {
//    [self.bubblesBgView endEditing:YES];
    [self resignFirstResponder];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)press {
    if (press.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        CGPoint point = [press locationInView:self.bubblesBgView];
        
        if (self.message.type == ChatMessageRev) {
            UIView *touchView = press.view;
            if (![touchView isKindOfClass:UILabel.class]) {
                return;
            }
        }
        
        UIMenuController *menuVC = [UIMenuController sharedMenuController];
        if (self.message.type == ChatMessageSend) {
            UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"撤回".toLocalized action:@selector(revocation:)];
            menuVC.menuItems = @[item];
        } else {
            
        }
        CGRect frame = CGRectMake(point.x - 25, point.y, 50, 20);
        if (@available(iOS 13, *)) {
            [menuVC showMenuFromView:self rect:self.bubblesBgView.frame];
        } else {
            [menuVC setTargetRect:frame inView:self];
            [menuVC setMenuVisible:YES];
        }
    }
    
    if (press.state == UIGestureRecognizerStateEnded || press.state == UIGestureRecognizerStateFailed || press.state == UIGestureRecognizerStateCancelled) {
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    } else if (action == @selector(select:)) {
        return false;
    } else if (action == @selector(delete:)) {
        return false;
    } else if (action == @selector(revocation:)) {
        if (self.message.type == ChatMessageSend)
        return YES;
    }
    return false;
}

- (void)revocation:(id)sender {
    
}
- (void)select:(id)sender {
//    [super select:sender];
}

- (void)delete:(id)sender {
//    [super delete:sender];
}

- (void)copy:(id)sender {
//    [super copy:sender];
}

- (void)setCellData:(QMChatMessage *)model {
    self.message = model;

    [self setConstraintMaker:model];
    
    self.timeLabel.hidden = !model.showDate;
    
    if (model.showDate) {
        if (model.createTimestamp > 0) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:model.createTimestamp/1000.0];
            NSString *timeString = [self getTimeString:date];
            if ([calendar isDateInToday:date]) {
                NSString *time = (NSString *)[timeString componentsSeparatedByString:@" "].lastObject;
                self.timeLabel.text = [@"今天".toLocalized stringByAppendingString:time];
            } else if ([calendar isDateInYesterday:date]) {
                NSString *time = (NSString *)[timeString componentsSeparatedByString:@" "].lastObject;
                self.timeLabel.text = [@"昨天".toLocalized stringByAppendingString:time];;
                
            } else {
                self.timeLabel.text = timeString ? : @"32312d31";
            }
        } else {
            self.timeLabel.text = model.createTime ? : @"12121212";
        }
    }
    
}

- (NSString *)getTimeString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";

    return [dateFormatter stringFromDate:date];
}

- (void)setConstraintMaker:(QMChatMessage *)model {
    CGFloat iconWidth = QMThemeManager.shared.iconModel.isIcon ? 0 : 45;
//    CGFloat iconWidth = 40;
    
    CGFloat distanceTop = 10.0;
    if (model.showDate) {
        distanceTop = 50.0 + 14;
    }
    
    if (model.type == ChatMessageRev) {
        
        NSString *headerStr = model.userHeadImg ? : @"";
    
        NSURL *headerUrl = [NSURL URLWithString:headerStr];
        self.readStatus.hidden = YES;
        NSString *placeHolder = [model.userId isEqualToString:@"system"] ? @"chat_avater_agent" : @"chat_avater_robot";
        
        if (headerUrl.absoluteString.length == 0 && [model.userId isEqualToString:@"system"] && QMThemeManager.shared.sysMsgHeadImgUrl.length > 0) {
            NSString *sysHeader = QMThemeManager.shared.sysMsgHeadImgUrl;
            if ([sysHeader hasPrefix:@"http"] == false) {
                sysHeader = [[QMConnect sdkGetQiniuURL] stringByAppendingPathComponent:sysHeader].stringByRemovingPercentEncoding;
                sysHeader = [sysHeader stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLFragmentAllowedCharacterSet];
            }
            headerUrl = [NSURL URLWithString:sysHeader];
        } else {
            if (headerStr.length > 0 && [headerStr hasPrefix:@"http"] == false) {
                if ([headerStr.stringByRemovingPercentEncoding isEqualToString:headerStr]) {
                    headerStr = [headerStr stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
                }
                headerStr = [[QMConnect sdkGetCommonURL] stringByAppendingString:[NSString stringWithFormat:@"/%@",headerStr]];
               
                headerUrl = [NSURL URLWithString:headerStr];

            }
        }
        
        [self.avaterView sd_setImageWithURL:headerUrl placeholderImage:[UIImage imageNamed:placeHolder]];
        if (QMThemeManager.shared.leftMsgBgColor.hasBeenSetColor) {
            self.bubblesBgView.backgroundColor = QMThemeManager.shared.leftMsgBgColor.color;
        } else {
            self.bubblesBgView.backgroundColor = UIColor.whiteColor;
        }
        
        NSString *userName = model.userName;
//        if (userName.length == 0 && [model.userId isEqualToString:@"system"]) {
//            userName = @"系统";
//            model.userName = userName;
//        }
        if (userName.length > 10) {
            userName = [userName substringToIndex:9];
        }
        
        self.serviceLab.text = userName;
        
        [self.avaterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.top.equalTo(self.contentView).offset(distanceTop).priorityHigh();
            make.width.height.mas_equalTo(iconWidth).priority(999);
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-5);
        }];
        
        [self.bubblesBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (userName.length > 0) {
                make.top.equalTo(self.serviceLab).offset(10 + 14).priority(999);
            } else {
                make.top.equalTo(self.serviceLab).priority(999);
            }
            make.top.equalTo(self.serviceLab.mas_bottom).offset(4).priority(999);
            make.left.equalTo(self.contentView).offset(iconWidth + 20).priority(999);
//            make.right.lessThanOrEqualTo(self.contentView).offset(-25 - iconWidth);
            make.width.mas_lessThanOrEqualTo(240*kScale6);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.height.mas_greaterThanOrEqualTo(45);
        }];
        

        [self.sendStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bubblesBgView);
            make.height.mas_offset(20);
            make.width.mas_equalTo(20);
            make.left.equalTo(self.bubblesBgView.mas_right).offset(4);
        }];
        
        [self.readStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.sendStatus);
        }];
        
    }else {
        
        self.serviceLab.text =  @"";
        NSString *headerUrl = model.visitorHeadImg ? : @"";
        if ([headerUrl.stringByRemovingPercentEncoding isEqualToString:headerUrl]) {
            headerUrl = [headerUrl stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        }
          [self.avaterView sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"moor_head_default_right"]];

        if (QMThemeManager.shared.rightMsgBgColor.hasBeenSetColor) {
            UIColor *bgColor = QMThemeManager.shared.rightMsgBgColor.color;
            if (bgColor) {
                self.bubblesBgView.backgroundColor = bgColor;
            }
        } else {
            self.bubblesBgView.backgroundColor = k_QMRGB(148, 207, 252);
        }
        
        [self.avaterView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-12);
            make.top.equalTo(self.contentView).offset(distanceTop).priorityHigh();
            make.width.height.mas_equalTo(iconWidth).priority(999);
//            make.bottom.greaterThanOrEqualTo(self.contentView).offset(-5);
        }];
        
        [self.bubblesBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avaterView).priority(1000);
//            make.left.greaterThanOrEqualTo(self.contentView).offset(25 + iconWidth);
            make.width.mas_lessThanOrEqualTo(240*kScale6);
            make.right.equalTo(self.contentView).offset(-20 - iconWidth).priority(999);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.height.mas_greaterThanOrEqualTo(45);
        }];
                
        [self.sendStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bubblesBgView);
            make.height.mas_offset(20);
            make.width.mas_equalTo(20);
            make.right.equalTo(self.bubblesBgView.mas_left).offset(-4);
        }];
        
        [self.readStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bubblesBgView.mas_bottom).offset(-6);
            make.height.mas_equalTo(14);
            make.width.mas_equalTo(14);
            make.right.equalTo(self.bubblesBgView.mas_left).offset(-10);
        }];
        
        [self setMessageIsRead:model.isRead];
    }
    
    [self changeMessageStatus:model];
}

- (void)setMessageIsRead:(NSString *)isRead {
    
    if ([isRead isEqualToString:@"1"]) {
        self.readStatus.image = [UIImage imageNamed:@"QMChat_Read_Icon"];
    } else {
        self.readStatus.image = [UIImage convertViewToImage:self.unReadStatus];
    }
}

- (void)changeMessageStatus:(QMChatMessage *)model {
    if (model.type == ChatMessageRev) {
        [NSNotificationCenter.defaultCenter removeObserver:self];
        self.sendStatus.hidden = YES;
        self.readStatus.hidden = YES;
        
    } else {
        [NSNotificationCenter.defaultCenter removeObserver:self];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(upSendStatusAction:) name:model.messageId object:nil];
        
        self.sendStatus.hidden = YES;
        if ([QMThemeManager shared].isShowRead &&
            [model.status isEqualToString:@"0"]) {
            [self removeSendingAnimation];
            self.readStatus.hidden = NO;
        }
        else {
            self.readStatus.hidden = YES;
            if ([model.status isEqualToString:@"0"]) {
                self.sendStatus.hidden = YES;
            }else if ([model.status isEqualToString:@"1"]) {
                self.sendStatus.hidden = NO;
                self.sendStatus.enabled = YES;
                [self removeSendingAnimation];
            } else if ([model.status isEqualToString:@"2"]) {
                self.sendStatus.hidden = NO;
                self.sendStatus.enabled = NO;
                [self showSendingAnimation];
            }
        }

    }
}

- (void)upSendStatusAction:(NSNotification *)notif {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *status = (NSString *)notif.object;
        if ([status isKindOfClass:NSString.class]) {
            self.message.status = status;
            if ([status isEqualToString:@"0"]) {
                self.sendStatus.hidden = YES;
                self.readStatus.hidden = NO;
            }else if ([status isEqualToString:@"1"]) {
                self.sendStatus.hidden = NO;
                self.sendStatus.enabled = YES;
                self.readStatus.hidden = YES;
                [self removeSendingAnimation];
            } else if ([status isEqualToString:@"2"]) {
                self.sendStatus.hidden = NO;
                self.sendStatus.enabled = NO;
                [self showSendingAnimation];
            }
        }
    });
}

- (void)showSendingAnimation {
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0.0;
    animation.toValue = @(2*M_PI);
    animation.duration = 1.0;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    __weak QMChatBaseCell *strongSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [strongSelf.sendStatus.layer addAnimation:animation forKey:@"transform.rotation.z"];
    });
}

- (void)removeSendingAnimation {
    __weak QMChatBaseCell *strongSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [strongSelf.sendStatus.layer removeAnimationForKey:@"transform.rotation.z"];
    });
}

- (void)reSendAction:(UIButton *)gesture {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"重新发送消息Y/N".toLocalized preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * doneAction = [UIAlertAction actionWithTitle:@"确定".toLocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self->_message.status isEqualToString:@"1"]) {
            [QMConnect reSendMessage:self.message];
        }
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消".toLocalized style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alert addAction:doneAction];
    [alert addAction:cancelAction];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
}

- (UIImageView *)avaterView {
    if (!_avaterView) {
        _avaterView = [[UIImageView alloc] init];
        _avaterView.backgroundColor = [UIColor clearColor];
        _avaterView.contentMode = UIViewContentModeScaleAspectFill;
        _avaterView.clipsToBounds = YES;
    }
    return _avaterView;
}

- (UILabel *)serviceLab {
    if (!_serviceLab) {
        _serviceLab = [[UILabel alloc] init];
        _serviceLab.textAlignment = NSTextAlignmentLeft;
        _serviceLab.backgroundColor = [UIColor clearColor];
        _serviceLab.textColor = [UIColor colorWithHexString:QMColor_666666_timeLabel];
        _serviceLab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
    }
    return _serviceLab;}

- (UIButton *)sendStatus {
    if (!_sendStatus) {
        _sendStatus = [UIButton buttonWithType:UIButtonTypeCustom];
//        _sendStatus = [[UIImageView alloc] init];
//        _sendStatus.userInteractionEnabled = YES;
        [_sendStatus setImage:[UIImage imageNamed:@"qm_sending"] forState:UIControlStateDisabled];
        [_sendStatus setImage:[UIImage imageNamed:@"qm_send_failed"] forState:UIControlStateNormal];
        _sendStatus.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_sendStatus addTarget:self action:@selector(reSendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendStatus;
}

- (UIView *)bubblesBgView {
    if (!_bubblesBgView) {
        _bubblesBgView = [[UIView alloc] init];
        _bubblesBgView.layer.masksToBounds = YES;
        _bubblesBgView.layer.cornerRadius = 10;
//        _bubblesBgView.userInteractionEnabled = YES;
    }
    return _bubblesBgView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
//        _timeLabel.hidden = YES;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor colorWithHexString:QMColor_666666_timeLabel];
        _timeLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
    }
    return _timeLabel;
}

- (UIImageView *)readStatus {
    if (!_readStatus) {
        _readStatus = [[UIImageView alloc] init];
        
    }
    return _readStatus;
}

- (QMCircleView *)unReadStatus {
    if (!_unReadStatus) {
        _unReadStatus = [[QMCircleView alloc] init];
        _unReadStatus.frame = CGRectMake(0, 0, 16, 16);
        _unReadStatus.backgroundColor = [UIColor clearColor];
    }
    return _unReadStatus;
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
