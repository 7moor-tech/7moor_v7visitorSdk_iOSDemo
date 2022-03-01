//
//  QMChatSelectCell.m
//  NewDemo
//
//  Created by ZCZ on 2021/5/28.
//

#import "QMChatXBobtSelectButtonRowCell.h"
#import "QMHorizontalPageFlowLayout.h"
@interface QMChatXBobtSelectButtonRowCell () <UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) BOOL isSingleRow;

@end

@implementation QMChatXBobtSelectButtonRowCell

- (void)setupSubviews {
    [super setupSubviews];
    self.isSingleRow = NO;
    [self.bubblesBgView addSubview:self.titleLab];
    [self.bubblesBgView addSubview:self.rootView];
    
    self.titleLab.text = @"请选择旅游方式：".toLocalized;
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubblesBgView).offset(15);
        make.right.equalTo(self.bubblesBgView).offset(-10);
        make.top.equalTo(self.bubblesBgView).offset(15).priority(999);
    }];
    
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bubblesBgView);
        make.top.equalTo(self.titleLab.mas_bottom).offset(15).priority(999);
//        make.bottom.equalTo(self.bubblesBgView).offset(-25).priority(999);
        make.height.mas_equalTo((38 + 10)*4).priority(999);
        make.width.mas_equalTo(240*kScale6).priority(999);
    }];
    
    [self.bubblesBgView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rootView.mas_bottom);
        make.centerX.equalTo(self.rootView);
        make.height.mas_equalTo(25).priority(999);
        make.bottom.equalTo(self.bubblesBgView);
    }];

    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.rootView]) {
        return NO;
    }
    return NO;
}


- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];

    
    if ([model.flowStyle isEqualToString:@"1"]) {
        self.isSingleRow = YES;
    } else {
        self.isSingleRow = NO;
    }
    
    QMHorizontalPageFlowLayout *flow = (QMHorizontalPageFlowLayout *)self.rootView.collectionViewLayout;
    NSUInteger rowCount = 0;

    if (self.isSingleRow == YES) {
        rowCount = ceilf(model.flowList.count) > 4 ? 4 : model.flowList.count;
        if ([flow isKindOfClass:[QMHorizontalPageFlowLayout class]]) {
            [flow setRowCount:rowCount itemCountPerRow:1];
        }
    } else {
        rowCount = ceilf(model.flowList.count/2.0) > 4 ? 4 : ceilf(model.flowList.count/2.0);
        [flow setRowCount:rowCount itemCountPerRow:2];
    }
    
    CGFloat rootView_height = (36)*rowCount + (rowCount - 1)*15*kScale6;
    
    [self.rootView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(rootView_height).priority(999);
    }];
    

    self.titleLab.attributedText = model.contentAttr;
    if (self.isSingleRow) {
        self.pageControl.numberOfPages = ceilf(model.flowList.count/4.0);
    } else {
        self.pageControl.numberOfPages = ceilf(model.flowList.count/8.0);
    }
    
    CGFloat content_w = (240*kScale6) * (self.pageControl.numberOfPages+1);
    self.rootView.contentSize = CGSizeMake(content_w, rootView_height);
    
    if (self.pageControl.numberOfPages > 1) {
        self.pageControl.hidden = NO;
        [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25).priority(999);
        }];
    } else {
        self.pageControl.hidden = YES;
        [self.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15).priority(999);
        }];
    }
    
    [self.rootView reloadData];
    [self.rootView.collectionViewLayout invalidateLayout];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.message.flowList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    UILabel *label = [cell viewWithTag:200];
    if (!label) {
        label = [UILabel new];
        label.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
        label.textColor = UIColor.whiteColor;
        label.tag = 200;
        label.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.equalTo(cell).offset(-8);
            make.top.equalTo(cell).offset(10).priority(999);
            make.bottom.equalTo(cell).offset(-10).priority(999);
            make.center.equalTo(cell).priority(999);
            make.height.mas_equalTo(16).priority(999);
        }];
    }
    NSDictionary *dict = self.message.flowList[indexPath.row];
    NSString *button = dict[@"button"];
    label.text = button;
    if (self.isSingleRow == false) {
        cell.layer.cornerRadius = 18;
    }
    if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
        cell.backgroundColor = QMThemeManager.shared.mainColorModel.color;
    } else {
        cell.backgroundColor = k_QMRGB(0, 129, 255);
    }
    return cell;
}

