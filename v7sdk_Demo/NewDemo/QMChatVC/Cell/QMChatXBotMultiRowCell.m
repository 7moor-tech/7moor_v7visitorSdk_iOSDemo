//
//  QMChatXBotMultiRowCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/8.
//

#import "QMChatXBotMultiRowCell.h"
#import "QMChatTextView.h"
#import <objc/message.h>
#import "UIImage+Color.h"

@interface QMChatXBotMultiRowCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) QMChatTextView *tipLab;
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) NSMutableArray *selectArr;

@property (nonatomic, strong) UIView *containerView;


@end

@implementation QMChatXBotMultiRowCell

- (void)dealloc {
    [self.collectView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)setupSubviews {
    
    [self.collectView addObserver:self
                                forKeyPath:@"contentSize"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:NULL];
    [super setupSubviews];
    
//    [self.bubblesBgView addSubview:self.tipLab];
//    self.bubblesBgView.layer.borderWidth = 2;
    [self.bubblesBgView addSubview:self.containerView];
    [self.containerView addSubview:self.tipLab];

    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubblesBgView).priority(888);
        make.left.equalTo(self.bubblesBgView);
        make.right.equalTo(self.bubblesBgView);
        make.bottom.equalTo(self.tipLab).priority(999);
        make.height.mas_greaterThanOrEqualTo(45).priority(999);
    }];

    [self.contentView addSubview:self.collectView];
    [self.contentView addSubview:self.sureButton];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(3).priority(888);
        make.left.equalTo(self.containerView).offset(10);
        make.right.equalTo(self.containerView).offset(-10);
        make.bottom.equalTo(self.containerView).offset(-3).priority(999);
    }];
    
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).offset(10);
        make.left.equalTo(self.bubblesBgView);
        make.right.equalTo(self.contentView).offset(-20);
//        make.bottom.equalTo(self.bubblesBgView).priority(999);
        make.width.mas_greaterThanOrEqualTo(120);
        make.height.mas_equalTo(150).priorityHigh();
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectView.mas_bottom).offset(10);
        make.left.equalTo(self.bubblesBgView);
        make.bottom.equalTo(self.bubblesBgView).priority(800);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(35).priorityHigh();
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentSize"]) {
            NSValue *newSizeValue = change[@"new"];
            NSValue *oldSizeValue = change[@"old"];
            CGSize newSize = [newSizeValue CGSizeValue];
            CGSize oldSize = [oldSizeValue CGSizeValue];
            // 判断条件：若新值与旧值相等即ContentSize没有发生变化则忽略
            if (![newSizeValue isEqualToValue:oldSizeValue] && newSize.height != oldSize.height) {
                CGFloat height = newSize.height;
                height = height > 150 ? 150 : height;
                height = height/30 > 2 ? height : height/2 > 1 ? height - 10 : height;

                [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(height).priorityHigh();
                }];
                
                [self updateConstraintsIfNeeded];
                
                if (self.upCellConstraint) {
                    self.upCellConstraint(nil);
                }
            }
        }
//    }
}

- (void)setupTapRecognizer {
    
}

- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];
    [self.selectArr removeAllObjects];
    if (model.mutSelectArr && model.mutSelectArr.count > 0) {
        [self.selectArr addObjectsFromArray:model.mutSelectArr];
    }
    self.tipLab.attributedText = model.contentAttr;
    [self.tipLab sizeToFit];
    CGFloat heig = self.tipLab.frame.size.height;
    [self.tipLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(heig).priority(999);
    }];
    self.bubblesBgView.backgroundColor = [UIColor clearColor];
    [self.collectView reloadData];

    if (model.type == ChatMessageRev) {
        if (QMThemeManager.shared.leftMsgTextColor.hasBeenSetColor) {
            UIColor *color = QMThemeManager.shared.leftMsgTextColor.color;
            self.tipLab.textColor = color;
        }
        if (QMThemeManager.shared.leftMsgBgColor.hasBeenSetColor) {
            UIColor *bgColor = QMThemeManager.shared.leftMsgBgColor.color;
            self.containerView.backgroundColor = bgColor;
        }
    } else {
        if (QMThemeManager.shared.rightMsgTextColor.hasBeenSetColor) {
            UIColor *color = QMThemeManager.shared.rightMsgTextColor.color;
            self.tipLab.textColor = color;
        }
        if (QMThemeManager.shared.rightMsgBgColor.hasBeenSetColor) {
            UIColor *bgColor = QMThemeManager.shared.rightMsgBgColor.color;
            self.containerView.backgroundColor = bgColor;
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
        lab.font = k_Chat_Font;
        lab.textColor = k_QMRGB(21, 21, 21);
        lab.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.width.mas_equalTo(30);
            make.centerY.equalTo(cell.contentView);
        }];
        
    }
    
    NSDictionary *dict = self.message.flowList[indexPath.row];
    NSString *title = dict[@"button"];
    lab.text = title;
    [lab sizeToFit];
    CGFloat width = lab.frame.size.width;
    [lab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width + 10);
    }];
    cell.layer.cornerRadius = 15;
    cell.layer.borderWidth = 1;
    
    if ([self.selectArr containsObject:indexPath]) {
        UIColor *color =  k_QMRGB(0, 129, 255);
        if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
            color = QMThemeManager.shared.mainColorModel.color;
        }
        cell.layer.borderColor = color.CGColor;
        lab.textColor = color;
    } else {
        cell.layer.borderColor = k_QMRGB(235, 235, 235).CGColor;
        lab.textColor = k_QMRGB(59, 59, 59);
    }
    
    if (QMThemeManager.shared.leftMsgTextColor.hasBeenSetColor) {
        UIColor *color = QMThemeManager.shared.leftMsgTextColor.color;
        lab.textColor = color;
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.message.cannotSelectMessage) {
        return;
    }
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *lab = (UILabel *)[cell viewWithTag:120];


    if (![self.selectArr containsObject:indexPath]) {
        UIColor *color =  k_QMRGB(0, 129, 255);
        if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
            color = QMThemeManager.shared.mainColorModel.color;
        }
        [self.selectArr addObject:indexPath];
        cell.layer.borderColor = color.CGColor;
        lab.textColor = color;
    } else {
        [self.selectArr removeObject:indexPath];
        cell.layer.borderColor = k_QMRGB(235, 235, 235).CGColor;
        lab.textColor = k_QMRGB(59, 59, 59);
    }
    
}

