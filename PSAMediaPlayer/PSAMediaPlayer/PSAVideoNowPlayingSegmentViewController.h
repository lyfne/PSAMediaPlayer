//
//  PSAVideoNowPlayingSegmentViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSAMusicNowPlayingSlider.h"

@protocol VideoNowPlayingSegmentDelegate

- (void)backToMainView;
- (void)playPauseVideo:(int)sign;
- (void)playAtTime:(float)time;
- (void)stopTimer;

@end

@interface PSAVideoNowPlayingSegmentViewController : UIViewController<NowPlayingSliderDelegate>{
    float videoDuration;
    float currentTime;
}

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet PSAMusicNowPlayingSlider *videoSlider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *quickPreButton;
@property (weak, nonatomic) IBOutlet UIButton *quickNextButton;

@property (weak, nonatomic) id<VideoNowPlayingSegmentDelegate> delegate;

- (IBAction)backToMenuAction:(id)sender;
- (IBAction)playAction:(id)sender;
- (IBAction)quickPreAction:(id)sender;
- (IBAction)quickNextAction:(id)sender;

- (void)setSliderValue:(float)time;
- (void)setDuration:(float)duration;

+ (PSAVideoNowPlayingSegmentViewController *)createVideoNowPlayingSegmentViewController;

@end
