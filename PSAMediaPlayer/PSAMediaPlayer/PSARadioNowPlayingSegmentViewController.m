//
//  PSARadioNowPlayingSegmentViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-7.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSARadioNowPlayingSegmentViewController.h"
#import "PSAMusicPlayer.h"
#import "PSAMusicConstantsConfig.h"
#import "PSARadioPlayer.h"
#import "PSARadioConstantsConfig.h"
#import "UIView+FadeInOut.h"

#define kPSARadioNowPlayingSegmentViewControllerNibName @"PSARadioNowPlayingSegmentViewController"

#define animationTime 0.3f
#define buttonViewFadeTime 0.05f
#define kBGImageFadeTime 0.15f
#define kSliderViewFrame CGRectMake(98, -11, sliderView.frame.size.width, sliderView.frame.size.height)

@interface PSARadioNowPlayingSegmentViewController ()

@end

@implementation PSARadioNowPlayingSegmentViewController
@synthesize fmValueLabel;
@synthesize touchView;
@synthesize buttonView;
@synthesize bgImageView;
@synthesize playButton,favoriteButton;

+ (PSARadioNowPlayingSegmentViewController *)createRadioNowPlayingSegmentViewController
{
    return [[PSARadioNowPlayingSegmentViewController alloc] initWithNibName:kPSARadioNowPlayingSegmentViewControllerNibName bundle:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSwitchRadioNotifySign object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddToFavoriteNotifySign object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [sliderView resetFavorite];
    [self initPlayButton];
    [self scrollToPlayingStation:[[PSARadioPlayer sharedPSARadioPlayer] getNowPlayingRadio] animate:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSlider];
    [self initLabelAndImage];
    [self initNotify];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initPlayButton
{
    if ([self isEqualToFavoriteStation:fmValueLabel.text] != 100){
        [favoriteButton setImage:[UIImage imageNamed: @"Radio_likes_selected.png"] forState:UIControlStateNormal];
    }else{
        [favoriteButton setImage:[UIImage imageNamed: @"Radio_likes.png"] forState:UIControlStateNormal];
    }
    
    if ([[PSARadioPlayer sharedPSARadioPlayer] getRadioPlayerState] == kRadioPlayerStatePlaying) {
        [playButton setImage:[UIImage imageNamed:@"Radio_stop.png"] forState:UIControlStateNormal];
    }else{
        [playButton setImage:[UIImage imageNamed:@"Radio_play.png"] forState:UIControlStateNormal];
    }
}

- (void)initLabelAndImage
{
    [bgImageView setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    [sliderView setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
}

- (void)initNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRadio:) name:kSwitchRadioNotifySign object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToFavorite) name:kAddToFavoriteNotifySign object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRadioFromFMF:) name:kFMFSwitchRadioNotifySign object:nil];
}

- (void)initSlider
{
    sliderView = [PSARadioSliderView createRadioSlider];
    [sliderView setType:kRadioNowPlayingSegmentType];
    sliderView.frame = kSliderViewFrame;
    sliderView.delegate = self;
    [self.view addSubview:sliderView];
}

#pragma mark IBAction Method

- (IBAction)preRadioAction:(id)sender {
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] getMusicPlayerState] == kMusicPlayerStatePlaying) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] pauseMusic];
    }
    [sliderView scrollToPre];
    if ([[PSARadioPlayer sharedPSARadioPlayer] getRadioPlayerState] == kRadioPlayerStatePlaying) {
        [playButton setImage:[UIImage imageNamed:@"Radio_stop.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)likeAction:(id)sender {
    [self addToFavorite];
}

- (IBAction)nextRadioAction:(id)sender {
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] getMusicPlayerState] == kMusicPlayerStatePlaying) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] pauseMusic];
    }
    [sliderView scrollToNext];
    if ([[PSARadioPlayer sharedPSARadioPlayer] getRadioPlayerState] == kRadioPlayerStatePlaying) {
        [playButton setImage:[UIImage imageNamed:@"Radio_stop.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)otherAction:(id)sender {
    NSNumber *num = [NSNumber numberWithInt:[[NSString stringWithFormat:@"%d",[sliderView getWhichStation]] intValue]];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:num] forKeys:[NSArray arrayWithObject:kOptionalModelViewUserInfo]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddOptionalModelView object:self userInfo:dictionary];
}

- (IBAction)stopPlayingAction:(id)sender {
    if ([self.delegate isPlayingOrNot]) {
        [self.delegate pausePlay];
        [playButton setImage:[UIImage imageNamed:@"Radio_play.png"] forState:UIControlStateNormal];
    }else if([sliderView isOnStation]&&![self.delegate isPlayingOrNot]){
        [self.delegate resumePlay];
        [playButton setImage:[UIImage imageNamed:@"Radio_stop.png"] forState:UIControlStateNormal];
    }
}

#pragma mark Mini Function

- (void)switchRadio:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *indexStr = [dic objectForKey:kOptionalCellIndexInfo];
    [sliderView scrollTo:indexStr animate:YES];
    [self.delegate pausePlay];
    [[PSARadioPlayer sharedPSARadioPlayer] stop];
    [[PSARadioPlayer sharedPSARadioPlayer] playRadio:indexStr];
    fmValueLabel.text = indexStr;
    [playButton setImage:[UIImage imageNamed:@"Radio_stop.png"] forState:UIControlStateNormal];
}

