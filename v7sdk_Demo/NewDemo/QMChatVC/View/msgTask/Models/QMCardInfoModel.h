//
//  QMCardInfoModel.h
//  IMSDK-OC
//
//  Created by zcz on 2019/12/24.
//  Copyright © 2019 HCF. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AttrModel : NSObject
@property(nonatomic, copy) NSString *color;
@property(nonatomic, copy) NSString *content;

@end

@interface QMCardParams : NSObject
@property(nonatomic, copy) NSString *orderNo;

@end

@interface QMCardInfoModel : NSObject
@property(nonatomic, copy) NSString *img;
@property(nonatomic, copy) NSString *item_type;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *target;
@property(nonatomic, copy) NSString *title;

@property(nonatomic, strong) AttrModel *attr_one;
@property(nonatomic, strong) AttrModel *attr_two;

@property(nonatomic, copy) NSString *other_title_one;
@property(nonatomic, copy) NSString *other_title_two;
@property(nonatomic, copy) NSString *other_title_three;

@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *sub_title;

@property(nonatomic, strong) QMCardParams *params;

@end



NS_ASSUME_NONNULL_END
