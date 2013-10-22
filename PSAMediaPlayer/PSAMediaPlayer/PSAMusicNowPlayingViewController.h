//
//  PSAMusicNowPlayingViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-24.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PSAMusicDVDViewController.h"
#import "PSAMusicNowPlayingSlider.h"

@interface PSAMusicNowPlayingViewController : UIViewController/*<PSADVDSwitchDelegate,*/<NowPlayingSliderDelegate>{
    NSTimer *processTimer;
    int angle;
    int rotateState;
}

@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowPlayingLabel;
@property (weak, nonatomic) IBOutlet UILabel *tunesSumLabel;

@property (weak, nonatomic) IBOutlet PSAMusicNowPlayingSlider *progressSlider;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *playModeButton;
@property (weak, nonatomic) IBOutlet UIButton *preButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;
@property (weak, nonatomic) IBOutlet UIButton *diskButton;
@property (weak, nonatomic) IBOutlet UIButton *albumButton;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *diskView;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rotateImageView;

+ (PSAMusicNowPlayingViewController *)createMusicNowPlayingViewController;

- (IBAction)nextTuneAction:(id)sender;
- (IBAction)preTuneAction:(id)sender;
- (IBAction)playAndStopAction:(id)sender;
- (IBAction)othersAction:(id)sender;
- (IBAction)shufferAction:(id)sender;

- (void)playFMFMusicFromDic:(NSDictionary *)dictionary;

@end
