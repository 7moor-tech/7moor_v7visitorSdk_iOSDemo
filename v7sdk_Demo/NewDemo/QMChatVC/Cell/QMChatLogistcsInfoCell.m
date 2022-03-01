//
//  QMLogistcsInfoCell.m
//  IMSDK-OC
//
//  Created by zcz on 2019/12/25.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMChatLogistcsInfoCell.h"
#import "QMRegexHandle.h"

#define k_showAll_noData_h (42)
@interface QMChatLogistcsInfoCell () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *msgLabel;
@property(nonatomic, strong) UITableView *rootTableView;

@property(nonatomic, strong) UIView *showMoreOrNoData;

@end

#define logistCodeFont  [UIFont fontWithName:QM_PingFangSC_Reg size:13]

@implementation QMChatLogistcsInfoCell
//- (void)dealloc {
////    [self.rootTableView removeObserver:self forKeyPath:@"contentSize"];
//}


- (void)setupSubviews {
    [super setupSubviews];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Med size:16];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.bubblesBgView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubblesBgView).offset(20);
        make.top.equalTo(self.bubblesBgView).offset(12);
        make.right.equalTo(self.bubblesBgView).offset(-14);
        make.height.mas_equalTo(21);
    }];
    
    UIView *line0 = [UIView new];
    line0.tag = 101;
    line0.backgroundColor = [UIColor colorWithHexString:@"0xEDEDED"];
    [self.bubblesBgView addSubview:line0];
//    line0.hidden = YES;
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bubblesBgView);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.bubblesBgView).offset(45);
    }];
    
    self.msgLabel = [[UILabel alloc] init];
    self.msgLabel.font = logistCodeFont;
    self.msgLabel.textColor = [UIColor blackColor];
    self.msgLabel.numberOfLines = 0;
    [self.bubblesBgView addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(line0.mas_bottom).offset(10).priority(999);
    }];

    
    self.rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bubblesBgView.frame), 50) style:UITableViewStylePlain];
    self.rootTableView.showsVerticalScrollIndicator = NO;
    self.rootTableView.scrollEnabled = NO;
    self.rootTableView.estimatedRowHeight = 200;
    self.rootTableView.rowHeight = UITableViewAutomaticDimension;
    self.rootTableView.tableFooterView = [UIView new];
    self.rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rootTableView.sectionFooterHeight = 41;
    self.rootTableView.dataSource = self;
    self.rootTableView.delegate = self;
    self.rootTableView.backgroundColor = [UIColor clearColor];
    [self.bubblesBgView addSubview:self.rootTableView];
    [self.rootTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubblesBgView);
        make.right.equalTo(self.bubblesBgView);
        make.top.equalTo(self.msgLabel.mas_bottom).offset(9);
//        make.height.mas_equalTo(233);
    }];
    
//    [self.rootTableView addObserver:self
//                                forKeyPath:@"contentSize"
//                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                                   context:NULL];

    [self.bubblesBgView addSubview:self.showMoreOrNoData];
    
    [self.showMoreOrNoData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubblesBgView);
        make.right.equalTo(self.bubblesBgView);
        make.top.equalTo(self.rootTableView.mas_bottom);
        make.height.mas_equalTo(k_showAll_noData_h);
        make.bottom.equalTo(self.bubblesBgView);
//        make.height.mas_equalTo(233);
    }];
    
    [self.bubblesBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avaterView.mas_right).offset(10).priorityHigh();
        make.width.mas_equalTo(240*kScale6).priorityHigh();
        make.bottom.equalTo(self.contentView);
//        make.height.mas_equalTo(320);
        make.top.equalTo(self.avaterView);
    }];
}


