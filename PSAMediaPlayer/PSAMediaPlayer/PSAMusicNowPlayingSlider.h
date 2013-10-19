//
//  PSAMusicNowPlayingSlider.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-30.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NowPlayingSliderDelegatye

- (void)touchEnd;

@optional
- (void)setCurrentTimeLabel;

@end

@interface PSAMusicNowPlayingSlider : UISlider

@property(weak, nonatomic) id<NowPlayingSliderDelegatye> delegate;

@end
