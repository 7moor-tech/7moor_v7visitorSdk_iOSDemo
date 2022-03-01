//
//  QMHorizontalPageFlowLayout.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/21.
//

#import "QMHorizontalPageFlowLayout.h"

@implementation QMHorizontalPageFlowLayout

- (void)setRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow {
    self.rowCount = rowCount;
    self.itemCountPerRow = itemCountPerRow;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self.attributesArray removeAllObjects];
    NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < itemTotalCount; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize {
//    CGFloat itemWidth = (self.collectionView.frame.size.width - self.sectionInset.left - self.itemCountPerRow * self.minimumInteritemSpacing) / self.itemCountPerRow;
    NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger itemCount = self.rowCount * self.itemCountPerRow;
    NSInteger remainder = itemTotalCount%itemCount;
    NSInteger pageNumber = itemTotalCount/itemCount;
    
    if (itemTotalCount <= itemCount) {
        pageNumber = 1;
    } else {
        if (remainder == 0) {
            pageNumber = pageNumber;
        } else {
            pageNumber = pageNumber + 1;
        }
    }
    
    CGFloat width = 0;
//    CGFloat spaceX = (self.itemCountPerRow - 1) + 0.5;
    width = self.collectionView.frame.size.width * pageNumber;
    return CGSizeMake(width, 0);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat spaceX = (self.itemCountPerRow - 1) + 0.5;
    CGFloat itemWidth = (self.collectionView.frame.size.width - self.sectionInset.left - spaceX * self.minimumInteritemSpacing)/self.itemCountPerRow;
//    CGFloat itemWidth = self.itemSize.width;
    CGFloat itemHeight = self.itemSize.height;
    if (itemHeight == 0 || itemHeight == NSNotFound) {
        itemHeight = (self.collectionView.frame.size.height - self.sectionInset.top - self.sectionInset.bottom - (self.rowCount - 1) * self.minimumLineSpacing) / self.rowCount;
        
    }
    NSInteger item = indexPath.item;

    NSInteger pageNumber = ceilf(item / (self.rowCount * self.itemCountPerRow));
    NSInteger x = item % self.itemCountPerRow + pageNumber * self.itemCountPerRow;
    NSInteger y = item / self.itemCountPerRow - pageNumber * self.rowCount;
//
    CGFloat itemX = self.sectionInset.left + (itemWidth + self.minimumInteritemSpacing) * x;
    CGFloat itemY = self.sectionInset.top + (itemHeight + self.minimumLineSpacing) * y;

    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    return attributes;
}


-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray* attributes = [NSMutableArray array];
    for(NSInteger i = 0 ; i < self.collectionView.numberOfSections; i++) {
        for (NSInteger j=0 ; j < [self.collectionView numberOfItemsInSection:i]; j++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}




- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

@end