- (void)setCellData:(QMChatMessage *)message {
    [super setCellData:message];
    self.dataModel = message.msgTaskModel;
    
    
    self.titleLabel.text = self.dataModel.message;

    NSString *msgStr = [NSString stringWithFormat:@"%@\n%@", self.dataModel.list_title ? : @"", self.dataModel.list_num ?  : @""];
    
    self.msgLabel.text = msgStr;
    [self.msgLabel sizeToFit];

    
    CGFloat addHeight = [self getCellHeight:self.dataModel];

    CGFloat content_h = 0;
    CGFloat showAll_h = 0;
    
    if (self.dataModel.list.count > 3 || self.dataModel.list.count == 0) {
        showAll_h = k_showAll_noData_h;
    }
    
    [self.rootTableView reloadData];
    
    if (self.dataModel.list.count == 0) {
        self.rootTableView.hidden = YES;
    } else {
        self.rootTableView.hidden = NO;
    }
        
    [self setupShowMoreOrNoData:self.dataModel];
    
    content_h += 46 + 10 + self.msgLabel.frame.size.height + 9 + showAll_h;
    if (addHeight < content_h) {
        addHeight = content_h;
    }
    
    [self.showMoreOrNoData mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(showAll_h);
    }];
        
    [self.bubblesBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(addHeight).priority(999);;
        make.width.mas_equalTo(240*kScale6).priorityHigh();
    }];
    
        
}

- (void)setupShowMoreOrNoData:(QMLogistcsInfoModel *)model {
    if (self.dataModel.list.count == 0) {
        UIView *line = [self.showMoreOrNoData viewWithTag:201];
        if (line) {
            [line removeFromSuperview];
        }
        UIView *titleView = [self.showMoreOrNoData viewWithTag:203];
        if (titleView) {
            [titleView removeFromSuperview];
        }
        UIButton *btn = (UIButton *)[self.showMoreOrNoData viewWithTag:202];
        if (btn) {
            [btn removeFromSuperview];
        }
        UILabel *noMsgLab = (UILabel *)[self.showMoreOrNoData viewWithTag:200];
        if (!noMsgLab) {
            noMsgLab = [UILabel new];
            noMsgLab.tag = 200;
        }
        noMsgLab.text = self.dataModel.empty_message.length > 0 ? self.dataModel.empty_message : @"暂无物流信息".toLocalized;
        noMsgLab.textColor = [UIColor blackColor];
        noMsgLab.numberOfLines = 3;
        noMsgLab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:14];
        [self.showMoreOrNoData addSubview:noMsgLab];
        [noMsgLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.showMoreOrNoData);
            make.left.greaterThanOrEqualTo(self.showMoreOrNoData).offset(10);
            make.right.lessThanOrEqualTo(self.showMoreOrNoData).offset(-10);
        }];
    } else if (self.dataModel.list.count > 3) {
        
        UIView *noMsgLab = [self.showMoreOrNoData viewWithTag:200];;
        if (noMsgLab) {
            [noMsgLab removeFromSuperview];
        }
        
        UIView *line = [self.showMoreOrNoData viewWithTag:201];
        if (!line) {
            line = [UIView new];
            line.tag = 201;
        }
        line.backgroundColor = [UIColor colorWithHexString:@"0xEDEDED"];
        
        [self.showMoreOrNoData addSubview:line];
        
        UIButton *btn = (UIButton *)[self.showMoreOrNoData viewWithTag:202];
        if (!btn) {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 202;
        }
        btn.backgroundColor = [UIColor clearColor];
        
        btn.frame = CGRectMake(0, 1, self.showMoreOrNoData.frame.size.width, self.showMoreOrNoData.frame.size.height - 1);
        [self.showMoreOrNoData addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.showMoreOrNoData);
            make.height.mas_equalTo(41).priority(999);
        }];
        
        [btn setImage:[UIImage imageNamed:@"set_cell_arrow"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.frame.size.width - 32, 0, 18);
        UILabel *titleLab = (UILabel *)[self.showMoreOrNoData viewWithTag:203];
        if (!titleLab) {
            titleLab = [UILabel new];
            titleLab.tag = 203;
        }
        
        titleLab.text = @"查看更多".toLocalized;
        UIColor *color = [UIColor colorWithHexString:@"0x2684FF"];
        if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
            color = QMThemeManager.shared.mainColorModel.color;
        }
        
        titleLab.textColor = color;
        titleLab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:14];
        [self.showMoreOrNoData addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn).offset(27);
            make.centerY.equalTo(btn);
            make.right.equalTo(btn).offset(130);
            //                make.top.mas_equalTo(15);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.showMoreOrNoData).offset(18);
            make.top.equalTo(self.showMoreOrNoData);
            make.width.mas_equalTo(1);
            make.bottom.equalTo(titleLab).offset(-4);
        }];
    } else {
        UIView *noMsgLab = [self.showMoreOrNoData viewWithTag:200];;
        if (noMsgLab) {
            [noMsgLab removeFromSuperview];
        }
        UIView *line = [self.showMoreOrNoData viewWithTag:201];
        if (line) {
            [line removeFromSuperview];
        }
        UIButton *btn = (UIButton *)[self.showMoreOrNoData viewWithTag:202];
        if (btn) {
            [btn removeFromSuperview];
        }
        UIView *titleView = [self.showMoreOrNoData viewWithTag:203];
        if (titleView) {
            [titleView removeFromSuperview];
        }
    }
    
}

