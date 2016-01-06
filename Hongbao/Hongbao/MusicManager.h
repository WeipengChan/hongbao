//
//  MusicManager.h
//  Hongbao
//
//  Created by dev on 16/1/6.
//  Copyright © 2016年 Yate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol MusicManagerDelegate <NSObject>

@optional
- (void)musicManagerPlayCountDownDidFinish;

@end

@interface MusicManager : NSObject


@property (nonatomic, weak) id<MusicManagerDelegate> delegate;


+ (instancetype)defaultManager;


// 播放倒数
- (void)playCountDownSound;

// 播放背景
- (void)playBackgroupSound;

// 停止背景
- (void)stopBackgroupSound;

// 播放点空
- (void)playTapAirSound;

// 播放点中
- (void)playTapGetSound;

@end
