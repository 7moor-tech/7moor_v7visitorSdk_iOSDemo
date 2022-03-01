//
//  QMUIItem.h
//  NewDemo
//
//  Created by ZCZ on 2021/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSInteger {
    SettModeNav = 0, //导航栏颜色
    SettModeCustomer, //转人工按钮颜色
    SettModeLogout, // 注销返回颜色
    SettModeVoice, // 语音按钮
    SettModeEmj, // 表情按钮
    SettModeExtend, // 扩展按钮
    SettModePic, // 发送图片按钮
    SettModeVideo, // 发起视频按钮
    SettModeFile, // 发送文件按钮
    SettModeQuestion, // 常见问题按钮
    SettModeEvaluate // 评价按钮
} SettMode;

@interface QMUIItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, strong) QMColorModel *color;
@property (nonatomic, assign) SettMode mode;


@end

NS_ASSUME_NONNULL_END
