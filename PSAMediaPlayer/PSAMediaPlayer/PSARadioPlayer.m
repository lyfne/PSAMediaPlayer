//
//  PSARadioPlayer.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-10-7.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSARadioPlayer.h"
#import "PSARadioConstantsConfig.h"
#import "PSAMusicPlayer.h"
#import "PSAMusicConstantsConfig.h"

static PSARadioPlayer *psaRadioPlayerInstance;
static int radioViewState;

@implementation PSARadioPlayer

+ (PSARadioPlayer *)sharedPSARadioPlayer
{
    static dispatch_once_t PSAFileManagerLock;
    dispatch_once(&PSAFileManagerLock, ^{
        psaRadioPlayerInstance = [[PSARadioPlayer alloc] init];
    });
    
    return psaRadioPlayerInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        nowPlayingRadio = @"F89.2";
    }
    return self;
}

- (void)playRadio:(NSString *)value
{
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] getMusicPlayerState] == kMusicPlayerStateStop) {
        radioViewState = kRadioPlayerStatePlaying;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:value ofType:@"mp3"];
        NSURL* url = [NSURL fileURLWithPath:filePath];
        
        psaRadioPlayerInstance = [psaRadioPlayerInstance initWithContentsOfURL:url error:nil];
        [psaRadioPlayerInstance prepareToPlay];
        [psaRadioPlayerInstance play];
        
        nowPlayingRadio = value;
    }
}

- (void)prepareRadioPlayer
{
    radioViewState = kRadioPlayerStateStop;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"89.2" ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:filePath];
    
    psaRadioPlayerInstance = [psaRadioPlayerInstance initWithContentsOfURL:url error:nil];
    psaRadioPlayerInstance.numberOfLoops = 100;
    [psaRadioPlayerInstance prepareToPlay];
}

- (int)getRadioPlayerState
{
    return radioViewState;
}

- (void)setRadioPlayerState:(int)state
{
    radioViewState = state;
}

- (NSString *)getNowPlayingRadio
{
    return nowPlayingRadio;
}

- (void)setNowPlayingRadio:(NSString *)value
{
    nowPlayingRadio = value;
}

@end
