//
//  QMChatListCardCell.h
//  NewDemo
//
//  Created by lishuijiao on 2021/6/22.
//

#import "QMChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMChatListCardCell : QMChatBaseCell

@property (nonatomic, copy) void(^selectItem)(NSString *clickText);

@end


@interface QMChatListCardCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *configureDic;

@end

NS_ASSUME_NONNULL_END
