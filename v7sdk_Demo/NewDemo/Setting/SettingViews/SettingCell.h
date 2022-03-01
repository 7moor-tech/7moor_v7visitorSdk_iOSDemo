//
//  SettingCell.h
//  NewDemo
//
//  Created by ZCZ on 2021/3/16.
//

#import <UIKit/UIKit.h>
#import "QMUIItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface SettingCell : UITableViewCell
@property (nonatomic, strong) QMUIItem *model;
@property (nonatomic, copy) void(^selectOn)(BOOL, SettMode);

@end

NS_ASSUME_NONNULL_END
