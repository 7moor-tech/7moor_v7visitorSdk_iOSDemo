//
//  QMChatMoreView.m
//  newDemo
//
//  Created by lishuijiao on 2021/2/24.
//

#import "QMChatMoreView.h"

#define moreBtnWidht 60

@interface QMChatMoreView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *rootView;
@property (nonatomic, strong) NSMutableArray <QMChatMoreModel *>*dataArray;
@end

@implementation QMChatMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self layoutViews];
    }
    return self;
}

- (QMChatMoreModel *)getChatMoreItem:(QMChatMoreMode)mode {
    QMChatMoreModel *model = [QMChatMoreModel new];
    model.mode = mode;
    
    switch (mode) {
        case QMChatMoreModePicture:
            model.image_name = @"QM_ToolBar_Picture";
            model.name = @"图库".toLocalized;
            break;
        case QMChatMoreModeCamera:
            model.image_name = @"qm_chatCamera";
            model.name = @"拍摄".toLocalized;
            break;
        case QMChatMoreModeFile:
            model.image_name = @"QM_ToolBar_File";
            model.name = @"文件".toLocalized;
            break;
        case QMChatMoreModeQuestion:
            model.image_name = @"QM_ToolBar_Question";
            model.name = @"常见问题".toLocalized;
            break;
        case QMChatMoreModeEvaluate:
            model.image_name = @"QM_ToolBar_Evaluate";
            model.name = @"评价".toLocalized;
            break;
        case QMChatMoreModeVideo:
            model.image_name = @"QM_ToolBar_Video";
            model.name = @"视频".toLocalized;
            break;
        case QMChatMoreModeCard:
            model.image_name = @"QM_ToolBar_OrderCard";
            model.name = @"发送订单".toLocalized;
            break;
        case QMChatMoreModeBlacklist:
            model.name = self.blackListContent;
            model.image_name = @"QM_ToolBar_blacklist";

        default:
            break;
    }
    return model;
}

- (void)setBlackListContent:(NSString *)blackListContent {
    _blackListContent = blackListContent;
    [self setShowBlackListItem:blackListContent];
}

- (void)setShowBlackListItem:(NSString *)name {
    if (name.length > 0) {
        QMChatMoreModel *model = [self getChatMoreItem:QMChatMoreModeBlacklist];
        [self.dataArray addObject:model];
    } else {
        for (QMChatMoreModel *model in self.dataArray) {
            if (model.mode == QMChatMoreModeBlacklist) {
                [self.dataArray removeObject:model];
                break;
            }
        }
    }
    
    [self.rootView reloadData];
}

- (void)layoutViews {

    self.dataArray = [NSMutableArray array];

    QMThemeManager *uiModel = QMThemeManager.shared;
    
    if (uiModel.isHiddenCardBtn == NO) {
        QMChatMoreModel *pictModel = [self getChatMoreItem:QMChatMoreModeCard];
        [self.dataArray addObject:pictModel];
    }

    if (uiModel.isHiddenCameraBtn == NO) {
        QMChatMoreModel *pictModel = [self getChatMoreItem:QMChatMoreModeCamera];
        [self.dataArray addObject:pictModel];
    }
    
    if (uiModel.isHiddenPictureBtn == NO) {
        QMChatMoreModel *pictModel = [self getChatMoreItem:QMChatMoreModePicture];
        [self.dataArray addObject:pictModel];
    }
    
    if (uiModel.isHiddenFileBtn == NO) {
        QMChatMoreModel *pictModel = [self getChatMoreItem:QMChatMoreModeFile];
        [self.dataArray addObject:pictModel];
    }
    
    if (uiModel.isHiddenEvaluateBtn == NO) {
        QMChatMoreModel *pictModel = [self getChatMoreItem:QMChatMoreModeEvaluate];
        [self.dataArray addObject:pictModel];
    }
    
    if (self.blackListContent.length > 0) {
        QMChatMoreModel *pictModel = [self getChatMoreItem:QMChatMoreModeBlacklist];
        [self.dataArray addObject:pictModel];
    }
    
//    if (uiModel.isHiddenQuestionBtn == NO) {
//        QMChatMoreModel *pictModel = [self getChatMoreItem:QMChatMoreModeQuestion];
//        [self.dataArray addObject:pictModel];
//    }
//     
//    if (uiModel.isHiddenVideoBtn == NO) {
//        QMChatMoreModel *pictModel = [self getChatMoreItem:QMChatMoreModeVideo];
//        [self.dataArray addObject:pictModel];
//    }
            
    UICollectionViewFlowLayout *flowlayout = [UICollectionViewFlowLayout new];
    flowlayout.itemSize = CGSizeMake(60, 60 + 12 + 12);
    flowlayout.sectionInset = UIEdgeInsetsMake(15, 30*kScale6, 15, 30*kScale6);
    flowlayout.minimumLineSpacing = 14;
    flowlayout.minimumInteritemSpacing = 24;
    self.rootView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowlayout];
    self.rootView.backgroundColor = k_QMRGB(246, 246, 246);
    [self.rootView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell_id"];
    self.rootView.dataSource = self;
    self.rootView.delegate = self;
    [self addSubview:self.rootView];

}

- (void)refreshMoreBtn {
    [self layoutViews];
    [self.rootView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_id" forIndexPath:indexPath];
    UILabel *lab = (UILabel *)[cell.contentView viewWithTag:200];
    UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:199];
    if (!image) {
        image = [UIImageView new];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.tag = 199;
        [cell.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.height.width.mas_equalTo(60);
            make.centerX.equalTo(cell.contentView);
        }];
    }
    
    if (!lab) {
        lab = [UILabel new];
        lab.tag = 200;
        lab.textColor = k_QMRGB(109, 109, 109);
        lab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
        lab.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(cell.contentView);
            make.top.equalTo(image.mas_bottom).offset(10);
        }];
    }
    
    QMChatMoreModel *model = self.dataArray[indexPath.row];
    
    lab.text = model.name;
    image.image = [UIImage imageNamed:model.image_name];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    QMChatMoreModel *model = self.dataArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(moreViewSelectAcitonIndex:)]) {
        [self.delegate moreViewSelectAcitonIndex:model.mode];
    }
}


@end

@implementation QMChatMoreModel



@end
