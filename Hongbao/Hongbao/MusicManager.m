//
//  MusicManager.m
//  Hongbao
//
//  Created by dev on 16/1/6.
//  Copyright © 2016年 Yate. All rights reserved.
//

#import "MusicManager.h"

@interface MusicManager () <AVAudioPlayerDelegate>
{
    AVAudioPlayer *_avAudioPlayer;   //播放器player
    
    BOOL _isCountDown;
}
@end

static MusicManager *_instance = nil;

@implementation MusicManager

+ (instancetype)defaultManager {
    if (_instance == nil) {
        static dispatch_once_t one;
        dispatch_once(&one, ^{
            _instance = [[MusicManager alloc] init];
        });
    }
    return _instance;
}


- (void)playCountDownSound {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"luckytap_countdown" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _avAudioPlayer.delegate = self;
//    _avAudioPlayer.numberOfLoops = 1;
//    [_avAudioPlayer prepareToPlay];
    [_avAudioPlayer play];
    _isCountDown = YES;
}


- (void)playBackgroupSound {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"luckytap_bg" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _avAudioPlayer.delegate = self;
    _avAudioPlayer.numberOfLoops = -1;
    [_avAudioPlayer prepareToPlay];
    [_avAudioPlayer play];
    _isCountDown = NO;
}


- (void)stopBackgroupSound {
    if (_avAudioPlayer && _avAudioPlayer.isPlaying) {
        [_avAudioPlayer stop];
    }
}


- (void)playTapAirSound {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"luckytap_air" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void)playTapGetSound {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"luckytap_get" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark - Delegate
// 音频播放完成时
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    // 音频播放完成时，调用该方法。
    // 参数flag：如果音频播放无法解码时，该参数为NO。
    //当音频被终端时，该方法不被调用。而会调用audioPlayerBeginInterruption方法
    // 和audioPlayerEndInterruption方法
    
    
    if (_isCountDown) {
        _isCountDown = NO;
        if (flag && _delegate && [_delegate respondsToSelector:@selector(musicManagerPlayCountDownDidFinish)]) {
            [_delegate musicManagerPlayCountDownDidFinish];
        }
    }
}


// 解码错误
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"解码错误！");
    
    
}






@end
