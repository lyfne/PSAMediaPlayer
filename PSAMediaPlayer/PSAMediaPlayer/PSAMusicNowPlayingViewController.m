//
//  PSAMusicNowPlayingViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-24.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicNowPlayingViewController.h"
#import "PSAMusicPlayer.h"
#import "PSAMusicConstantsConfig.h"
#import "UIView+FadeInOut.h"
//#import "PSAShareMusicCell.h"
#import "PSARadioPlayer.h"
#import "PSARadioConstantsConfig.h"

#define kPSAMusicNowPlayingViewControllerNibName @"PSAMusicNowPlayingViewController"

#define kDiskTag 2002
#define kAlbumTag 2001

#define kAnimationTime 0.3f
#define kButtonViewFadeTime 0.05f
#define kBGImageFadeTime 0.15f

@interface PSAMusicNowPlayingViewController ()

@end

@implementation PSAMusicNowPlayingViewController
@synthesize songLabel,singerLabel,albumLabel,timeLabel,nowPlayingLabel,tunesSumLabel;
@synthesize progressSlider;
@synthesize rotateImageView;
@synthesize playButton,preButton,nextButton,otherButton,playModeButton,diskButton;
@synthesize albumButton;
@synthesize buttonView,labelView,diskView;
@synthesize bgImageView;

+ (PSAMusicNowPlayingViewController *)createMusicNowPlayingViewController
{
    return [[PSAMusicNowPlayingViewController alloc] initWithNibName:kPSAMusicNowPlayingViewControllerNibName bundle:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSwitchSongNotifySign object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOptionalViewSwitchSongNotifySign object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFMFViewSwitchSongNotifySign object:nil];
    [processTimer invalidate];
    [self stopAnimation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchSong) name:kSwitchSongNotifySign object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchSong:) name:kOptionalViewSwitchSongNotifySign object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFMFMusic:) name:kFMFViewSwitchSongNotifySign object:nil];
    processTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(process) userInfo:nil repeats:YES];
    [[PSAMusicPlayer sharedPSAMusicPlayer] setMusicViewState:kNormalState];
    [self initImageAndButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSlider];
    [self initMusic];
    [self initAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initImageAndButton
{
    nowPlayingLabel.text = [NSString stringWithFormat:@"%d",[[PSAMusicPlayer sharedPSAMusicPlayer] currentTune]+1];
    tunesSumLabel.text = [NSString stringWithFormat:@"/%d",[[PSAMusicPlayer sharedPSAMusicPlayer] getSongCount]];
    
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] getNowPlayingSource]==kNowPlayingSourceDVD) {
        albumButton.hidden = YES;
        [rotateImageView stopAnimating];
    }else{
        albumButton.hidden = NO;
        [rotateImageView startAnimating];
        [albumButton setImage:[UIImage imageNamed:[[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentTune].albumName stringByAppendingFormat:@"Small.png"]] forState:UIControlStateNormal];
    }
    
    if([[PSAMusicPlayer sharedPSAMusicPlayer] getMusicPlayerState] == kMusicPlayerStatePlaying){
        [playButton setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
        [self startAnimation];
    }else{
        [playButton setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        [self stopAnimation];
    }
    
    switch ([[PSAMusicPlayer sharedPSAMusicPlayer] getPlayMode]) {
        case kPlayModeOrder:
            [playModeButton setImage:[UIImage imageNamed:@"CircleButton.png"] forState:UIControlStateNormal];
            break;
        case kPlayModeShuffle:
            [playModeButton setImage:[UIImage imageNamed:@"ShuffleButton.png"] forState:UIControlStateNormal];
            break;
        case kPlayModeCycle:
            [playModeButton setImage:[UIImage imageNamed:@"CircleSingleButton.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [self process];
    [self setSongName:[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentTune]];
    timeLabel.text = [NSString stringWithFormat:@"%i:%.2i",([[NSString stringWithFormat:@"%f",[PSAMusicPlayer sharedPSAMusicPlayer].duration] intValue] / 60),([[NSString stringWithFormat:@"%f",[PSAMusicPlayer sharedPSAMusicPlayer].duration] intValue] % 60)];
}

- (void)initMusic
{
    [self loadMusicWithTunesList:[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentList]];
}

- (void)initSlider
{
    progressSlider.maximumValue=100;
    progressSlider.minimumValue=0;
    progressSlider.continuous=YES;
    [progressSlider setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    progressSlider.delegate = self;
    
    [progressSlider setThumbImage:[UIImage imageNamed:@"ProgressThumb.png"] forState:UIControlStateNormal];
    [progressSlider setThumbImage:[UIImage imageNamed:@"ProgressThumb.png"] forState:UIControlStateHighlighted];
    [progressSlider setMaximumTrackTintColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
    [progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    
    [progressSlider addTarget:self action:@selector(processTimerStop) forControlEvents:UIControlEventTouchDown];
}

- (void)initAnimation
{
    [bgImageView setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    labelView.clipsToBounds = NO;
}

#pragma mark IBAction Method

- (IBAction)nextTuneAction:(id)sender {
    BOOL playFlag;
    if([PSAMusicPlayer sharedPSAMusicPlayer].playing){
        playFlag=YES;
        [[PSAMusicPlayer sharedPSAMusicPlayer] stop];
    }else{
        playFlag=NO;
    }
    
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] setShufflePlayIndex:[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayIndex]+1]>[[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayArray] count]-1) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] setShufflePlayIndex:0];
    }
    [[PSAMusicPlayer sharedPSAMusicPlayer] setTuneIndex:[[[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayArray] objectAtIndex:[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayIndex]] intValue]];
    
    [self loadMusicWithTunesList:[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentList]];
    
    if(playFlag==YES){
        [[PSAMusicPlayer sharedPSAMusicPlayer] playMusic];
        [playButton setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)preTuneAction:(id)sender {
    BOOL playFlag;
    if([PSAMusicPlayer sharedPSAMusicPlayer].playing){
        playFlag=YES;
        [[PSAMusicPlayer sharedPSAMusicPlayer] stop];
    }else{
        playFlag=NO;
    }
    
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] setShufflePlayIndex:[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayIndex]-1]<0) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] setShufflePlayIndex:[[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayArray] count]-1];
    }
    [[PSAMusicPlayer sharedPSAMusicPlayer] setTuneIndex:[[[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayArray] objectAtIndex:[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayIndex]] intValue]];
    
    [self loadMusicWithTunesList:[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentList]];
    
    if(playFlag==YES){
        [[PSAMusicPlayer sharedPSAMusicPlayer] playMusic];
        [playButton setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)playAndStopAction:(id)sender {
    if( [[PSAMusicPlayer sharedPSAMusicPlayer] isPlaying]){
        [playButton setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        [[PSAMusicPlayer sharedPSAMusicPlayer] pauseMusic];
        rotateState = kStopState;
        [self stopAnimation];
    }else{
        [playButton setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
        [[PSAMusicPlayer sharedPSAMusicPlayer] playMusic];
        rotateState = kRotateState;
        [self startAnimation];
    }
}

- (IBAction)othersAction:(id)sender {
    [[PSAMusicPlayer sharedPSAMusicPlayer] setOptionalViewMode:kOptionalViewNormalMode];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentTune]] forKeys:[NSArray arrayWithObject:kOptionalModelViewUserInfo]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddOptionalModelView object:self userInfo:dictionary];
}

