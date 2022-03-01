//
//  QMChatInputView+Delegate.m
//  NewDemo
//
//  Created by ZCZ on 2021/6/30.
//

#import "QMChatInputView+Delegate.h"

@implementation QMChatInputView (Delegate)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.inputView.isFirstResponder == false) {
        [self.inputView becomeFirstResponder];
    }
    
    if ([self.inputView.inputView isKindOfClass:[QMChatFaceView class]]) {
        [self showEmotionView:NO];
        NSRange rag = self.inputView.selectedRange;
        self.inputView.selectedRange = rag;
        [self.inputView reloadInputViews];
        [self.inputView becomeFirstResponder];

    } else if ([self.inputView.inputView isKindOfClass:[QMChatMoreView class]]) {
        [self showMoreView:NO];
        [self.inputView reloadInputViews];
        [self.inputView becomeFirstResponder];

    }
    return NO;
}

#pragma mark - faceDelegate
- (void)touchFaceEmoji:(QMChatEmoji *)emoji {
    [self insertEmoji:emoji];
}

- (void)touchFaceSendBtn {
    if (![self.inputView.text isEqualToString:@""]) {
        if ([self.delegate respondsToSelector:@selector(sendTextViewText:)]) {
            NSString *text = [self.inputView.textStorage getRichString];
            [self.delegate sendTextViewText:text];
        }
        self.inputView.text = @"";
    }
}

- (void)touchFaceDeleteBtn {
    [self.inputView deleteBackward];
}

- (void)insertEmoji:(QMChatEmoji *)emoji {

    QMTextAttachment *emojiTextAttemt = [QMTextAttachment new];
//    emojiTextAttemt.emojiCode = [NSString stringWithFormat:@"%ld", (long)row];
    emojiTextAttemt.emojiCode = emoji.name;
    emojiTextAttemt.image = emoji.image;
    emojiTextAttemt.bounds = CGRectMake(0, -3, 20, 20);
    
    NSAttributedString *attributeString = [NSAttributedString attributedStringWithAttachment:emojiTextAttemt];
    NSRange range = [self.inputView selectedRange];
    if (range.length > 0) {
        [self.inputView.textStorage deleteCharactersInRange:range];
    }
    [self.inputView.textStorage insertAttributedString:attributeString atIndex:[self.inputView selectedRange].location];
    self.inputView.selectedRange = NSMakeRange(self.inputView.selectedRange.location+1, 0);
    
    [self resetTextStyle];
}

- (void)resetTextStyle {
    NSRange wholeRange = NSMakeRange(0, self.inputView.textStorage.length);
    [self.inputView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [self.inputView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:wholeRange];
    self.inputView.font = [UIFont systemFontOfSize:18];
    [self.emojiView setButtonEnble:self.inputView.text.length > 0];

}
#pragma mark - UITextViewDelegate && xbot联想输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@"\n"]) {
        if (![self.inputView.text isEqualToString:@""]) {

            if ([self.delegate respondsToSelector:@selector(sendTextViewText:)]) {
                NSString *text = [self.inputView.textStorage getRichString];
                [self.delegate sendTextViewText:text];
            }
            self.inputView.text = @"";
            return NO;
        }
        return NO;
    }
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self.emojiView setButtonEnble:textView.text.length > 0];
    self.hintText.hidden = textView.text.length > 0;
    if ([self.delegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.delegate textViewDidChangeSelection:textView.text];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    self.hintText.hidden = textView.text.length > 0;
    [self.emojiView setButtonEnble:textView.text.length > 0];
    if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:textView.text];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.delegate textViewDidBeginEditing:textView.text];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.delegate textViewDidEndEditing:textView.text];
    }
    
    if (!textView.text.length && [QMThemeManager shared].inputViewHintText.length) {
        self.hintText.hidden = NO;
    }
}

#pragma mark - QMMoreViewDelegate
- (void)moreViewSelectAcitonIndex:(QMChatMoreMode)index {
    if ([self.delegate respondsToSelector:@selector(moreViewSelectAcitonIndex:)]) {
        [self.delegate moreViewSelectAcitonIndex:index];
    }
}

#pragma mark - QMAudioRecorderDelegate
- (void)audioRecorderStart {
    
}

- (void)audioRecorderCompletion:(NSString *)fileName duration:(NSString *)duration {
    
    NSString * path = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",fileName];
    [SJVoiceTransform stransformToMp3ByUrlWithUrl:path];
    if ([self.delegate respondsToSelector:@selector(sendAudio:duration:)]) {
        [self.delegate sendAudio:fileName duration:duration];
    }
    
    if (duration.intValue >= 60) {
        [self.recordeView changeViewStatus:QMIndicatorStatusLong];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.recordeView removeFromSuperview];
            [self changeRecordButtonStatus:NO];
        });
    }else {
        [self.recordeView removeFromSuperview];
        [self changeRecordButtonStatus:NO];
    }
}

- (void)audioRecorderChangeInTimer:(NSTimeInterval)power total:(int)count {
    [self.recordeView updateImageWithPower:power];
    self.recordeView.count = count;
}

- (void)audioRecorderCancel {
    [self.recordeView removeFromSuperview];
    [self changeRecordButtonStatus:NO];
}

- (void)audioRecorderFail {
    [self.recordeView changeViewStatus:QMIndicatorStatusShort];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.recordeView removeFromSuperview];
        [self changeRecordButtonStatus:NO];
    });
}




@end
