//
//  QMChatAudiCell.m
//  newDemo
//
//  Created by ZCZ on 2021/2/25.
//

#import "QMChatAudioCell.h"

@interface QMChatAudioCell () <AVAudioPlayerDelegate>

@property (nonatomic, strong) UIImageView *audioIcon;
@property (nonatomic, strong) UILabel *timeLengthLab;

@end

@implementation QMChatAudioCell

- (void)setupSubviews {
    [super setupSubviews];
    
    [self.bubblesBgView addSubview:self.audioIcon];
    [self.bubblesBgView addSubview:self.timeLengthLab];
    
    [self.audioIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubblesBgView).offset(12);
        make.centerY.equalTo(self.bubblesBgView);
        make.height.mas_equalTo(30);
    }];
    

}

- (void)setupGestureRecognizer {
    [super setupGestureRecognizer];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//    [self.bubblesBgView addGestureRecognizer:tap];

}

- (NSString *)getAudioDuration:(QMChatMessage *)model {
    NSString *duration = @"0";
    if (model.duration.length > 0) {
        duration = model.duration;
    } else {
        NSURL *playerURL = [NSURL URLWithString:self.message.content];

        AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:playerURL options:nil];
        CMTime audioDuration = audioAsset.duration;
        double audioDurationSeconds = CMTimeGetSeconds(audioDuration);
        
        duration = [NSString stringWithFormat:@"%.0f",audioDurationSeconds];
    }
    
    if (duration.intValue == 0) {
        duration = @"1";
    }
    
    return duration;
    
}

- (void)setCellData:(QMChatMessage *)model {
    [super setCellData:model];
    
    if (model.type == ChatMessageRev) {
        self.audioIcon.image = [UIImage imageNamed:@"audio_receive_play"];
        self.audioIcon.animationImages = @[[UIImage imageNamed:@"audio_receive_playing01"],[UIImage imageNamed:@"audio_receive_playing02"],[UIImage imageNamed:@"audio_receive_playing03"]];
        self.timeLengthLab.text = [self getAudioDuration:model];
        int timeLength = [self.timeLengthLab.text intValue] * 150/60;
        if (timeLength < 15) {
            timeLength = 15;
        } else if (timeLength > 150) {
            timeLength = 150;
        }

        [self.audioIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubblesBgView).offset(12);
            make.centerY.equalTo(self.bubblesBgView);
            make.height.mas_equalTo(30);
        }];
        
        [self.timeLengthLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.audioIcon.mas_right).offset(8);
            make.centerY.equalTo(self.audioIcon);
            make.right.equalTo(self.bubblesBgView).offset(-timeLength).priorityHigh();
        }];
        
    } else {
        self.audioIcon.image = [UIImage imageNamed:@"audio_send_play"];
        self.timeLengthLab.text = [self getAudioDuration:model];
        self.audioIcon.animationImages = @[[UIImage imageNamed:@"audio_send_playing01"],[UIImage imageNamed:@"audio_send_playing02"],[UIImage imageNamed:@"audio_send_playing03"]];
        int timeLength = [self.timeLengthLab.text intValue] * 150/60;
        if (timeLength < 15) {
            timeLength = 15;
        } else if (timeLength > 150) {
                timeLength = 150;
        }
        
        [self.audioIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bubblesBgView).offset(-12);
            make.centerY.equalTo(self.bubblesBgView);
            make.height.mas_equalTo(30);
        }];
        
        [self.timeLengthLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.audioIcon.mas_left).offset(-8);
            make.centerY.equalTo(self.audioIcon);
            make.left.equalTo(self.bubblesBgView).offset(timeLength).priorityHigh();
        }];
        
    }
}

- (void)tapRecognizerAction {
    if (self.audioIcon.isAnimating) {
        [self.audioIcon stopAnimating];
    } else {
        [self.audioIcon startAnimating];
    }
    
    NSString *fileName = @"";
    if ([self existFile:self.message._id]) {
        fileName = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", [NSString stringWithFormat:@"%@", self.message._id]];
    } else if ([self existFile:[NSString stringWithFormat:@"%@", self.message.content]]) {
        fileName = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", [NSString stringWithFormat:@"%@", self.message.content]];
    }

    if (fileName.length > 0) {
        [[QMAudioPlayer sharedInstance] startAudioPlayer:fileName withDelegate:self];
    } else {
        fileName = self.message.content;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *fileUrl = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", [NSString stringWithFormat:@"%@", self.message._id]];
            NSURL *playerURL = [NSURL URLWithString:self.message.content];
            NSData *data = [NSData dataWithContentsOfURL:playerURL];
            
            [data writeToFile:fileUrl atomically:YES];
            
            [[QMAudioPlayer sharedInstance] startAudioPlayer:fileUrl withDelegate:self];
        });
    }

}

//- (void)longPressAction:(UITapGestureRecognizer *)tap {
//    if (self.audioIcon.isAnimating) {
//        [self.audioIcon stopAnimating];
//    } else {
//        [self.audioIcon startAnimating];
//    }
//
//    NSString *fileName;
//    if ([self existFile:self.message.content]) {
//        fileName = self.message.content;
//    }else {
////        NSString *playUrl = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", [NSString stringWithFormat:@"%@", self.message._id]];
////        fileName = self.message._id;
////        NSURL *fileUrl = [NSURL URLWithString:self.message.remoteFilePath];
////        NSData *data = [NSData dataWithContentsOfURL:fileUrl];
////
////        [data writeToFile:playUrl atomically:YES];
//    }
//    [[QMAudioPlayer sharedInstance] startAudioPlayer:fileName withDelegate:self];
//
//}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.audioIcon stopAnimating];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self.audioIcon stopAnimating];
}

- (BOOL)existFile: (NSString *)name {
    NSString * filePath = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }else {
        return NO;
    }
}

//*****jiaz*************/
- (UIImageView *)audioIcon {
    if (!_audioIcon) {
        _audioIcon = [UIImageView new];
        _audioIcon.contentMode = UIViewContentModeScaleAspectFit;
        _audioIcon.animationDuration = 1;

    }
    return _audioIcon;
}

-(UILabel *)timeLengthLab {
    if (!_timeLengthLab) {
        _timeLengthLab = [UILabel new];
        _timeLengthLab.font = [UIFont fontWithName:QM_PingFangSC_Reg size:13];
    }
    return _timeLengthLab;
}

@end