- (IBAction)shufferAction:(id)sender {
    switch ([[PSAMusicPlayer sharedPSAMusicPlayer] getPlayMode]) {
        case kPlayModeOrder:{
            [[PSAMusicPlayer sharedPSAMusicPlayer] setPlayMode:kPlayModeShuffle];
            [[PSAMusicPlayer sharedPSAMusicPlayer] playShuffle];
            [playModeButton setImage:[UIImage imageNamed:@"ShuffleButton.png"] forState:UIControlStateNormal];
        }
            break;
        case kPlayModeShuffle:{
            [[PSAMusicPlayer sharedPSAMusicPlayer] setPlayMode:kPlayModeCycle];
            [[PSAMusicPlayer sharedPSAMusicPlayer] playCycle];
            [playModeButton setImage:[UIImage imageNamed:@"CircleSingleButton.png"] forState:UIControlStateNormal];
        }
            break;
        case kPlayModeCycle:{
            [[PSAMusicPlayer sharedPSAMusicPlayer] setPlayMode:kPlayModeOrder];
            [[PSAMusicPlayer sharedPSAMusicPlayer] playOrder];
            [playModeButton setImage:[UIImage imageNamed:@"CircleButton.png"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

#pragma mark Music Control

- (void)loadMusicWithTunesList:(PSATunesList *)list
{
    PSATune *tune = [[PSAMusicPlayer sharedPSAMusicPlayer] loadMusicWithTunesList:list withDelegate:self];
    [self setSongName:tune];
    nowPlayingLabel.text = [NSString stringWithFormat:@"%d",[[PSAMusicPlayer sharedPSAMusicPlayer] currentTune]+1];
    timeLabel.text = [NSString stringWithFormat:@"%i:%.2i",([[NSString stringWithFormat:@"%f",[PSAMusicPlayer sharedPSAMusicPlayer].duration] intValue] / 60),([[NSString stringWithFormat:@"%f",[PSAMusicPlayer sharedPSAMusicPlayer].duration] intValue] % 60)];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] setShufflePlayIndex:[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayIndex]+1]>[[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayArray] count]-1) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] setShufflePlayIndex:0];
    }
    [[PSAMusicPlayer sharedPSAMusicPlayer] setTuneIndex:[[[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayArray] objectAtIndex:[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayIndex]] intValue]];
    
    [self loadMusicWithTunesList:[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentList]];
    
    [[PSAMusicPlayer sharedPSAMusicPlayer] playMusic];
    //progressSlider.value = 2;
}

#pragma mark Slider Process Method

- (void)touchEnd
{
    processTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(process) userInfo:nil repeats:YES];
    
    //[PSAMusicPlayer sharedPSAMusicPlayer].currentTime=progressSlider.value/100*[PSAMusicPlayer sharedPSAMusicPlayer].duration;
    if([PSAMusicPlayer sharedPSAMusicPlayer].playing==YES)
        [[PSAMusicPlayer sharedPSAMusicPlayer] playAtTime:[PSAMusicPlayer sharedPSAMusicPlayer].currentTime];
}

