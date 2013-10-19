//
//  SettingPanelViewController.m
//  pdemos1
//
//  Created by BuG.BS on 13-7-15.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSASettingPanelViewController.h"
#import "PSASettingSystemViewController.h"
#define kPSASettingPanelViewControllerNibName @"PSASettingPanelViewController"

typedef enum {
    PSASETTING_SYSTEM = 100,
    PSASETTING_INSTALLED = 101
} PSASETTINGID;

@interface PSASettingPanelViewController ()

@property (atomic) BOOL isInAnimation;

@property (strong, nonatomic) PSASettingSystemViewController *systemViewController;

@property (nonatomic) PSASETTINGID currentPanelID;
@property (strong, nonatomic) NSDictionary *contactsList;

@property (weak, nonatomic) IBOutlet UIButton *systemButton;

@end

@implementation PSASettingPanelViewController

+ (PSASettingPanelViewController *)createPSASettingPanelViewController
{
    return [[PSASettingPanelViewController alloc] initWithNibName:kPSASettingPanelViewControllerNibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentPanelID = PSASETTING_SYSTEM;
        self.isInAnimation = NO;
        [self initAllPanel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.systemViewController.view];
    self.systemButton.selected = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initAllPanel
{
    self.systemViewController = [PSASettingSystemViewController createSettingSystemViewController];
    self.systemViewController.view.frame = CGRectMake(0, 45, 916, 568);
    [self.systemViewController.view setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
}

//- (void)panelDidDismiss
//{
//    PSALOG(@"Panel: SETTINGS did dismiss.");
//    
//    NSDictionary *userInfo = @{@"id":[NSNumber numberWithInt:PSAIDSETTINGS]};
//    [[NSNotificationCenter defaultCenter] postNotificationName:kExitFunctionPanel object:nil userInfo:userInfo];
//    
//    PSALOG(@"Panel: SETTINGS exit.");
//}

@end