- (CGFloat)getCellHeight:(QMLogistcsInfoModel *)model {
    return [QMChatLogistcsInfoCell getCellHeigt:model];
}

+ (CGFloat)getCellHeigt:(QMLogistcsInfoModel *)model {
    
    NSString *numLabStr = [NSString stringWithFormat:@"%@\n%@", model.list_title ? : @"", model.list_num ?  : @""];

    CGFloat h = [numLabStr boundingRectWithSize:CGSizeMake(240*kScale6 - 20 - 14, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: logistCodeFont} context:nil].size.height;

    
    CGFloat showAll_h = 0;
    
    if (model.list.count > 3 || model.list.count == 0) {
        showAll_h = k_showAll_noData_h;
    }
    CGFloat addHeight = 46 + 10 + h + 9 + showAll_h/*tableviewContentInset*/;
    int i = 0;
    for (NSDictionary *dict in model.list) {
        NSString *title = dict[@"title"] ?: @"";
        CGFloat f = [QMLogistcsInfoSubCell getCellHeight:title];
        addHeight += f;
        i++;
        if (i == 3) {
            break;
        }
    }
    
    
    return addHeight;
}

- (UIView *)showMoreOrNoData {
    if (!_showMoreOrNoData) {
        _showMoreOrNoData = [UIView new];
        _showMoreOrNoData.backgroundColor = [UIColor clearColor];
    }
    return _showMoreOrNoData;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.list.count > 3 ? 3 : self.dataModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMLogistcsInfoSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    if (!cell) {
        cell = [[QMLogistcsInfoSubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
    }
    
    NSDictionary *dict = self.dataModel.list[indexPath.row];
//    QMLogistcsInfo *model = [[QMLogistcsInfo alloc] initWithDictionary:dict error:nil];
    QMLogistcsInfo *model = [QMLogistcsInfo yy_modelWithDictionary:dict];

    [cell setCellData:model];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        cell.verticalTopLine.hidden = YES;
        [cell setCireBlue];
    } else {
        cell.verticalTopLine.hidden = NO;
    }
    if (indexPath.row == self.dataModel.list.count - 1) {
        [cell setCireGreen];
        cell.verticalBottomLine.hidden = YES;
    } else {
        cell.verticalBottomLine.hidden = NO;
    }

    return cell;
}

- (void)tapAction:(UIControl *)tap {
    if (self.showMore) {
        self.showMore();
    }
}



@end





@interface QMLogistcsInfoSubCell ()
@property(nonatomic, strong) UIView *circularLine;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) UIView *downLine;
@end

