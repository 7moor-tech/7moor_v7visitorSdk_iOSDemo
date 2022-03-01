//
//  QMClientModel.h
//  moorV7SDK
//
//  Created by lishuijiao on 2021/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMClientModel : NSObject

@property (nonatomic, copy) NSString *accessId;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *account;

@property (nonatomic, copy) NSString *visitorHeadImg;


- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