- (void)switchRadioFromFMF:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    [sliderView scrollTo:[dic objectForKey:@"radio"] animate:YES];
    [self.delegate pausePlay];
    [[PSARadioPlayer sharedPSARadioPlayer] stop];
    [[PSARadioPlayer sharedPSARadioPlayer] playRadio:[dic objectForKey:@"radio"]];
    fmValueLabel.text = [dic objectForKey:@"radio"];
    [playButton setImage:[UIImage imageNamed:@"Radio_stop.png"] forState:UIControlStateNormal];
}

- (void)switchRadioFromDic:(NSDictionary *)dic
{
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] getMusicPlayerState] == kMusicPlayerStatePlaying) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] pauseMusic];
    }
    [sliderView scrollTo:[dic objectForKey:@"radio"] animate:YES];
    [self.delegate pausePlay];
    [[PSARadioPlayer sharedPSARadioPlayer] stop];
    [[PSARadioPlayer sharedPSARadioPlayer] playRadio:[dic objectForKey:@"radio"]];
    fmValueLabel.text = [dic objectForKey:@"radio"];
    [playButton setImage:[UIImage imageNamed:@"Radio_stop.png"] forState:UIControlStateNormal];
}

- (int)isEqualToFavoriteStation:(NSString *)value
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPathInDoc = [paths objectAtIndex:0];
    NSString *finishedPath =[plistPathInDoc stringByAppendingPathComponent:@"RadioFMList.plist"];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:finishedPath];
    NSMutableDictionary *fmData = [data objectForKey:@"FM"];
    
    int newNum = [[fmData objectForKey:@"Num"] intValue];
    for (int i=0; i<newNum; ++i) {
        if ([value isEqualToString:[fmData objectForKey:[NSString stringWithFormat:@"%d",i+1]]]) {
            return i;
        }
    }
    return 100;
}

- (void)addToFavorite
{
    if ([sliderView isOnStation]) {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *plistPathInDoc = [paths objectAtIndex:0];
        NSString *finishedPath =[plistPathInDoc stringByAppendingPathComponent:@"RadioFMList.plist"];
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:finishedPath];
        NSMutableDictionary *fmData = [data objectForKey:@"FM"];
        
        int newNum = [[fmData objectForKey:@"Num"] intValue];
        
        if ([self isEqualToFavoriteStation:fmValueLabel.text] == 100) {
            [favoriteButton setImage:[UIImage imageNamed: @"Radio_likes_selected.png"] forState:UIControlStateNormal];
            [fmData setObject:[NSString stringWithFormat:@"%d",newNum+1] forKey:@"Num"];
            [fmData setObject:fmValueLabel.text forKey:[NSString stringWithFormat:@"%d",newNum+1]];
        }else if ([self isEqualToFavoriteStation:fmValueLabel.text] != 100){
            [favoriteButton setImage:[UIImage imageNamed: @"Radio_likes.png"] forState:UIControlStateNormal];
            int removeIndex = [self isEqualToFavoriteStation:fmValueLabel.text]+1;
            [fmData setObject:[NSString stringWithFormat:@"%d",newNum-1] forKey:@"Num"];
            [fmData removeObjectForKey:[NSString stringWithFormat:@"%d",removeIndex]];
            for (int i=removeIndex; i<newNum; ++i) {
                [fmData setObject:[fmData objectForKey:[NSString stringWithFormat:@"%d",i+1]] forKey:[NSString stringWithFormat:@"%d",i]];
                [fmData removeObjectForKey:[NSString stringWithFormat:@"%d",i+1]];
            }
        }
        
        [data setObject:fmData forKey:@"FM"];
        [data writeToFile:finishedPath atomically:YES];
        
        [self.delegate resetMyStation];
        [sliderView resetFavorite];
    }
}

#pragma mark Public Method

- (void)scrollToPlayingStation:(NSString *)value animate:(BOOL)animated
{
    if (animated == YES) {
        if ([[PSAMusicPlayer sharedPSAMusicPlayer] getMusicPlayerState] == kMusicPlayerStatePlaying) {
            [[PSAMusicPlayer sharedPSAMusicPlayer] pauseMusic];
        }
        [sliderView scrollTo:value animate:animated];
        [playButton setImage:[UIImage imageNamed:@"Radio_stop.png"] forState:UIControlStateNormal];
    }else{
        [sliderView scrollTo:value animate:animated];
    }
}

#pragma mark RadioSliderViewDelegate

- (int)getCurrentPanelID
{
    return 2000;
}

- (void)valueChanged:(float)value
{
    fmValueLabel.text = [NSString stringWithFormat:@"%.1f",value];
    if ([self isEqualToFavoriteStation:fmValueLabel.text] != 100){
        [favoriteButton setImage:[UIImage imageNamed: @"Radio_likes_selected.png"] forState:UIControlStateNormal];
    }else{
        [favoriteButton setImage:[UIImage imageNamed: @"Radio_likes.png"] forState:UIControlStateNormal];
    }
    [[PSARadioPlayer sharedPSARadioPlayer] setNowPlayingRadio:[NSString stringWithFormat:@"%.1f",value]];
}

- (void)playRadio:(NSString *)value
{
    [[PSARadioPlayer sharedPSARadioPlayer] stop];
    [[PSARadioPlayer sharedPSARadioPlayer] playRadio:value];
}

- (void)stopPlay
{
    [self.delegate pausePlay];
}

- (BOOL)isPlayingOrNot
{
    return [self.delegate isPlayingOrNot];
}

@end
