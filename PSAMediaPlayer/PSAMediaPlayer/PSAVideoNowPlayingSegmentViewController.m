//
//  PSAVideoNowPlayingSegmentViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAVideoNowPlayingSegmentViewController.h"

#define kPSAVideoNowPlayingSegmentViewControllerNibName @"PSAVideoNowPlayingSegmentViewController"

@interface PSAVideoNowPlayingSegmentViewController ()

@end

@implementation PSAVideoNowPlayingSegmentViewController
@synthesize videoSlider;
@synthesize playButton,quickNextButton,quickPreButton;
@synthesize sunTimeLabel,currentTimeLabel;

+ (PSAVideoNowPlayingSegmentViewController *)createVideoNowPlayingSegmentViewController
{
    return [[PSAVideoNowPlayingSegmentViewController alloc] initWithNibName:kPSAVideoNowPlayingSegmentViewControllerNibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initSlider
{
    videoSlider.maximumValue=100;
    videoSlider.minimumValue=0;
    videoSlider.value = 0;
    videoSlider.delegate = self;
    
    [videoSlider setThumbImage:[UIImage imageNamed:@"ProgressThumb.png"] forState:UIControlStateNormal];
    [videoSlider setThumbImage:[UIImage imageNamed:@"ProgressThumb.png"] forState:UIControlStateHighlighted];
    [videoSlider setMaximumTrackTintColor:[UIColor colorWithWhite:1 alpha:0.4f]];
    [videoSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    
    [videoSlider addTarget:self action:@selector(processTimerStop) forControlEvents:UIControlEventTouchDown];
}

#pragma mark NowPlayingDelegate

- (void)touchEnd
{
    [self.delegate stopTimer];
    currentTime=videoSlider.value/100 * videoDuration;
    [self.delegate playAtTime:currentTime];
}

-(void)processTimerStop
{
    [self.delegate stopTimer];
}

-(void)setSliderValue:(float)time
{
    currentTime = time;
    videoSlider.value= 100*currentTime/videoDuration;
    currentTimeLabel.text = [NSString stringWithFormat:@"%i:%.2i",([[NSString stringWithFormat:@"%f",currentTime] intValue] / 60),([[NSString stringWithFormat:@"%f",currentTime] intValue] % 60)];
}

- (void)setDuration:(float)duration
{
    sunTimeLabel.text = [NSString stringWithFormat:@"%i:%.2i",([[NSString stringWithFormat:@"%f",duration] intValue] / 60),([[NSString stringWithFormat:@"%f",duration] intValue] % 60)];
    videoDuration = duration;
}

#pragma mark IBAction Method

- (IBAction)backToMenuAction:(id)sender {
    [self.delegate backToMainView];
}

- (IBAction)playAction:(id)sender {
    if ([playButton.imageView.image isEqual:[UIImage imageNamed:@"PauseButton.png"]]) {
        [playButton setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        [self.delegate playPauseVideo:1];
    }else{
        [playButton setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
        [self.delegate playPauseVideo:2];
    }
}

- (IBAction)quickPreAction:(id)sender {
    [self.delegate stopTimer];
    currentTime=currentTime-10;
    [self.delegate playAtTime:currentTime];
}

- (IBAction)quickNextAction:(id)sender {
    [self.delegate stopTimer];
    currentTime=currentTime+10;
    [self.delegate playAtTime:currentTime];
}

@end
