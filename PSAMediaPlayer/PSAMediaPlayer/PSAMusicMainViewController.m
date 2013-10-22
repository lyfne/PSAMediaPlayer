//
//  PSAMusicMainViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-23.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicMainViewController.h"
#import "PSARadioPlayer.h"
#import "PSAMusicPlayer.h"
#import "PSAConstantConfig.h"
#import "PSAMusicConstantsConfig.h"
#import "PSARadioConstantsConfig.h"

#define kPSAMusicMainViewControllerNibName @"PSAMusicMainViewController"

#define kNowPlayingViewAnimationTime 0.3f

typedef enum {
    PSAMUSIC_LIST = 1001,
    PSAMUSIC_DVD = 1002,
    PSAMUSIC_DEVICE = 1003,
    PSAMUSIC_ONLINE = 1004,
    PSAMUSIC_FROMMYFRIEND = 1005,
} PSAMUSICID;

@interface PSAMusicMainViewController ()

@property (nonatomic) PSAMUSICID currentPanelID;

@end

@implementation PSAMusicMainViewController
@synthesize sourceView;
@synthesize listButton,dvdButton,deviceButton,onlineButton,fromMyFriendButton;

+ (PSAMusicMainViewController *)createMusicMainViewController
{
    return [[PSAMusicMainViewController alloc] initWithNibName:kPSAMusicMainViewControllerNibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentPanelID = PSAMUSIC_LIST;
        self.view.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[PSARadioPlayer sharedPSARadioPlayer] getRadioPlayerState] == kRadioPlayerStateStop && [[PSAMusicPlayer sharedPSAMusicPlayer] firstLoad] == YES) {
        //[[PSAMusicPlayer sharedPSAMusicPlayer] playMusic];
        [[PSAMusicPlayer sharedPSAMusicPlayer] firstLoadFinished];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAllView];
    [self.view addSubview:[self panelViewWithID:self.currentPanelID].view];
    //[self.view bringSubviewToFront:self.musicNowPlayingViewController.view];
    
    dispatch_queue_t locateQueue = dispatch_queue_create("Load Music", NULL);
    dispatch_async(locateQueue, ^{
        [[PSAMusicPlayer sharedPSAMusicPlayer] serialze];
        [[PSAMusicPlayer sharedPSAMusicPlayer] setNowPlayingSource:kNowPlayingSourceList];
        [[PSAMusicPlayer sharedPSAMusicPlayer] setPlayMode:kPlayModeOrder];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark IBACTION Method

- (IBAction)switchMusicSourceAction:(id)sender {
    [self disableButton];
    UIButton *btn = (UIButton *)sender;
    [self setSelectedButton:btn];
}

#pragma mark Init Function

- (void)initAllView
{
//    self.musicNowPlayingViewController = [PSAMusicNowPlayingViewController createMusicNowPlayingViewController];
//    [self.musicNowPlayingViewController.view setX:0 Y:kPSAMusicNowPlayingVCY];
//    [self.view addSubview:self.musicNowPlayingViewController.view];
    
    self.musicListViewController = [PSAMusicListViewController createMusicListViewController];
    [self.musicListViewController.view setY:kPSAMusicPanelViewY];
    [self.musicListViewController.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    self.musicListViewController.delegate = self;

//    self.musicDVDViewController = [PSAMusicDVDViewController createMusicDVDViewController];
//    [self.musicDVDViewController.view setY:kPSAMusicPanelViewY];
//    self.musicDVDViewController.delegate = self.musicNowPlayingViewController;
//    [self.musicDVDViewController.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
//    
//    self.musicDeviceViewController = [PSAMusicDeviceViewController createMusicDeviceViewController];
//    [self.musicDeviceViewController.view setY:kPSAMusicPanelViewY];
//    [self.musicDeviceViewController.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
//    
//    self.musicOnlineViewController = [PSAMusicOnlineViewController createMusicOnlineViewController];
//    [self.musicOnlineViewController.view setY:kPSAMusicPanelViewY];
//    [self.musicOnlineViewController.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
//    self.musicOnlineViewController.delegate = self;
}

#pragma mark Mini Function

- (UIViewController *)panelViewWithID:(PSAMUSICID)panelId
{
    switch (panelId) {
        case PSAMUSIC_LIST:
            return self.musicListViewController;
            break;
//        case PSAMUSIC_DVD:
//            return self.musicDVDViewController;
//            break;
//        case PSAMUSIC_DEVICE:
//            return self.musicDeviceViewController;
//            break;
//        case PSAMUSIC_ONLINE:
//            return self.musicOnlineViewController;
//        case PSAMUSIC_FROMMYFRIEND:
//            return self.musicFromMyFriendViewController;
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
                //[self.view bringSubviewToFront:self.musicNowPlayingViewController.view];
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
                //[self.view bringSubviewToFront:self.musicNowPlayingViewController.view];
            }];
        }
    }
}

- (void)disableButton
{
    sourceView.userInteractionEnabled = NO;
}

- (void)enableButton
{
    sourceView.userInteractionEnabled = YES;
}

- (void)resetAllColor
{
    for (int i = kMusicSegmentButtonTagBasic+1; i<kMusicSegmentButtonTagBasic+6; i++) {
        UIButton *btn = (UIButton *)[sourceView viewWithTag:i];
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

#pragma mark MusicListDelegate

- (void)addCreateView
{
//    self.musicCreateListViewController = [PSAMusicCreateListViewController createMusicCreateListViewController];
//    [self.musicCreateListViewController.view setX:0 Y:0];
//    self.musicCreateListViewController.delegate = self.musicListViewController;
//    [self.view addSubview:self.musicCreateListViewController.view];
}

#pragma mark MusicOnLineDelegate

- (void)addLoginView
{
//    self.musicLoginViewController = [PSAMusicLoginViewController createMusicLoginViewController];
//    [self.musicLoginViewController.view setX:0 Y:0];
//    [self.view addSubview:self.musicLoginViewController.view];
}

@end
