//
//  PSAVideoNowPlayingViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAVideoNowPlayingViewController.h"
#import "PSAMusicPlayer.h"
#import "PSAMusicConstantsConfig.h"
#import "PSARadioPlayer.h"
#import "PSARadioConstantsConfig.h"
#import "UIView+FadeInOut.h"

#define kPSAVideoNowPlayingViewControllerNibName @"PSAVideoNowPlayingViewController"

@interface PSAVideoNowPlayingViewController ()

@end

@implementation PSAVideoNowPlayingViewController

+ (PSAVideoNowPlayingViewController *)createVideoNowPlayingViewController
{
    return [[PSAVideoNowPlayingViewController alloc] initWithNibName:kPSAVideoNowPlayingViewControllerNibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [processTimer invalidate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initControlView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initControlView
{
    self.videoNowPlayingSegmentViewController = [PSAVideoNowPlayingSegmentViewController createVideoNowPlayingSegmentViewController];
    [self.videoNowPlayingSegmentViewController.view setX:0 Y:504];
    self.videoNowPlayingSegmentViewController.delegate = self;
    [self.view addSubview:self.videoNowPlayingSegmentViewController.view];
    
    processTimer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(process) userInfo:nil repeats:YES];
}

- (void)initPlayerController:(NSString *)videoName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPathInDoc = [paths objectAtIndex:0];
    
    NSString *achievementFinishedPath =[plistPathInDoc stringByAppendingPathComponent:[videoName stringByAppendingFormat:@".mp4"]];
    
    if (achievementFinishedPath) {
        if ([[PSARadioPlayer sharedPSARadioPlayer] getRadioPlayerState] == kRadioPlayerStatePlaying) {
            [[PSARadioPlayer sharedPSARadioPlayer] setRadioPlayerState:kRadioPlayerStateStop];
            [[PSARadioPlayer sharedPSARadioPlayer] pause];
        }
        if ([[PSAMusicPlayer sharedPSAMusicPlayer] getMusicPlayerState] == kMusicPlayerStatePlaying) {
            [[PSAMusicPlayer sharedPSAMusicPlayer] pauseMusic];
        }
        
        NSURL *movieURL = [NSURL fileURLWithPath:achievementFinishedPath];
        moviePlayer = [[MPMoviePlayerController alloc]
                       initWithContentURL:movieURL];
        moviePlayer.controlStyle = MPMovieControlStyleNone;
        moviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:moviePlayer.view];
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 614)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [tapView addGestureRecognizer:tap];
        [self.view addSubview:tapView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
        
        [moviePlayer prepareToPlay];
        [moviePlayer play];
    }
    [self.view bringSubviewToFront:self.videoNowPlayingSegmentViewController.view];
    [self performSelector:@selector(hideSectionView) withObject:nil afterDelay:5.0f];
}

- (void)hideSectionView
{
    [self.videoNowPlayingSegmentViewController.view fadeOut:0.7f];
}

- (void)tap
{
    if (self.videoNowPlayingSegmentViewController.view.alpha == 1) {
        [self.videoNowPlayingSegmentViewController.view fadeOut:0.7f];
    }else{
        self.videoNowPlayingSegmentViewController.view.alpha = 1;;
    }
}

#pragma mark Mini Function

-(void)process
{
    [self.videoNowPlayingSegmentViewController setDuration:moviePlayer.duration];
    [self.videoNowPlayingSegmentViewController setSliderValue:moviePlayer.currentPlaybackTime];
}

-(void)movieFinish:(NSNotification*)notification
{
    NSNumber *finishReason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if ([finishReason intValue] == MPMovieFinishReasonPlaybackEnded)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
        [self backToMainView];
    }
}

- (void)stopVideo
{
    [moviePlayer stop];
}

#pragma mark VideoNowPlayingDelegate

- (void)backToMainView
{
    [moviePlayer stop];
    [self.delegate resetToNormalSize];
}

- (void)playPauseVideo:(int)sign
{
    if (sign==1) {
        [moviePlayer pause];
    }else{
        [moviePlayer play];
    }
}

- (void)playAtTime:(float)time
{
    [moviePlayer pause];
    [moviePlayer setCurrentPlaybackTime:time];
    [moviePlayer play];
    
    processTimer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(process) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    [processTimer invalidate];
}

@end
