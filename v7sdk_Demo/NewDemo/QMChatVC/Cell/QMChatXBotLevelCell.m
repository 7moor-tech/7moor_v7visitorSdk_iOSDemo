//
//  QMChatXBotLevelCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/8.
//

#import "QMChatXBotLevelCell.h"
#import "QMChatTextView.h"

@interface QMChatXBotLevelCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) QMChatTextView *tipLab;
@property (nonatomic, strong) UICollectionView *collectView;

@end

@implementation QMChatXBotLevelCell

- (void)setupSubviews {
    [super setupSubviews];
    
    [self.bubblesBgView addSubview:self.tipLab];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubblesBgView).offset(3).priority(999);
        make.left.equalTo(self.bubblesBgView);
        make.right.lessThanOrEqualTo(self.bubblesBgView);
        make.height.mas_greaterThanOrEqualTo(30).priorityHigh();
//        make.bottom.equalTo(self.bubblesBgView);
    }];
    
    [self.contentView addSubview:self.collectView];
    
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLab.mas_bottom).offset(10);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.bubblesBgView).priority(999);
        make.width.mas_greaterThanOrEqualTo(120);
        make.height.mas_greaterThanOrEqualTo(50).priorityHigh();
    }];
    
}

- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];
        
    self.tipLab.attributedText = model.contentAttr;    
    self.bubblesBgView.backgroundColor = [UIColor clearColor];
    [self.collectView reloadData];
    
    if (model.type == ChatMessageRev) {
        if (QMThemeManager.shared.leftMsgTextColor.hasBeenSetColor) {
            UIColor *color = QMThemeManager.shared.leftMsgTextColor.color;
            self.tipLab.textColor = color;
        }
        if (QMThemeManager.shared.leftMsgBgColor.hasBeenSetColor) {
            UIColor *bgColor = QMThemeManager.shared.leftMsgBgColor.color;
            self.tipLab.backgroundColor = bgColor;
        }

    } else {
        if (QMThemeManager.shared.rightMsgTextColor.hasBeenSetColor) {
            UIColor *color = QMThemeManager.shared.rightMsgTextColor.color;
            self.tipLab.textColor = color;
        }
        if (QMThemeManager.shared.leftMsgBgColor.hasBeenSetColor) {
            UIColor *bgColor = QMThemeManager.shared.leftMsgBgColor.color;
            self.tipLab.backgroundColor = bgColor;
        }
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.message.flowList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_id" forIndexPath:indexPath];
    
    UILabel *lab = (UILabel *)[cell viewWithTag:120];
    if (!lab) {
        lab = [UILabel new];
        lab.tag = 120;
        lab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
        lab.textColor = k_QMRGB(21, 21, 21);
        [cell.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.centerY.equalTo(cell.contentView);
        }];
        
    }
    
    NSDictionary *dict = self.message.flowList[indexPath.row];
    NSString *title = dict[@"button"];
    lab.text = title;
    
    cell.layer.cornerRadius = 15;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = k_QMRGB(0, 129, 255).CGColor;
    cell.backgroundColor = UIColor.whiteColor;
    
        if (QMThemeManager.shared.leftMsgTextColor.hasBeenSetColor) {
            UIColor *color = QMThemeManager.shared.leftMsgTextColor.color;
            lab.textColor = color;
        }
        if (QMThemeManager.shared.leftMsgBgColor.hasBeenSetColor) {
            UIColor *bgColor = QMThemeManager.shared.leftMsgBgColor.color;
            cell.backgroundColor = bgColor;
        }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = k_QMRGB(180, 180, 180);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.backgroundColor = k_QMRGB(255, 255, 255);
    });
    if (self.sendText) {
        NSDictionary *dict = self.message.flowList[indexPath.row];
        NSString *recogType = dict[@"recogType"];
        if ([recogType isKindOfClass:[NSString class]] && [recogType isEqualToString:@"4"]) {
            // 自定义事件
        } else {
            NSString *title = dict[@"text"];
            self.sendText(title);
        }
    }
    
}

- (UICollectionView *)collectView {
    if (!_collectView) {
        UICollectionViewFlowLayout *flowlayout = [UICollectionViewFlowLayout new];
        flowlayout.estimatedItemSize = CGSizeMake(80, 30);
        flowlayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowlayout.minimumInteritemSpacing = 10;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowlayout];
//        collectionView.backgroundColor = k_QMRGB(245, 245, 245);
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell_id"];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = UIColor.clearColor;
        _collectView = collectionView;
    }
    return _collectView;
}

- (QMChatTextView *)tipLab {
    if (!_tipLab) {
        _tipLab = [QMChatTextView new];
        _tipLab.font = k_Chat_Font;
        _tipLab.textColor = k_QMRGB(21, 21, 21);
        _tipLab.backgroundColor = [UIColor whiteColor];
        _tipLab.layer.cornerRadius = 10;
        _tipLab.clipsToBounds = YES;
        _tipLab.contentInset = UIEdgeInsetsMake(15, 8, 8, 6);
    }
    return _tipLab;
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
