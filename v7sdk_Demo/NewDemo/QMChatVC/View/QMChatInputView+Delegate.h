//
//  QMChatInputView+Delegate.h
//  NewDemo
//
//  Created by ZCZ on 2021/6/30.
//

#import "QMChatInputView.h"
#import "QMChatFaceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMChatInputView (Delegate) <UIGestureRecognizerDelegate, UITextViewDelegate, QMChatFaceDelegete, QMMoreViewDelegate, QMAudioRecorderDelegate, AVAudioRecorderDelegate>

@end

NS_ASSUME_NONNULL_END
