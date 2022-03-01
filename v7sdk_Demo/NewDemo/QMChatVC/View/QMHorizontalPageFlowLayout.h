//
//  QMHorizontalPageFlowLayout.h
//  NewDemo
//
//  Created by ZCZ on 2021/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMHorizontalPageFlowLayout : UICollectionViewFlowLayout

/**多少行*/
@property (nonatomic, assign) NSInteger rowCount;
/**每一行展示多少个item*/
@property (nonatomic, assign) NSInteger itemCountPerRow;
/**所有item的属性数组*/
@property (nonatomic, strong) NSMutableArray *attributesArray;

- (void)setRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow;

@end

NS_ASSUME_NONNULL_END
