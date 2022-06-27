//
//  QMFileUploadManager.h
//  QMBaseLib
//
//  Created by 焦林生 on 2022/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMFileUploadManager : NSObject

+ (instancetype)sharedInstance;

/// 发送文件到七牛
///  filePath 访问的URL地址
///  localFilePath 文件本地路径
///  token
- (void)sendFileToQiniu:(NSString *)fileUrl localFilePath:(NSString *)localFilePath token:(NSString *)token progress: (void (^)(float progress))progress completion:(void (^)(NSString *url))completion failure:(void (^)(NSString *reason))failure;

@end

NS_ASSUME_NONNULL_END
