//
//  QMChatImageCell.h
//  newDemo
//
//  Created by lishuijiao on 2021/2/4.
//

#import "QMChatBaseCell.h"
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMChatImageCell : QMChatBaseCell
@property (nonatomic, strong) SDAnimatedImageView *showImageView;
@end

NS_ASSUME_NONNULL_END
