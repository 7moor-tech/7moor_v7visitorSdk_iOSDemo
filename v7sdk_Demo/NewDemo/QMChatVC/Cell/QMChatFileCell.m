//
//  QMChatFileCell.m
//  newDemo
//
//  Created by ZCZ on 2021/2/25.
//

#import "QMChatFileCell.h"
#import "PieView.h"
#import "QMChatShowFileViewController.h"
#import "QMProfileManager.h"


@interface QMChatFileCell ()
@property (nonatomic, strong) UIImageView *fileIcon;
@property (nonatomic, strong) UILabel *fileNameLab;
@property (nonatomic, strong) UILabel *fileSizeLabel;
//@property (nonatomic, strong) UILabel *downloadStatusLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) PieView *pieView;
@end

@implementation QMChatFileCell


- (void)setupSubviews {
    [super setupSubviews];
    
    [self.bubblesBgView addSubview:self.fileIcon];
    [self.bubblesBgView addSubview:self.fileNameLab];
    [self.bubblesBgView addSubview:self.fileSizeLabel];
//    [self.bubblesBgView addSubview:self.downloadStatusLabel];
    [self.bubblesBgView addSubview:self.progressView];

    [self.fileIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bubblesBgView).offset(-15);
        make.top.equalTo(self.bubblesBgView).offset(15);
        make.width.mas_equalTo(45*kScale6).priority(999);
        make.height.mas_equalTo(60*kScale6).priority(999);
        make.bottom.equalTo(self.bubblesBgView).offset(-15);
    }];
    
    [self.fileNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubblesBgView).offset(14);
        make.top.equalTo(self.fileIcon);
        make.right.lessThanOrEqualTo(self.fileIcon.mas_left).offset(-15);
        make.width.mas_equalTo(170*kScale6).priorityHigh();
    }];
    
    [self.fileSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fileNameLab);
        make.top.equalTo(self.fileNameLab.mas_bottom).offset(6);
        make.right.lessThanOrEqualTo(self.bubblesBgView).offset(-100);
    }];
    
//    [self.downloadStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.lessThanOrEqualTo(self.bubblesBgView).offset(-8);
//        make.top.equalTo(self.fileSizeLabel);
//    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fileIcon);
        make.right.equalTo(self.bubblesBgView).offset(-10);
        make.bottom.equalTo(self.bubblesBgView).offset(-4);
        make.height.mas_equalTo(2);
    }];
}

- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];
    self.bubblesBgView.backgroundColor = UIColor.whiteColor;
    self.fileNameLab.text = model.fileName ? : @"";
    
//    NSString *status = @"";
    if (model.type == ChatMessageRev) {
        [self updateDownStatus];

    } else {
        [self updateSendStatues];

    }

    NSString *imageName = [self matchImageWithFileNameExtension: model.fileName.pathExtension.lowercaseString];
    self.fileIcon.image = [UIImage imageNamed:imageName];
}

- (void)tapRecognizerAction {
    [super tapRecognizerAction];
    
    if (self.message.localFilePath.length == 0) {
        NSString *localPath = [[QMProfileManager sharedInstance] checkFileExtension:self.message.fileName];
        __weak QMChatFileCell *weakSelf = self;
        [QMConnect downloadFileWithMessage:self.message localFilePath:localPath progressHander:^(float progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setProgress:progress];
            });
        } successBlock:^{
            // 图片或视频存储至相册
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setProgress:1];
                self.message.downloadState = @"0";
                [self updateDownStatus];
            });
        } failBlock:^(NSString * _Nonnull error) {
            [weakSelf setProgress:1];
        }];
    }else {
        // 打开本地文件
        QMChatShowFileViewController *showFile = [[QMChatShowFileViewController alloc] init];
        showFile.modalPresentationStyle = UIModalPresentationFullScreen;
        showFile.filePath = self.message.localFilePath;
        UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [vc presentViewController:showFile animated:YES completion:nil];
    }
}

- (void)updateSendStatues {
    NSString *status = @"";
    if ([self.message.status isEqualToString:@"0"]) {
        status = @"发送成功".toLocalized;
    } else if ([self.message.status isEqualToString:@"1"]) {
        status = @"发送失败".toLocalized;
    } else {
        status = @"发送中".toLocalized;
    }
    NSString *fileSize = [self.message.fileSize ? [self.message.fileSize stringByAppendingString:@" / "] : @"" stringByAppendingString:status];
    
    self.fileSizeLabel.text = fileSize;

}

