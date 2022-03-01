//
//  SetColorFooter.h
//  NewDemo
//
//  Created by ZCZ on 2021/3/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetColorFooter : UICollectionReusableView
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, copy) void(^SelectedItem)(UIColor *);

- (void)refeashColorData;


@end

NS_ASSUME_NONNULL_END
