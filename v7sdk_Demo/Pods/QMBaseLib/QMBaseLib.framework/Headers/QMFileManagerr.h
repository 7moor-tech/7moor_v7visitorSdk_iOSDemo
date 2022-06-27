//
//  QMFileManager.h
//  QMLineSDK
//
//  Created by haochongfeng on 2018/12/11.
//  Copyright © 2018年 haochongfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMFileManagerr : NSObject

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *accessId;
@property (nonatomic, copy) NSString *visitorId;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *baseUrl;
/**
 是否动态获取tcp地址，默认true
 */
@property (nonatomic, assign) BOOL isDynamicConnection;
/**
 自建http地址
 */
@property (nonatomic, copy) NSString *oemHttp;
/**
 是否更改七牛服务
 */
@property (nonatomic, assign) BOOL isQINiuServer;
/**
 七牛zone 上传地址
 */
@property (nonatomic, copy) NSString *qiNiuZoneServer;

+ (instancetype)sharedInstance;

+ (NSString *)pathOfDocument;

- (void)createFileWith:(NSString *)fileName;

- (void)writeDataToFile:(NSString *)content;

/**空字符串转换*/
+ (NSString *)returnNullString:(NSString *)string;
/**获取当前时间戳*/
+ (NSString *)getCurrentTimeStamp;

@end

NS_ASSUME_NONNULL_END
