//
//  PSARadioPlayer.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-10-7.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface PSARadioPlayer : AVAudioPlayer{
    NSString *nowPlayingRadio;
}

+ (PSARadioPlayer *)sharedPSARadioPlayer;

- (void)playRadio:(NSString *)value;

- (void)prepareRadioPlayer;

- (void)setRadioPlayerState:(int)state;
- (int)getRadioPlayerState;

- (NSString *)getNowPlayingRadio;
- (void)setNowPlayingRadio:(NSString *)value;

@end
