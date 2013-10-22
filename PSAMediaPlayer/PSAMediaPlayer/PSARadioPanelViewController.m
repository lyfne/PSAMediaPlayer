//
//  RadioPanelViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-15.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSARadioPanelViewController.h"
#import "PSAMusicPlayer.h"
#import "PSARadioPlayer.h"
#import "PSAMusicConstantsConfig.h"
#import "PSARadioConstantsConfig.h"

#define kPSARadioPanelViewControllerNibName @"PSARadioPanelViewController"

#define kNowPlayingAnimationTime 0.3f

typedef enum {
    PSARADIO_MYSTATION = 2001,
    PSARADIO_INTERNET = 2002,
} PSARADIOID;

@interface PSARadioPanelViewController ()

@property (strong, nonatomic) NSMutableArray *favoriteList;
@property (nonatomic) PSARADIOID currentPanelID;

@end

@implementation PSARadioPanelViewController
@synthesize segmentView;
@synthesize myStationButton,internetButton,fromMyFriendsButton;

+ (PSARadioPanelViewController *)createRadioViewController
{
    return [[PSARadioPanelViewController alloc] initWithNibName:kPSARadioPanelViewControllerNibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentPanelID = PSARADIO_MYSTATION;
        self.view.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[[PSARadioPlayer sharedPSARadioPlayer] getNowPlayingRadio] isEqualToString:@"F89.2"]) {
        if ([[PSAMusicPlayer sharedPSAMusicPlayer] getMusicPlayerState] == kMusicPlayerStateStop) {
            [self playRadio:@"89.2"];
            //[self.radioNowPlayingSegmentViewController.playButton setImage:[UIImage imageNamed:@"Radio_stop.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunchedRadio"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunchedRadio"];
       [self initPlist];
    }
    [self initResourceAndFavoriteList];
    [self initAllView];
    showFMF = NO;
    [self.view addSubview:[self panelViewWithID:self.currentPanelID].view];
    [[PSARadioPlayer sharedPSARadioPlayer] prepareRadioPlayer];
    myStationButton.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setSegmentView:nil];
    [self setMyStationButton:nil];
    [self setInternetButton:nil];
    [self setFromMyFriendsButton:nil];
    [super viewDidUnload];
}

#pragma mark Init Method

