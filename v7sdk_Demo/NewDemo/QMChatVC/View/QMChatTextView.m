//
//  QMChatTextView.m
//  newDemo
//
//  Created by ZCZ on 2021/2/26.
//

#import "QMChatTextView.h"

@implementation QMChatTextView
- (instancetype)init {
    if (self = [super init]) {
        UIColor *color = k_QMRGB(0, 129, 255);
        if (QMThemeManager.shared.mainColorModel.hasBeenSetColor) {
            color = QMThemeManager.shared.mainColorModel.color;
        }
        self.linkTextAttributes = @{NSForegroundColorAttributeName: color};
        self.editable = false;
        self.scrollEnabled = false;

    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {

    if (action == @selector(copy:)) {
        return YES;
    }
    return false;
}

- (void)copy:(id)sender {
    [super copy:sender];
    [self endEditing:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
