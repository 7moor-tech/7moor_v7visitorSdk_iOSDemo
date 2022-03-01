//
//  QMMoreQuestionView.h
//  NewDemo
//
//  Created by ZCZ on 2021/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMMoreQuestionView : UIView
+ (instancetype)sharedView;
- (void)show:(NSDictionary *)dict completion:(void(^)(NSString *))completion;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
