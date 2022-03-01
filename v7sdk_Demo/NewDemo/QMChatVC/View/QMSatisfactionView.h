//
//  QMSatisfactionView.h
//  NewDemo
//
//  Created by lishuijiao on 2021/7/19.
//

#import <UIKit/UIKit.h>
#import "QMSatisfactionModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SendTanksText)(NSString *text);

@interface QMSatisfactionView : UIView

@property (nonatomic, copy) SendTanksText sendTanksText;

@property (nonatomic, strong) NSString *messageId;

@property (nonatomic, strong) NSString *sessionId;

@property (nonatomic, strong) QMSatisfactionModel *satisfactionModel;

@property (nonatomic, strong) UIScrollView *coverView;

@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UITextView *remarkTView;

@end

NS_ASSUME_NONNULL_END
