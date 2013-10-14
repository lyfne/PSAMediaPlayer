//
//  VideoPanelViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-15.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAVideoPanelViewController.h"
#import "PSAVideoConstantsConfig.h"
#import "PSARadioConstantsConfig.h"
#import "PSAMusicConstantsConfig.h"
#import "PSARadioPlayer.h"
#import "PSAMusicPlayer.h"
#import "UIView+FadeInOut.h"

#define kPSAVideoPanelViewControllerNibName @"PSAVideoPanelViewController"

typedef enum {
    PSAVIDEO_DVD = 3001,
    PSAVIDEO_DEVICE = 3002,
    PSAVIDEO_YOUKU = 3003,
} PSAVIDEOID;

@interface PSAVideoPanelViewController ()

@property (nonatomic) PSAVIDEOID currentPanelID;

@end

@implementation PSAVideoPanelViewController
@synthesize segmentView;
@synthesize dvdButton,deviceButton,youkuButton;

+ (PSAVideoPanelViewController *)createVideoViewController
{
    return [[PSAVideoPanelViewController alloc] initWithNibName:kPSAVideoPanelViewControllerNibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentPanelID = PSAVIDEO_DEVICE;
        self.view.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunchedVideo"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunchedVideo"];
        [self initPlist];
        [self initResource];
    }
    
    deviceButton.userInteractionEnabled = NO;
    selectedColor = deviceButton.titleLabel.textColor;
    
    [self initAllView];
    [self.view addSubview:[self panelViewWithID:self.currentPanelID].view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initAllView
{
    self.videoDVDViewController = [PSAVideoDVDViewController createVideoDVDViewController];
    [self.videoDVDViewController.view setY:46];
    [self.videoDVDViewController.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    [self.videoDVDViewController setTimeColor:selectedColor];
    
    self.videoDeviceViewController = [PSAVideoDeviceViewController createVideoDeviceViewController];
    [self.videoDeviceViewController.view setY:46];
    [self.videoDeviceViewController.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    
    self.videoYoukuViewController = [PSAVideoYoukuViewController createVideoYoukuViewController];
    [self.videoYoukuViewController.view setY:46];
    self.videoYoukuViewController.delegate = self;
    [self.videoYoukuViewController.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(-54, 0, 1024, 614)];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0;
}

- (void)initPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"VideoResourceList" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPathInDoc = [paths objectAtIndex:0];
    NSString *finishedPath =[plistPathInDoc stringByAppendingPathComponent:@"VideoResourceList.plist"];
    
    [data writeToFile:finishedPath atomically:YES];
}

- (void)initResource
{
    NSArray *paths;
    NSString *plistPathInDoc;
    NSString *achievementFinishedPath;
    NSArray *nameArray = [[NSArray alloc] initWithObjects:@"Disk1",@"Disk2",@"Gaptain America",@"The Hunger Games",nil];
    
    for (int i=0; i<4; i++) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:[nameArray objectAtIndex:i] ofType:@"mp4"];
        
        paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        plistPathInDoc = [paths objectAtIndex:0];
        
        achievementFinishedPath =[plistPathInDoc stringByAppendingPathComponent:[[nameArray objectAtIndex:i] stringByAppendingString:@".mp4"]];
        NSData *data = [NSData dataWithContentsOfFile:plistPath];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager createFileAtPath:achievementFinishedPath contents:data attributes:nil];
    }
}

#pragma mark IBAction Method

- (IBAction)switchVideoSourceAction:(id)sender
{
    [self disableButton];
    UIButton *btn = (UIButton *)sender;
    [self setSelectedButton:btn];
}

#pragma mark Mini Function

- (UIViewController *)panelViewWithID:(PSAVIDEOID)panelId
{
    switch (panelId) {
        case PSAVIDEO_DVD:
            return self.videoDVDViewController;
            break;
        case PSAVIDEO_DEVICE:
            return self.videoDeviceViewController;
            break;
        case PSAVIDEO_YOUKU:
            return self.videoYoukuViewController;
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
    for (int i = kVideoSegmentButtonTagBasic+1; i<kVideoSegmentButtonTagBasic+5; i++) {
        UIButton *btn = (UIButton *)[segmentView viewWithTag:i];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.alpha = 0.4f;
        btn.userInteractionEnabled = YES;
    }
}

- (void)switchVideo:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    NSString *object = [dic objectForKey:kVideoUserInfo];
    
    self.view.clipsToBounds = NO;
    [self.view addSubview:shadowView];
    [shadowView fadeIn:0.7f];
    [self performSelector:@selector(addVideoView:) withObject:object afterDelay:0.5f];
}

- (void)addVideoView:(id)object
{
//    self.videoNowPlayingViewController = [PSAVideoNowPlayingViewController createVideoNowPlayingViewController];
//    [self.videoNowPlayingViewController.view setX:0 Y:0];
//    self.videoNowPlayingViewController.delegate = self;
//    [self.view setWidth:1024];
//    [self.view setX:0];
//    [self.view addSubview:self.videoNowPlayingViewController.view];
//    [self.videoNowPlayingViewController initPlayerController:(NSString *)object];
}

- (void)setSelectedButton:(UIButton *)button
{
    [self resetAllColor];
    [button setTitleColor:selectedColor forState:UIControlStateNormal];
    button.alpha = 1;
    button.userInteractionEnabled = NO;
    [self loadViewWithTag:button.tag];
}

#pragma VideoNowPlayingDelegate

- (void)resetToNormalSize
{
//    [self.videoNowPlayingViewController.view removeFromSuperview];
//    [self.view setX:54];
//    [self.view setWidth:916];
//    [shadowView fadeOut:0.7f];
//    [self performSelector:@selector(backToNormal) withObject:nil afterDelay:0.5f];
}

- (void)backToNormal
{
    self.view.clipsToBounds = YES;
}

#pragma mark VideoYoukuDelegate

- (void)addLoginView
{
    self.videoLoginViewController = [PSAVideoLoginViewController createVideoLoginViewController];
    [self.videoLoginViewController.view setX:0 Y:0];
    [self.view addSubview:self.videoLoginViewController.view];
}

@end