- (void)sureAction:(UIButton *)sender {
    if (self.message.cannotSelectMessage) {
        return;
    }
    if (self.sendText) {
        if (self.selectArr.count > 0) {
            NSMutableString *string = [NSMutableString string];
            for (NSIndexPath *indexPath in self.selectArr) {
                NSDictionary *dict = self.message.flowList[indexPath.row];
                NSString *str = dict[@"text"];
                
                if (string.length == 0) {
                    [string appendFormat:@"【%@】", str];
                } else {
                    [string appendFormat:@"、【%@】", str];
                }
            }
            
            if (string.length > 0) {
                self.sendText(string);
                //            [self.selectArr removeAllObjects];
                self.message.cannotSelectMessage = YES;
                self.message.mutSelectArr = self.selectArr.copy;
                if (self.upCellConstraint) {
                    self.upCellConstraint(self.message);
                }
            }
        }
    }
}

//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//
//    [self.selectArr removeObject:indexPath];
//    cell.layer.borderColor = k_QMRGB(235, 235, 235).CGColor;
//
//}


- (QMChatTextView *)tipLab {
    if (!_tipLab) {
        _tipLab = [QMChatTextView new];
        _tipLab.font = [UIFont fontWithName:QM_PingFangSC_Med size:16];
        _tipLab.textColor = k_QMRGB(21, 21, 21);
        _tipLab.backgroundColor = [UIColor clearColor];
        _tipLab.layer.cornerRadius = 10;
        _tipLab.clipsToBounds = YES;
//        _tipLab.contentInset = UIEdgeInsetsMake(15, 8, 8, 6);
    }
    return _tipLab;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.layer.cornerRadius = 10;
        _containerView.clipsToBounds = YES;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}


- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *titile0 = @"确定".toLocalized;
        NSString *titile1 = @"(可多选)".toLocalized;
        NSString *title = [NSString stringWithFormat:@"%@%@",titile0,titile1];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
        NSRange rag0 = [title rangeOfString:titile0];
        [attr addAttributes:@{NSFontAttributeName: [UIFont fontWithName:QM_PingFangSC_Reg size:13], NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(0, title.length)];
        [attr addAttributes:@{NSFontAttributeName: [UIFont fontWithName:QM_PingFangSC_Med size:13]} range:rag0];
        [_sureButton setAttributedTitle:attr forState:UIControlStateNormal];
 
        [_sureButton setTitle:@"确定(可多选)" forState:UIControlStateNormal];

        [_sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        UIColor *bgColor = k_QMRGB(0, 132, 255);
        if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
            bgColor = QMThemeManager.shared.mainColorModel.color;
        }
        [_sureButton setBackgroundImage:[UIImage imageFromColor:bgColor] forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = 17.5;
        _sureButton.clipsToBounds = YES;
    }
    return _sureButton;
}

- (UICollectionView *)collectView {
    if (!_collectView) {
        UICollectionViewFlowLayout *flowlayout = [UICollectionViewFlowLayout new];
        flowlayout.estimatedItemSize = CGSizeMake(80, 30);
        flowlayout.sectionInset = UIEdgeInsetsMake(10, 15, 15, 15);
        flowlayout.minimumInteritemSpacing = 10;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowlayout];
//        collectionView.backgroundColor = k_QMRGB(245, 245, 245);
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell_id"];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        UIColor *bgColor = UIColor.whiteColor;
        if (QMThemeManager.shared.leftMsgBgColor.hasBeenSetColor) {
            bgColor = QMThemeManager.shared.leftMsgBgColor.color;
        }

        collectionView.backgroundColor = bgColor;
        collectionView.showsVerticalScrollIndicator = NO;
//        collectionView.allowsMultipleSelection = YES;
        _collectView = collectionView;
        _collectView.layer.cornerRadius = 10;
        
        SEL sel = NSSelectorFromString(@"_setRowAlignmentsOptions:");

        if ([_collectView.collectionViewLayout respondsToSelector:sel]) {
            ((void(*)(id,SEL,NSDictionary*))objc_msgSend)(_collectView.collectionViewLayout,sel,@{
                @"UIFlowLayoutCommonRowHorizontalAlignmentKey":@(NSTextAlignmentLeft),
                @"UIFlowLayoutLastRowHorizontalAlignmentKey" : @(NSTextAlignmentLeft),
                @"UIFlowLayoutRowVerticalAlignmentKey" : @(NSTextAlignmentCenter)});
            
        }
        
    }
    return _collectView;
}

- (NSMutableArray *)selectArr {
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
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
