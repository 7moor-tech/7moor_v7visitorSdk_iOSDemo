//
//  QMLogModel.m
//  IMSDK-OC
//
//  Created by zcz on 2019/12/25.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMLogistcsInfoModel.h"

@implementation QMLogistcsInfoModel

//+ (JSONKeyMapper *)keyMapper {
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"list":@"item_list"}];
//}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"list":@"item_list"};
}
@end

@implementation QMLogistcsInfo



@end
