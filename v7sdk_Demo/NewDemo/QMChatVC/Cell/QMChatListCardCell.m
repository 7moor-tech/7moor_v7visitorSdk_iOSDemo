//
//  QMChatListCardCell.m
//  NewDemo
//
//  Created by lishuijiao on 2021/6/22.
//

#import "QMChatListCardCell.h"

@interface QMChatListCardCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *listCards;

@end

@implementation QMChatListCardCell

- (void)setupSubviews {
    [super setupSubviews];
    
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.collectionView];

    self.collectionView.backgroundColor = UIColor.clearColor;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).priority(999);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(110).priority(999);
        make.bottom.equalTo(self.contentView).priority(999);
    }];

}

- (void)setCellData:(QMChatMessage *)model {
    self.listCards = model.listCards;
    [self.collectionView reloadData];
}

- (NSArray *)listCards {
    if (!_listCards) {
        _listCards = [[NSArray alloc] init];
    }
    return _listCards;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 10;
        layout.estimatedItemSize = CGSizeMake(75, 90);
        layout.sectionInset = UIEdgeInsetsMake(10, 8, 10, 8);
            
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:QMChatListCardCollectionCell.class forCellWithReuseIdentifier:NSStringFromClass(QMChatListCardCollectionCell.class)];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listCards.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMChatListCardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QMChatListCardCollectionCell.class) forIndexPath:indexPath];
    
    cell.configureDic = self.listCards[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *itemDic = self.listCards[indexPath.row];
    if (self.selectItem) {
        self.selectItem(itemDic[@"clickText"]);
    }
}

@end


@interface QMChatListCardCollectionCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation QMChatListCardCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.textLabel];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
//            make.left.equalTo(self.contentView).offset(19);
//            make.right.equalTo(self.contentView).offset(-19);
            make.centerX.equalTo(self.contentView);
            make.width.height.mas_equalTo(37);
        }];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    NSString *imgStr = [configureDic objectForKey:@"imgUrl"];
    NSString *showName = [configureDic objectForKey:@"showName"];
    NSString *bgColor = [configureDic objectForKey:@"bgColor"];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"chat_image_placeholder"]];
    
    if (showName.length) {
        self.textLabel.text = showName;
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

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor colorWithHexString:QMColor_151515_text];
        _textLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@end


