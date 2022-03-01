//
//  QMChatQuickMenuCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/9/9.
//

#import "QMChatQuickMenuCell.h"

@interface QMChatQuickMenuCell() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *listCards;


@end

@implementation QMChatQuickMenuCell

- (void)setupSubviews {
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.collectionView];

    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).priority(999);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(110).priority(999);
        make.bottom.equalTo(self.contentView).priority(999);
    }];
    
}

- (void)setCellData:(QMChatMessage *)model {
    self.listCards = model.quickMenu;
    [self.collectionView reloadData];

}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 12;
        layout.estimatedItemSize = CGSizeMake(75, 90);
        layout.sectionInset = UIEdgeInsetsMake(10, 12, 10, 12);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:QMChatQuickMenuSubCell.class forCellWithReuseIdentifier:NSStringFromClass(QMChatQuickMenuSubCell.class)];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listCards.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMChatQuickMenuSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QMChatQuickMenuSubCell.class) forIndexPath:indexPath];
    cell.configureDic = self.listCards[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    NSDictionary *itemDic = self.listCards[indexPath.row];
    NSNumber *typeNum = itemDic[@"button_type"];
    NSString *content = itemDic[@"content"];
    if ([typeNum intValue] == 2) {
        if (self.pushWebView) {
            self.pushWebView([NSURL URLWithString:content ?: @""]);
        }
    }else {
        if (self.sendText) {
            self.sendText(content);
        }
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

@end


@interface QMChatQuickMenuSubCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation QMChatQuickMenuSubCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.titleLabel];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.centerX.equalTo(self.contentView);
            make.width.height.mas_equalTo(37);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(12);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(12);
            make.width.mas_greaterThanOrEqualTo(60);
            make.width.mas_lessThanOrEqualTo(110);
            make.bottom.equalTo(self.contentView).offset(-14);
        }];
    }
    return self;
}

- (void)setConfigureDic:(NSDictionary *)configureDic {
    NSString *imgStr = [configureDic objectForKey:@"icon"];
    NSString *showName = [configureDic objectForKey:@"name"];
    NSString *bgColor = [configureDic objectForKey:@"bgColor"];

    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"chat_image_placeholder"]];
    
    if (showName.length) {
        self.titleLabel.text = showName;
    }
    bgColor = bgColor.length ? bgColor : @"#FFFFFF";
    self.backgroundColor = [UIColor colorWithHexString:bgColor];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:QMColor_151515_text];
        _titleLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