-(void)processTimerStop
{
    [processTimer invalidate];
}

-(void)process
{
//    progressSlider.value = 100*[PSAMusicPlayer sharedPSAMusicPlayer].currentTime/[PSAMusicPlayer sharedPSAMusicPlayer].duration;
}

#pragma mark Mini Function

-(void) startAnimation
{
    rotateState = kRotateState;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.05f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    rotateImageView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation
{
    angle += 10;
    if (rotateState == kRotateState) {
        [self startAnimation];
    }
}

- (void)stopAnimation
{
    rotateState = kStopState;
    [rotateImageView stopAnimating];
}

- (void)setSongName:(PSATune *)tune
{
    songLabel.text = tune.songName;
    singerLabel.text = tune.singerName;
    albumLabel.text = tune.albumName;
    [albumButton setImage:[UIImage imageNamed:[[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentTune].albumName stringByAppendingFormat:@"Small.png"]] forState:UIControlStateNormal];
}

- (void)switchSong
{
    if([PSAMusicPlayer sharedPSAMusicPlayer].playing){
        [[PSAMusicPlayer sharedPSAMusicPlayer] stop];
    }
    
    [self loadMusicWithTunesList:[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentList]];
    
    [[PSAMusicPlayer sharedPSAMusicPlayer] playMusic];
    [playButton setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];

    if ([[PSAMusicPlayer sharedPSAMusicPlayer] getNowPlayingSource]==kNowPlayingSourceDVD){
        albumButton.hidden = YES;
        [rotateImageView stopAnimating];
    }else{
        albumButton.hidden = NO;
        [rotateImageView startAnimating];
    }
}

- (void)switchSong:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    int index = [[dic objectForKey:kOptionalModelViewSwitchTuneUserInfo] intValue];
    [[PSAMusicPlayer sharedPSAMusicPlayer] playTuneAtIndex:[[[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayArray] objectAtIndex:index] intValue] withDelegate:self];
    
    [self setSongName:[[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentList] tuneAtIndex:[[[[PSAMusicPlayer sharedPSAMusicPlayer] getShufflePlayArray] objectAtIndex:index] intValue]]];
    timeLabel.text = [NSString stringWithFormat:@"%i:%.2i",([[NSString stringWithFormat:@"%f",[PSAMusicPlayer sharedPSAMusicPlayer].duration] intValue] / 60),([[NSString stringWithFormat:@"%f",[PSAMusicPlayer sharedPSAMusicPlayer].duration] intValue] % 60)];
    
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] getNowPlayingSource]==kNowPlayingSourceDVD) {
        albumButton.hidden = YES;
        [rotateImageView stopAnimating];
    }else{
        albumButton.hidden = NO;
        [rotateImageView startAnimating];
    }
    
    [playButton setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
}

- (void)playFMFMusic:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    [self playFMFMusicFromDic:dic];
}

#pragma mark PSADVDSwitchDelegate

- (void)switchDiskAtIndax:(int)index
{
    albumButton.hidden = YES;
    
    [[PSAMusicPlayer sharedPSAMusicPlayer] stop];
    [[PSAMusicPlayer sharedPSAMusicPlayer] setCurrentListWithIndex:index];
    [[PSAMusicPlayer sharedPSAMusicPlayer] resetTune];
    [self loadMusicWithTunesList:[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentList]];
    [[PSAMusicPlayer sharedPSAMusicPlayer] playMusic];
    
    [playButton setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
    if (rotateState == kStopState) {
        [self startAnimation];
    }
    
    [diskButton setTitle:[NSString stringWithFormat:@"Disk %d",index+1] forState:UIControlStateNormal];
    //progressSlider.value=2;
    tunesSumLabel.text = [NSString stringWithFormat:@"/%d",[[PSAMusicPlayer sharedPSAMusicPlayer] getSongCount]];
}

#pragma mark Public Method

- (void)playFMFMusicFromDic:(NSDictionary *)dictionary
{
    if ([[PSARadioPlayer sharedPSARadioPlayer] getRadioPlayerState] == kRadioPlayerStatePlaying) {
        [[PSARadioPlayer sharedPSARadioPlayer] setRadioPlayerState:kRadioPlayerStateStop];
        [[PSARadioPlayer sharedPSARadioPlayer] pause];
    }
    [[PSAMusicPlayer sharedPSAMusicPlayer] playTuneWithName:dictionary withDelegate:self];
    songLabel.text = [dictionary objectForKey:@"song"];
    singerLabel.text = [NSString stringWithFormat:@"From %@",[dictionary objectForKey:@"from"]];
    albumLabel.text = [dictionary objectForKey:@"album"];
    
    albumButton.hidden = NO;
    [rotateImageView startAnimating];
    [albumButton setImage:[UIImage imageNamed:[dictionary objectForKey:@"album"]] forState:UIControlStateNormal];
    
    [playButton setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
}

@end
