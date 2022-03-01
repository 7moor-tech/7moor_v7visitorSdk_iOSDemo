//
//  QMChatFaceView.h
//  newDemo
//
//  Created by lishuijiao on 2021/3/3.
//

#import <UIKit/UIKit.h>
#import "QMChatEmoji.h"
NS_ASSUME_NONNULL_BEGIN

@protocol QMChatFaceDelegete <NSObject>

- (void)touchFaceEmoji:(QMChatEmoji *)emoji;

- (void)touchFaceDeleteBtn;

- (void)touchFaceSendBtn;

@end

@interface QMChatFaceView : UIView

@property (nonatomic, weak) id<QMChatFaceDelegete> delegate;

- (void)loadData;

- (void)setButtonEnble:(BOOL)enable;

@end

@interface QMChatFaceCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
