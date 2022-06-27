//
//  QMZhugeManager.h
//  Pods
//
//  Created by ZCZ on 2022/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMZhugeManager : NSObject
+ (instancetype)shared;

+ (void)registerAccessid:(NSString *)accessId userId:(NSString *)userId userName:(NSString *)userName version:(NSString *)version sid:(NSString *)sid;
+ (void)trackEvent:(NSString *)eventName;
+ (void)trackNetWorking:(NSMutableDictionary *)event;
// 真正sid回来时，修正sid
- (void)changeRealSid:(NSString *)sid;


@end

NS_ASSUME_NONNULL_END