#define QMTitleFont [UIFont fontWithName:QM_PingFangSC_Reg size:14]
@implementation QMLogistcsInfoSubCell

+ (CGFloat)getCellHeight:(NSString *)title {
    
    CGFloat height = 7.0 + 4 + [UIFont fontWithName:QM_PingFangSC_Reg size:12].lineHeight + 9;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    [attr addAttributes:@{NSFontAttributeName: QMTitleFont} range:NSMakeRange(0, attr.length)];

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240*kScale6 - 32 - 8, 300)];
    titleLabel.textColor = QMHEXRGB(0x333333);
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = attr;
    titleLabel.font = QMTitleFont;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [titleLabel sizeThatFits:CGSizeMake(240*kScale6 - 32 - 8, 300)];
    
    height += size.height;
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews {
    self.verticalTopLine = [UIView new];
    self.verticalTopLine.backgroundColor = QMHEXRGB(0xEDEDED);
    [self.contentView addSubview:self.verticalTopLine];
    
    self.verticalBottomLine = [UIView new];
    self.verticalBottomLine.backgroundColor = self.verticalTopLine.backgroundColor;
    [self.contentView addSubview:self.verticalBottomLine];
    
    self.downLine = [UIView new];
    self.downLine.backgroundColor = self.verticalTopLine.backgroundColor;
    [self.contentView addSubview:self.downLine];

    
    
    self.circularLine = [UIView new];
    self.circularLine.backgroundColor = QMHEXRGB(0xD9D9D9);
    self.circularLine.layer.cornerRadius = 4;
    [self.contentView addSubview:self.circularLine];
    
    self.titleLabel = [UILabel new];
//    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.font = QMTitleFont;
    self.titleLabel.textColor = QMHEXRGB(0x333333);
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
    self.timeLabel.textColor = QMHEXRGB(0x999999);
    [self.contentView addSubview:self.timeLabel];
    
    [self.verticalTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18);
        make.top.equalTo(self.contentView);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self.verticalBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalTopLine);
        make.top.equalTo(self.titleLabel.mas_centerY);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(7);
        make.left.equalTo(self.contentView).offset(32);
        make.right.equalTo(self.contentView).offset(-8);
//        make.width.mas_equalTo(240*kScale6 - 32 - 8).priority(999);
    }];
    
    
    [self.circularLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.verticalBottomLine);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.height.mas_equalTo(8);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.bottom.equalTo(self.contentView).offset(-9);
    }];
    
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel);
        make.bottom.equalTo(self.contentView).offset(-0.5);
        make.height.mas_equalTo(0.5);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setCellData:(QMLogistcsInfo *)model {
    NSString *title = model.title;
    self.circularLine.backgroundColor = QMHEXRGB(0xEBEBEB);
//    NSArray *arr = [QMRegexHandle getMobileNumberLoc:title];
    NSArray *arr = [QMRegexHandle getNumberLoc:title];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    [attr addAttributes:@{NSFontAttributeName: QMTitleFont} range:NSMakeRange(0, attr.length)];
    UIColor *color = QMHEXRGB(0xFF6B6B);
    if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
        color = QMThemeManager.shared.mainColorModel.color;
    }
    for (NSTextCheckingResult *result in arr) {
        NSRange rag = result.range;
        if (rag.location != NSNotFound) {
            [attr addAttributes:@{NSForegroundColorAttributeName: color} range:rag];
        }
    }
    
    self.titleLabel.attributedText = attr;
    
    self.timeLabel.text = model.desc;

}

- (void)setCireBlue {
    UIColor *color = QMHEXRGB(0x2684FF);
    if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
        color = QMThemeManager.shared.mainColorModel.color;
    }
    self.circularLine.backgroundColor = color;
}

- (void)setCireGreen {
    UIColor *color = QMHEXRGB(0x00C922);

    if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
        color = QMThemeManager.shared.mainColorModel.color;
    }
    self.circularLine.backgroundColor = color;
}



@end
