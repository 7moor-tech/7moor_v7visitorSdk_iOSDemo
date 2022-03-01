//
//  SetColorView.m
//  NewDemo
//
//  Created by ZCZ on 2021/3/16.
//

#import "SetColorView.h"
#import "SetColorFooter.h"
#import "ColorCell.h"
@interface SetColorView () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *rootView;
@property (nonatomic, strong) SetColorFooter *footerView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSIndexPath *selectIndex;
@property (nonatomic, strong) QMColorModel *colorModel;


@end

@implementation SetColorView

+ (instancetype)defuatView {
    SetColorView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:2121];
    if (!view) {
        view = [[SetColorView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        view.tag = 2121;
    }
    return view;
}

- (void)showColorView:(void (^)(UIColor * _Nonnull))competion {
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    
    UIView *bgView = [self viewWithTag:999];
    if (!bgView) {
        bgView= [UIView new];
        bgView.tag = 999;
        bgView.layer.cornerRadius = 6;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(100);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.mas_greaterThanOrEqualTo(580);
        }];
        
        [bgView addSubview:self.rootView];
        [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.equalTo(bgView);
            make.height.mas_equalTo(50 + 20 + 30 + 5*60 + 40).priorityHigh();
        }];
        
        [bgView addSubview:self.footerView];
        
        [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rootView.mas_bottom);
            make.left.right.equalTo(bgView);
            make.height.mas_equalTo(130).priorityHigh();
            make.bottom.equalTo(bgView);
        }];
        
    }
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    __weak typeof(self)wSelf = self;
    self.footerView.SelectedItem = ^(UIColor * color) {
        [wSelf hiddenView];
        competion(color);
    };
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell_id = @"cell_id";
    ColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
    
    QMSelectColor *model = self.dataArr[indexPath.row];
    [cell setCellData:model.color];
    cell.layer.cornerRadius = 30;
    if (indexPath.row == self.selectIndex.row) {
        cell.selected = true;
        [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    } else {
        cell.selected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *lastCell = [collectionView cellForItemAtIndexPath:self.selectIndex];
    lastCell.selected = NO;
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = !cell.selected;
    QMSelectColor *model = self.dataArr[indexPath.row];
    self.footerView.datas = model.nearColors;
    [self.footerView refeashColorData];
    self.selectIndex = indexPath;
    
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header_ic" forIndexPath:indexPath];
        UILabel *lab = (UILabel *)[header viewWithTag:110];
        if (!lab) {
            lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 25)];
            lab.textColor = UIColor.blackColor;
            lab.font = [UIFont systemFontOfSize:18];
            lab.text = @"选择颜色";
            lab.tag = 110;
            [header addSubview:lab];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(header).offset(20);
                make.centerY.equalTo(header);
            }];
        }
        
        UIView *line = (UIView *)[header viewWithTag:111];
        if (!line) {
            line = [UIView new];
            line.tag = 111;
            line.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            [header addSubview:line];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(header);
                make.height.mas_equalTo(1);
            }];
        }
        
        return header;
    } else {
        return nil;
    }

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.frame.size.width < self.frame.size.width) {
        return NO;
    }

    return YES;
}

#pragma make - getter

- (UICollectionView *)rootView {
    if (!_rootView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = CGSizeMake(60, 60);
        flow.sectionInset = UIEdgeInsetsMake(20, 30, 30, 30);
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        flow.headerReferenceSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 50);

        _rootView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _rootView.backgroundColor = [UIColor whiteColor];
        [_rootView registerClass:ColorCell.class forCellWithReuseIdentifier:@"cell_id"];
        [_rootView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header_ic"];
//        [_rootView registerClass:SetColorFooter.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer_id"];
        _rootView.dataSource = self;
        _rootView.delegate = self;
    }
    return _rootView;
}

- (SetColorFooter *)footerView {
    if (!_footerView) {
        _footerView = [SetColorFooter new];
    }
    return _footerView;
}

