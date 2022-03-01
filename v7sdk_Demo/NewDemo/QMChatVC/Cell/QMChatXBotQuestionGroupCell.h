//
//  QMChatXBotQuestionGroupCell.h
//  NewDemo
//
//  Created by ZCZ on 2021/5/25.
//

#import <UIKit/UIKit.h>
#import "QMChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMChatXBotQuestionGroupCell : QMChatBaseCell

@property (nonatomic, copy) void(^showAllAction)(NSDictionary *);

@end

@interface QMQuestionListView : UIView

@property (nonatomic, copy) void(^upCellConstraint)(void);
@property (nonatomic, strong) NSArray *commonQuestionsGroup;
@property (nonatomic, strong) UIImageView *loginImage;
@property (nonatomic, copy) void(^showAllAction)(NSDictionary *);
@property (nonatomic, copy) void(^sendText)(NSString *text);

@end

NS_ASSUME_NONNULL_END