- (void)initAllView
{
//    self.radioNowPlayingSegmentViewController = [PSARadioNowPlayingSegmentViewController createRadioNowPlayingSegmentViewController];
//    [self.radioNowPlayingSegmentViewController.view setX:0 Y:475];
//    self.radioNowPlayingSegmentViewController.delegate = self;
//    [self.radioNowPlayingSegmentViewController.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
//    [self.view addSubview:self.radioNowPlayingSegmentViewController.view];
    
    self.radioMyStationViewController = [PSARadioMyStationViewController createRadioMyStationViewController];
    [self.radioMyStationViewController.view setY:47];
    [self.radioMyStationViewController.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    self.radioMyStationViewController.delegate = self;

    self.radioInternetViewController = [PSARadioInternetViewController createRadioInternetViewController];
    [self.radioInternetViewController.view setY:47];
    [self.radioInternetViewController.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
}

- (void)initResourceAndFavoriteList
{
    resourcePath = [[NSBundle mainBundle] pathForResource:@"RadioFMList" ofType:@"plist"] ;
    resourceDictionary = [NSDictionary dictionaryWithContentsOfFile:resourcePath];
    valueArray = [[NSArray alloc] initWithObjects:@"89.2",@"93.7",@"97.9",@"101.5",@"107.7",nil];
}

- (void)initPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RadioFMList" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPathInDoc = [paths objectAtIndex:0];
    NSString *finishedPath =[plistPathInDoc stringByAppendingPathComponent:@"RadioFMList.plist"];

    [data writeToFile:finishedPath atomically:YES];
}

#pragma mark IBAction Method

- (IBAction)switchRadioSourceAction:(id)sender {
    [self disableButton];
    UIButton *btn = (UIButton *)sender;
    [self setSelectedButton:btn];
}

#pragma mark Mini Function

- (UIViewController *)panelViewWithID:(PSARADIOID)panelId
{
    switch (panelId) {
        case PSARADIO_MYSTATION:
            return self.radioMyStationViewController;
            break;
        case PSARADIO_INTERNET:
            return self.radioInternetViewController;
            break;
        default:
            break;
    }
    return nil;
}

- (void)loadViewWithTag:(int)tag
{
    if (tag != self.currentPanelID) {
        if (tag < self.currentPanelID) {
            UIViewController *newPanel = [self panelViewWithID:tag];
            UIViewController *currentPanel = [self panelViewWithID:self.currentPanelID];
            [newPanel.view setX:-916];
            [newPanel.view setHeight:currentPanel.view.frame.size.height];
            [self.view addSubview:newPanel.view];
            self.currentPanelID = tag;
            
            [UIView animateWithDuration:kPSAAnimationDefaultDuration animations:^{
                [newPanel.view setX:0];
                [currentPanel.view setX:916];
            } completion:^(BOOL finished) {
                [currentPanel.view removeFromSuperview];
                [self enableButton];
            }];
        } else {
            UIViewController *newPanel = [self panelViewWithID:tag];
            UIViewController *currentPanel = [self panelViewWithID:self.currentPanelID];
            [newPanel.view setX:916];
            [newPanel.view setHeight:currentPanel.view.frame.size.height];
            [self.view addSubview:newPanel.view];
            self.currentPanelID = tag;
            
            [UIView animateWithDuration:kPSAAnimationDefaultDuration animations:^{
                [newPanel.view setX:0];
                [currentPanel.view setX:-916];
            } completion:^(BOOL finished) {
                [currentPanel.view removeFromSuperview];
                [self enableButton];
            }];
        }
    }
}

- (void)disableButton
{
    segmentView.userInteractionEnabled = NO;
}

- (void)enableButton
{
    segmentView.userInteractionEnabled = YES;
}

- (void)resetAllColor
{
    for (int i = kRadioSegmentButtonTagBasic+1; i<kRadioSegmentButtonTagBasic+4; i++) {
        UIButton *btn = (UIButton *)[segmentView viewWithTag:i];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
    }
}

- (void)setSelectedButton:(UIButton *)button
{
    [self resetAllColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"PSASegmentButtonBackground.png"] forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    [self loadViewWithTag:button.tag];
}

- (void)playRadio:(NSString *)value
{
    [[PSARadioPlayer sharedPSARadioPlayer] stop];
    [[PSARadioPlayer sharedPSARadioPlayer] playRadio:value];
}

#pragma mark PSAFunctionViewControllerProtocol

//- (void)panelWillAppear
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitRadio:) name:kExitFunctionPanel object:nil];
//}

//- (void)exitRadio:(NSNotification *)notification
//{
//    NSDictionary *object = [notification userInfo];
//    if ([[object objectForKey:@"id"] intValue] == PSAIDRADIO){
//        [[PSARadioPlayer sharedPSARadioPlayer] setRadioPlayerState:kRadioPlayerStateStop];
//        [[PSARadioPlayer sharedPSARadioPlayer] pause];
//    }
//}

#pragma mark RadioNowPlayingSegmentDelegate

- (void)resetMyStation
{
    [self.radioMyStationViewController resetMyStation];
}

#pragma mark RadioNowPlayingDelegate

- (void)resumePlay
{
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] getMusicPlayerState] == kMusicPlayerStatePlaying) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] pauseMusic];
    }

    [[PSARadioPlayer sharedPSARadioPlayer] setRadioPlayerState:kRadioPlayerStatePlaying];
    [[PSARadioPlayer sharedPSARadioPlayer] play];
}

- (void)pausePlay
{
    [[PSARadioPlayer sharedPSARadioPlayer] setRadioPlayerState:kRadioPlayerStateStop];
    [[PSARadioPlayer sharedPSARadioPlayer] pause];
}

- (BOOL)isPlayingOrNot
{
    return [PSARadioPlayer sharedPSARadioPlayer].isPlaying;
}

#pragma mark MyStationDelegate

- (void)playRadioWithValue:(NSString *)value
{
    if (![[[PSARadioPlayer sharedPSARadioPlayer] getNowPlayingRadio] isEqualToString:value]) {
        [[PSARadioPlayer sharedPSARadioPlayer] stop];
        [self playRadio:value];
        
        //[self.radioNowPlayingSegmentViewController scrollToPlayingStation:value animate:YES];
    }
}

@end