- (NSArray *)dataArr {
    if (_dataArr.count == 0)  {
        NSArray *arr = @[
        @{@"main":@"#7B7B7B", @"nearColors":@[@"#0A0A0AFF",@"#272727FF",@"#3C3C3CFF",@"#4F4F4FFF",@"#5B5B5BFF",@"#6C6C6CFF",@"#7B7B7BFF",@"#8E8E8EFF",@"#9D9D9DFF",@"#ADADADFF",@"#BEBEBEFF",@"#d0d0d0ff",@"#E0E0E0FF",@"#F0F0F0FF",@"#FCFCFCFF",@"#FFFFFFFF"]},
        @{@"main":@"#CE0000FF",
          @"nearColors":@[@"#2F0000",@"#4D0000",@"#600000",@"#750000",@"#930000",@"#AE0000",@"#CE0000",@"#EA0000",@"#FF0000",@"#FF2D2D",@"#FF5151",@"#ff7575",@"#FF9797",@"#FFB5B5",@"#FFD2D2",@"#FFECEC"]},
        @{@"main":@"#FF0080", @"nearColors":@[@"#600030",@"#820041",@"#9F0050",@"#BF0060",@"#D9006C",@"#F00078",@"#FF0080",@"#FF359A",@"#FF60AF",@"#FF79BC",@"#FF95CA",@"#ffaad5",@"#FFC1E0",@"#FFD9EC",@"#FFECF5",@"#FFF7FB"]},
        @{@"main":@"#E800E8", @"nearColors":@[@"#460046",@"#5E005E",@"#750075",@"#930093",@"#AE00AE",@"#D200D2",@"#E800E8",@"#FF00FF",@"#FF44FF",@"#FF77FF",@"#FF8EFF",@"#ffa6ff",@"#FFBFFF",@"#FFD0FF",@"#FFE6FF",@"#FFF7FF"]},
        @{@"main":@"#921AFF", @"nearColors":@[@"#28004D",@"#3A006F",@"#4B0091",@"#5B00AE",@"#6F00D2",@"#8600FF",@"#921AFF",@"#9F35FF",@"#B15BFF",@"#BE77FF",@"#CA8EFF",@"#d3a4ff",@"#DCB5FF",@"#E6CAFF",@"#F1E1FF",@"#FAF4FF"]},
        @{@"main":@"#4A4AFF", @"nearColors":@[@"#000079",@"#000093",@"#0000AD",@"#0000C6",@"#0000E3",@"#2828FF",@"#4A4AFF",@"#6A6AFF",@"#7D7DFF",@"#9393FF",@"#AAAAFF",@"#B9B9FF",@"#CECEFF",@"#DDDDFF",@"#ECECFF",@"#FBFBFF"]},
        @{@"main":@"#0080FF", @"nearColors":@[@"#000079",@"#003D79",@"#004B97",@"005AB5",@"#0066CC",@"#0072E3",@"#0080FF",@"#2894FF",@"#46A3FF",@"#66B3FF",@"#84C1FF",@"#97CBFF",@"#ACD6FF",@"#C4E1FF",@"#D2E9FF",@"#ECF5FF"]},
        @{@"main":@"#00E3E3", @"nearColors":@[@"#003E3E",@"#005757",@"#007979",@"#009393",@"#00AEAE",@"#00CACA",@"#00E3E3",@"#00FFFF",@"#4DFFFF",@"#80FFFF",@"#A6FFFF",@"#BBFFFF",@"#CAFFFF",@"#D9FFFF",@"#ECFFFF",@"#FDFFFF"]},
        @{@"main":@"#02F78E", @"nearColors":@[@"#006030",@"#01814A",@"#019858",@"#01B468",@"#02C874",@"#02DF82",@"#02F78E",@"#1AFD9C",@"#4EFEB3",@"#7AFEC6",@"#96FED1",@"#ADFEDC",@"#C1FFE4",@"#D7FFEE",@"#E8FFF5",@"#FBFFFD"]},
        @{@"main":@"#00EC00", @"nearColors":@[@"#006000",@"#007500",@"#009100",@"#00A600",@"#00BB00",@"#00DB00",@"#00EC00",@"#28FF28",@"#53FF53",@"#79FF79",@"#93FF93",@"#A6FFA6",@"#BBFFBB",@"#CEFFCE",@"#DFFFDF",@"#F0FFF0"]},
        @{@"main":@"#9AFF02", @"nearColors":@[@"#467500",@"#548C00",@"#64A600",@"#73BF00",@"#82D900",@"#8CEA00",@"#9AFF02",@"#A8FF24",@"#B7FF4A",@"#C2FF68",@"#CCFF80",@"#D3FF93",@"#DEFFAC",@"#E8FFC4",@"#EFFFD7",@"#F5FFE8"]},
        @{@"main":@"#E1E100", @"nearColors":@[@"#424200",@"#5B5B00",@"#737300",@"#8C8C00",@"#A6A600",@"#C4C400",@"#E1E100",@"#F9F900",@"#FFFF37",@"#FFFF6F",@"#FFFF93",@"#FFFFAA",@"#FFFFAA",@"#FFFFCE",@"#FFFFDF",@"#FFFFDF"]},
        @{@"main":@"#EAC100", @"nearColors":@[@"#5B4B00",@"#796400",@"#977C00",@"#AE8F00",@"#C6A300",@"#D9B300",@"#EAC100",@"#FFD306",@"#FFDC35",@"#FFE153",@"#FFE66F",@"#FFED97",@"#FFF0AC",@"#FFF4C1",@"#FFF8D7",@"#FFFCEC"]},
        @{@"main":@"#FF9224", @"nearColors":@[@"#844200",@"#9F5000",@"#BB5E00",@"#D26900",@"#EA7500",@"#FF8000",@"#FF9224",@"#FFA042",@"#FFAF60",@"#FFBB77",@"#FFC78E",@"#FFD1A4",@"#FFDCB9",@"#FFE4CA",@"#FFEEDD",@"#FFFAF4"]},
        @{@"main":@"#FF5809", @"nearColors":@[@"#642100",@"#842B00",@"#A23400",@"#BB3D00",@"#D94600",@"#F75000",@"#FF5809",@"#FF8040",@"#FF8040",@"#FF9D6F",@"#FFAD86",@"#FFBD9D",@"#FFCBB3",@"#FFDAC8",@"#FFE6D9",@"#FFF3EE"]},
        @{@"main":@"#B87070", @"nearColors":@[@"#613030",@"#743A3A",@"#804040",@"#984B4B",@"#AD5A5A",@"#B87070",@"#C48888",@"#CF9E9E",@"#D9B3B3",@"#E1C4C4",@"#EBD6D6",@"#F2E6E6"]},
        @{@"main":@"#AFAF61", @"nearColors":@[@"#616130",@"#707038",@"#808040",@"#949449",@"#A5A552",@"#AFAF61",@"#B9B973",@"#C2C287",@"#CDCD9A",@"#D6D6AD",@"#DEDEBE",@"#E8E8D0"]},
        @{@"main":@"#6FB7B7", @"nearColors":@[@"#336666",@"#3D7878",@"#408080",@"#4F9D9D",@"#5CADAD",@"#6FB7B7",@"#81C0C0",@"#95CACA",@"#A3D1D1",@"#B3D9D9",@"#C4E1E1",@"#D1E9E9"]},
        @{@"main":@"#9999CC", @"nearColors":@[@"#484891",@"#5151A2",@"#5A5AAD",@"#7373B9",@"#8080C0",@"#9999CC",@"#A6A6D2",@"#B8B8DC",@"#C7C7E2",@"#D8D8EB",@"#E6E6F2",@"#F3F3FA"]},
        @{@"main":@"#AE57A4", @"nearColors":@[@"#6C3365",@"#7E3D76",@"#8F4586",@"#9F4D95",@"#AE57A4",@"#B766AD",@"#C07AB8",@"#CA8EC2",@"#D2A2CC",@"#DAB1D5",@"#E2C2DE",@"#EBD3E8"]}
        ];
        NSMutableArray *addArr = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            QMSelectColor *model = [QMSelectColor new];
            model.hexColor = dict[@"main"];
            model.nearColors = dict[@"nearColors"];
            [addArr addObject:model];
        }
        _dataArr = addArr.copy;
        self.selectIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _dataArr;
}

- (void)hiddenView {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation QMSelectColor



@end
