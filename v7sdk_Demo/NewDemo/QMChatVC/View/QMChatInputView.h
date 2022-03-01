//
//  QMChatInputView.h
//  newDemo
//
//  Created by lishuijiao on 2021/2/3.
//

#import <UIKit/UIKit.h>
#import "QMChatEmoji.h"
#import "QMChatMoreView.h"
#import "QMChatFaceView.h"
#import "QMRecordIndicatorView.h"

NS_ASSUME_NONNULL_BEGIN
//--zcz-5.24添加
typedef enum : NSUInteger {
    QMInputViewModeVoice = 100,
    QMInputViewModeRecordCancel,
    QMInputViewModeRecordBegin,
    QMInputViewModeRecordEnd,
    QMInputViewModeRecordExit,
    QMInputViewModeRecordEnter,
    QMInputViewModeFace,
    QMInputViewModeAdd,
} QMInputViewMode;
//-end



@protocol QMInputeViewDelegate <NSObject>

- (void)moreViewSelectAcitonIndex:(QMChatMoreMode)index;

- (void)textViewDidChange:(NSString *)text;
- (void)textViewDidBeginEditing:(NSString *)text;
- (void)textViewDidEndEditing:(NSString *)text;
- (void)textViewDidChangeSelection:(NSString *)text;

- (void)sendTextViewText:(NSString *)text;
- (void)sendAudio:(NSString *)audioName duration:(NSString *)duration;


//
//@optional
//- (void)inputButtonAction:(UIButton *)button index:(int)index;
//
//@optional
//// --zcz-6.23添加
//- (void)inputButtonActionIndex:(QMInputViewMode)index selected:(BOOL)isSelected;
////-end
//
//
@end


@interface QMChatInputView : UIView 

@property (nonatomic, weak) id <QMInputeViewDelegate> delegate;
@property (nonatomic, strong)UITextView *inputView; // 输入栏
@property (nonatomic, strong)UIButton *recordBtn; // 录音按钮

@property (nonatomic, strong)UIView *coverView; // 限制出入蒙版
@property (nonatomic, strong)UIView *backView; //输入栏和表情底部view
@property (nonatomic, strong)UILabel *hintText; //默认文案


@property (nonatomic, strong) QMRecordIndicatorView *recordeView; // 录音动画面板

@property (nonatomic, strong) QMChatMoreView *addView;
@property (nonatomic, strong) QMChatFaceView *emojiView;



- (void)setDarkModeColor;
// QMMoreViewDelegate / QMChatFaceDelegete
- (void)setChatInputDelegate:(id _Nullable)delegate;
/**
 录音按钮显示切换
 */
- (void)showRecordButton: (BOOL)show;

/**
 表情面板显示切换
 */
- (void)showEmotionView: (BOOL)show;


/**
 扩展面板显示切换
 */
- (void)showMoreView: (BOOL)show;

- (void)refreshInputView;

// 更改按钮状态
- (void)changeRecordButtonStatus:(BOOL)down;

@end

NS_ASSUME_NONNULL_END
