//
//  QMChatShowFileViewController.h
//  IMSDK
//
//  Created by lishuijiao on 2020/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMChatShowFileViewController : UIViewController

@property (nonatomic, copy)NSString *filePath;

//用于机器人表单消息附件展示
@property (nonatomic, assign)BOOL isForm;

@end

NS_ASSUME_NONNULL_END
