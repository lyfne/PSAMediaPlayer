//
//  PSAMainViewController.m
//  PSAMediaPlayer
//
//  Created by Fan's Mac on 13-10-8.
//  Copyright (c) 2013年 Fan's Mac. All rights reserved.
//

#import "PSAMainViewController.h"

#define kMainSegmentButtonTagBasic 100
#define kPSAMainViewControllerNibName @"PSAMainViewController"

typedef enum {
    PSAMAIN_MUSIC = 101,
    PSAMAIN_RADIO = 102,
    PSAMAIN_VIDEO = 103,
    PSAMAIN_SETTING = 104
} PSAMAINID;

@interface PSAMainViewController ()

@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (nonatomic) PSAMAINID currentPanelID;
@property (weak, nonatomic) IBOutlet UIButton *musicButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation PSAMainViewController

+ (PSAMainViewController *)createMainViewController
{
    return [[PSAMainViewController alloc] initWithNibName:kPSAMainViewControllerNibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentPanelID = PSAMAIN_MUSIC;
        self.view.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAllView];
    self.musicButton.userInteractionEnabled = NO;
    [self.view addSubview:[self panelViewWithID:self.currentPanelID].view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initAllView
{
    self.musicMainVC = [PSAMusicMainViewController createMusicMainViewController];
    [self.musicMainVC.view setX:0 Y:0];
    [self.musicMainVC.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    
    self.videoPanelVC = [PSAVideoPanelViewController createVideoViewController];
    [self.videoPanelVC.view setX:0 Y:0];
    [self.videoPanelVC.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    
    self.radioPanelVC = [PSARadioPanelViewController createRadioViewController];
    [self.radioPanelVC.view setX:0 Y:77];
    [self.radioPanelVC.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    
    self.settingPanelVC = [PSASettingPanelViewController createPSASettingPanelViewController];
    [self.settingPanelVC.view setX:0 Y:77];
    [self.settingPanelVC.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
}

#pragma mark Mini Function

- (UIViewController *)panelViewWithID:(PSAMAINID)panelId
{
    switch (panelId) {
        case PSAMAIN_MUSIC:
            return self.musicMainVC;
            break;
        case PSAMAIN_RADIO:
            return self.radioPanelVC;
            break;
        case PSAMAIN_VIDEO:
            return self.videoPanelVC;
            break;
        case PSAMAIN_SETTING:
            return self.settingPanelVC;
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
            [newPanel.view setY:-614];
            [self.view addSubview:newPanel.view];
            self.currentPanelID = tag;
            
            [UIView animateWithDuration:kPSAAnimationDefaultDuration animations:^{
                [newPanel.view setY:0];
                [currentPanel.view setY:614];
            } completion:^(BOOL finished) {
                [currentPanel.view removeFromSuperview];
                [self enableButton];
            }];
        } else {
            UIViewController *newPanel = [self panelViewWithID:tag];
            UIViewController *currentPanel = [self panelViewWithID:self.currentPanelID];
            [newPanel.view setY:614];
            [self.view addSubview:newPanel.view];
            self.currentPanelID = tag;
            
            [UIView animateWithDuration:kPSAAnimationDefaultDuration animations:^{
                [newPanel.view setY:0];
                [currentPanel.view setY:-614];
            } completion:^(BOOL finished) {
                [currentPanel.view removeFromSuperview];
                [self enableButton];
            }];
        }
    }
}

- (void)disableButton
{
    self.segmentView.userInteractionEnabled = NO;
}

- (void)enableButton
{
    self.segmentView.userInteractionEnabled = YES;
}

- (void)setSelectedButton:(UIButton *)button
{
    [self resetAllColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    [self loadViewWithTag:button.tag];
}

- (void)reloadImageWithID:(NSString *)wallpaperId
{
    self.bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"kImageMainScreenWallpaperBlur20%@",wallpaperId]];
}

- (void)resetAllColor
{
    for (int i = kMainSegmentButtonTagBasic+1; i<kMainSegmentButtonTagBasic+5; ++i) {
        UIButton *btn = (UIButton *)[self.segmentView viewWithTag:i];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
    }
}

#pragma mark IBAction Method

- (IBAction)swtichMainViewAction:(id)sender {
    [self disableButton];
    UIButton *btn = (UIButton *)sender;
    [self setSelectedButton:btn];
}

@end
