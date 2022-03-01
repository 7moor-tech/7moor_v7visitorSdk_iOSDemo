//
//  SetColorFooter.m
//  NewDemo
//
//  Created by ZCZ on 2021/3/17.
//

#import "SetColorFooter.h"
#import "ColorCell.h"
#import "UIImage+Color.h"
@interface SetColorFooter () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *rootView;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) NSIndexPath *selectIndex;

@end

@implementation SetColorFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.rootView];
    [self addSubview:self.sureBtn];
    self.backgroundColor = UIColor.whiteColor;
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self).priorityHigh();
        make.height.mas_equalTo(1).priorityHigh();
    }];
    
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(1).priorityHigh();
        make.height.mas_equalTo(80).priorityHigh();
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-20).priorityHigh();
        make.height.mas_equalTo(40).priorityHigh();
        make.width.mas_equalTo(80);
        make.top.equalTo(self.rootView.mas_bottom).offset(10).priorityHigh();
    }];
}

- (void)refeashColorData {
    if (self.datas.count > 10) {
        self.selectIndex = [NSIndexPath indexPathForRow:6 inSection:0];
    } else if (self.datas > 0) {
        self.selectIndex = [NSIndexPath indexPathForRow:4 inSection:0];
    }
    [self.rootView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ColorCell.class) forIndexPath:indexPath];
    
    NSString *color = self.datas[indexPath.row];
    QMColorModel *model = [QMColorModel new];
    model.hexColor = color;
    [cell setCellData:model.color];
    if (indexPath.row == self.selectIndex.row) {
        cell.selected = YES;
    } else {
        cell.selected = NO;
    }
    cell.layer.cornerRadius = 30;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *lastCell = [collectionView cellForItemAtIndexPath:self.selectIndex];
    lastCell.selected = NO;
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = !cell.selected;
    self.selectIndex = indexPath;
}

- (void)selectAcion {
    NSString *color = self.datas[self.selectIndex.row];
    QMColorModel *model = [QMColorModel new];
    model.hexColor = color;
    self.SelectedItem(model.color);
}

- (UICollectionView *)rootView {
    if (!_rootView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flow.minimumLineSpacing = 15;

        flow.itemSize = CGSizeMake(60, 60);
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _rootView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 80) collectionViewLayout:flow];
        [_rootView registerClass:ColorCell.class forCellWithReuseIdentifier:NSStringFromClass(ColorCell.class)];
        _rootView.dataSource = self;
        _rootView.delegate = self;
        _rootView.backgroundColor = UIColor.whiteColor;
        _rootView.showsVerticalScrollIndicator = NO;
        _rootView.showsHorizontalScrollIndicator = NO;
    }
    
    return _rootView;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:[UIImage imageFromColor:k_QMRGB(119, 136, 153)] forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 6;
        _sureBtn.clipsToBounds = YES;
        [_sureBtn addTarget:self action:@selector(selectAcion) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


@end
