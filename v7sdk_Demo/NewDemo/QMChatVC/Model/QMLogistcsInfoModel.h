//
//  QMLogistcsInfoModel.h
//  IMSDK-OC
//
//  Created by zcz on 2019/12/25.
//  Copyright © 2019 HCF. All rights reserved.
//

//#import "JSONModel.h"
#import <Foundation/Foundation.h>

#import "YYModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QMLogistcsInfoModel : NSObject
@property(nonatomic, copy) NSString *list_title;
@property(nonatomic, copy) NSString *empty_message;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, copy) NSString *list_num;
@property(nonatomic, strong) NSArray *list;
@property(nonatomic, copy) NSString *resp_type;

@end


@interface QMLogistcsInfo : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *is_current;
@property(nonatomic, copy) NSString *desc;

@end

NS_ASSUME_NONNULL_END