- (void)setupTapRecognizer {
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.message.flowList[indexPath.row];
    NSString *recogType = dict[@"recogType"];
    if ([recogType isKindOfClass:[NSString class]] && [recogType isEqualToString:@"4"]) {
        // 自定义事件
    } else {
        if (self.sendText) {
            NSString *text = dict[@"text"];
            self.sendText(text);
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

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {

    CGPoint offset = aScrollView.contentOffset;
    int count = ceilf(offset.x/aScrollView.bounds.size.width);
    self.pageControl.currentPage = count;
}

//- (void)pageChangeAction:(UIPageControl *)control {
//    NSInteger index = control.currentPage;
//    CGPoint point = CGPointMake(self.rootView.bounds.size.width * index, 0);
//
//    [self.rootView setContentOffset:point animated:YES];
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return self.isSingleRow ? CGSizeMake(200*kScale6, 36) : CGSizeMake(100*kScale6, 36);
//}


- (UICollectionView *)rootView {
    if (!_rootView) {
        QMHorizontalPageFlowLayout *flow = [[QMHorizontalPageFlowLayout alloc] init];
        [flow setRowCount:4 itemCountPerRow:2];
        flow.sectionInset = UIEdgeInsetsMake(0, 12.5*kScale6, 0, 12.5*kScale6);
        flow.minimumLineSpacing = 15*kScale6;
        flow.minimumInteritemSpacing = 25*kScale6;
//        flow.itemSize = CGSizeMake(110*kScale6, 36);
        flow.itemSize = self.isSingleRow ? CGSizeMake(215*kScale6, 36) : CGSizeMake(95*kScale6, 36);
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _rootView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _rootView.showsHorizontalScrollIndicator = NO;
        _rootView.dataSource = self;
        _rootView.delegate = self;
        _rootView.pagingEnabled = YES;
        _rootView.backgroundColor = UIColor.clearColor;
        [_rootView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
//        SEL sel = NSSelectorFromString(@"_setRowAlignmentsOptions:");
//        if ([_rootView.collectionViewLayout respondsToSelector:sel]) {
//            ((void(*)(id,SEL,NSDictionary*))objc_msgSend)(_rootView.collectionViewLayout,sel,@{
//                @"UIFlowLayoutCommonRowHorizontalAlignmentKey":@(NSTextAlignmentLeft),
//                @"UIFlowLayoutLastRowHorizontalAlignmentKey" : @(NSTextAlignmentRight),
//                @"UIFlowLayoutRowVerticalAlignmentKey" : @(NSTextAlignmentCenter)});
//
//        }
    
    }
    
    return _rootView;
}



- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont fontWithName:QM_PingFangSC_Med size:16];
        _titleLab.textColor = k_QMRGB(21, 21, 21);
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.currentPageIndicatorTintColor = k_QMRGB(0, 125, 255);
        _pageControl.pageIndicatorTintColor = k_QMRGB(220, 220, 220);
        _pageControl.userInteractionEnabled = false;
//        [_pageControl addTarget:self action:@selector(pageChangeAction:) forControlEvents:UIControlEventValueChanged];
        _pageControl.backgroundColor = UIColor.clearColor;
        if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
            _pageControl.currentPageIndicatorTintColor = QMThemeManager.shared.mainColorModel.color;
        }
        _pageControl.numberOfPages = 3;
    }
    return _pageControl;
}

@end
