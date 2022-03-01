//
//  QMAudioPlayer.m
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/8/17.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import "QMAudioPlayer.h"
#import "QMAudioAnimation.h"

@interface QMAudioPlayer ()
@property (nonatomic, strong)AVAudioPlayer *player;
@end

@implementation QMAudioPlayer

static QMAudioPlayer * instance = nil;

+ (QMAudioPlayer *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (void)startAudioPlayer:(NSString *)fileName withDelegate:(id)audioPlayerDelegate {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
    NSURL *fileURL = [NSURL URLWithString:fileName];
    
    if (self.player.isPlaying) {
        [self.player stop];
        [self.player.delegate audioPlayerDidFinishPlaying:self.player successfully:NO];
        
        if ([self.fileName isEqualToString:fileName]) {
            return;
        }
    }
    
    self.fileName = fileName;
    
    NSError *playError = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&playError];
    audioPlayer.delegate = audioPlayerDelegate;
    [audioPlayer prepareToPlay];
    self.player = audioPlayer;
    if (playError == nil) {
        [self.player play];
    }else {
        [self.player stop];
    }
}

- (void)stopAudioPlayer {
    if (self.player) {
        [self.player stop];
        self.player = nil;
        self.fileName = nil;
    }
}

- (BOOL)isPlaying:(NSString *)fileName {
    if (self.player && [self.fileName isEqualToString:fileName]) {
        return self.player.isPlaying;
    }else {
        return NO;
    }
}
@end
