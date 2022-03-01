//
//  QMChatImageCell.m
//  newDemo
//
//  Created by lishuijiao on 2021/2/4.
//

#import "QMChatImageCell.h"
#import "QMChatShowImageViewController.h"

@interface QMChatImageCell ()
@end

@implementation QMChatImageCell


- (void)setupSubviews {
    [super setupSubviews];
    [self.bubblesBgView addSubview:self.showImageView];
    [self.showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bubblesBgView);
        make.width.height.mas_equalTo(200).priorityHigh();
    }];
}

- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];
    self.bubblesBgView.backgroundColor = UIColor.clearColor;
    NSString *urlString = model.content;
    if ([urlString.stringByRemovingPercentEncoding isEqualToString:urlString]) {
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    }
    NSURL *url = [NSURL URLWithString:urlString ? : @"" ];
    
    if (model.fileSize.length > 0) {
        NSArray *arr = [model.fileSize componentsSeparatedByString:@"X"];
        if (arr.copy > 0) {
            CGSize size = CGSizeMake([arr.firstObject doubleValue], [arr.lastObject doubleValue]);
            [self upShowImageViewFrame:size needUpdateCell:NO];
        }
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",urlString.lastPathComponent];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            self.showImageView.image = [UIImage imageNamed:filePath];
        }else {
            [self setNetImageWithURL:url];
        }

    } else {
        [self setNetImageWithURL:url];
    }
    
}

- (void)setNetImageWithURL:(NSURL *)url {

    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:url.absoluteString];

    if (image) {
        self.showImageView.image = image;
        [self upShowImageViewFrame:image.size needUpdateCell:NO];
    } else {
        
        [self.showImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"chat_image_placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self upShowImageViewFrame:image.size needUpdateCell:YES];
        }];
    }
    
}

- (void)upShowImageViewFrame:(CGSize)imageSize needUpdateCell:(BOOL)update {
    if (imageSize.height == 0 || imageSize.width == 0) {
        return;
    }
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    if (imageSize.width > imageSize.height) {
        width = imageSize.width > 200 ? 200 : imageSize.width;
        height = width*imageSize.height/imageSize.width;
    } else {
        height = imageSize.height > 200 ? 200 : imageSize.height;
        width = height*imageSize.width/imageSize.height;
    }
    
    
    [self.showImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height).priorityHigh();
        make.width.mas_equalTo(width).priorityHigh();
    }];
    
    if (update && self.upCellConstraint) {
        self.message.fileSize = [NSString stringWithFormat:@"%.1fX%.1f",imageSize.width, imageSize.height];
        self.upCellConstraint(self.message);
    }

}

- (void)tapRecognizerAction {
    QMChatShowImageViewController * showPicVC = [[QMChatShowImageViewController alloc] init];
    showPicVC.imageUrl = self.message.content;
//    showPicVC.picType = gestureRecognizer.picType;
    showPicVC.image = self.showImageView.image;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicVC animated:true completion:nil];

}

- (SDAnimatedImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[SDAnimatedImageView alloc] init];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.userInteractionEnabled = YES;
    }
    return  _showImageView;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)press {
    UIMenuController *menuVC = [UIMenuController sharedMenuController];
    UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"保存图片".toLocalized action:@selector(savePicture:)];
    menuVC.menuItems = @[item];
    [self becomeFirstResponder];
    if (self.message.type == ChatMessageRev) {
        
    } else {
        
    }
    
    if (@available(iOS 13.0, *)) {
        [menuVC showMenuFromView:self rect:self.bubblesBgView.frame];
    } else {
        [menuVC setTargetRect:press.view.bounds inView:press.view];
        [menuVC setMenuVisible:YES];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(savePicture:)) {
        return true;
    }
    return false;
}

- (void)savePicture:(UIMenuItem *)item {
    UIImageWriteToSavedPhotosAlbum(self.showImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        NSLog(@"保存完成");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