- (void)updateDownStatus {
    
    NSString *status = @"";

    if ([self.message.downloadState isEqualToString:@"0"]) {
        status = @"已下载".toLocalized;
    } else if ([self.message.downloadState isEqualToString:@"1"]) {
        status = @"下载失败".toLocalized;
    } else {
        status = @"未下载".toLocalized;
    }
    NSString *fileSize = [self.message.fileSize ? [self.message.fileSize stringByAppendingString:@" / "] : @"" stringByAppendingString:status];
    
    self.fileSizeLabel.text = fileSize;

}

- (NSString *)matchImageWithFileNameExtension:(NSString *)fileName {
    NSString * str;
    if ([fileName isEqualToString:@"doc"]||[fileName isEqualToString:@"docx"]) {
        str = @"file_doc";
    }else if ([fileName isEqualToString:@"xlsx"]||[fileName isEqualToString:@"xls"]) {
        str = @"file_xls";
    }else if ([fileName isEqualToString:@"ppt"]||[fileName isEqualToString:@"pptx"]) {
        str = @"file_pptx";
    }else if ([fileName isEqualToString:@"pdf"]) {
        str = @"file_pdf";
    }else if ([fileName isEqualToString:@"mp3"]) {
        str = @"file_audio";
    }else if ([fileName isEqualToString:@"mov"]||[fileName isEqualToString:@"mp4"]) {
        str = @"file_video";
    }else if ([fileName isEqualToString:@"png"]||[fileName isEqualToString:@"jpg"]||[fileName isEqualToString:@"bmp"]||[fileName isEqualToString:@"jpeg"] || [fileName isEqualToString:@"heic"]) {
        str = @"file_picture";
    }else {
        str = @"file_other";
    }
    return str;
}

- (void)setProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pieView removeFromSuperview];
        self.pieView = [[PieView alloc] initWithFrame:CGRectMake(-45/2, -15, 90, 90) dataItems:@[@(progress),@(1-progress)] colorItems:@[[UIColor clearColor], k_qm_RGBA(0, 0, 0, 0.2)]];
        self.pieView.backgroundColor = [UIColor clearColor];
        [self.fileIcon addSubview:self.pieView];
        [self.pieView stroke];
        if (progress >= 1) {
            if (self.message.type == ChatMessageSend) {
                self.message.status = @"0";
                [self updateSendStatues];
            }
        }
    });
}



//*******穿甲**********/
- (UIImageView *)fileIcon {
    if (!_fileIcon) {
        _fileIcon = [UIImageView new];
        _fileIcon.contentMode = UIViewContentModeScaleAspectFill;
        _fileIcon.clipsToBounds = YES;
    }
    return _fileIcon;
}

- (UILabel *)fileNameLab {
    if (!_fileNameLab) {
        _fileNameLab = [UILabel new];
        _fileNameLab.numberOfLines = 2;
        _fileNameLab.font = [UIFont fontWithName:QM_PingFangSC_Med size:15];
        _fileNameLab.textColor = isQMDarkStyle ? k_QMRGB(66, 66, 66) : UIColor.blackColor;
    }
    return _fileNameLab;
}

- (UILabel *)fileSizeLabel {
    if (!_fileSizeLabel) {
        _fileSizeLabel = [UILabel new];
        _fileSizeLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
        _fileSizeLabel.textColor = isQMDarkStyle ? k_QMRGB(66, 66, 66) : UIColor.grayColor;
    }
    return _fileSizeLabel;
}

//- (UILabel *)downloadStatusLabel {
//    if (!_downloadStatusLabel) {
//        _downloadStatusLabel = [UILabel new];
//        _downloadStatusLabel.font = [UIFont fontWithName:QM_PingFangSC_Reg size:12];
//        _downloadStatusLabel.textColor = isQMDarkStyle ? k_QMRGB(66, 66, 66) : UIColor.grayColor;
//    }
//    return _downloadStatusLabel;
//}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.progressTintColor = UIColor.redColor;
        _progressView.tintColor = UIColor.grayColor;
        _progressView.hidden = YES;
    }
    return _progressView;
}

//*******end**********/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
