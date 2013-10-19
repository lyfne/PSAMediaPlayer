//
//  PSAMainViewController.h
//  PSAMediaPlayer
//
//  Created by Fan's Mac on 13-10-8.
//  Copyright (c) 2013年 Fan's Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSAVideoPanelViewController.h"
#import "PSAMusicMainViewController.h"
#import "PSARadioPanelViewController.h"
#import "PSASettingPanelViewController.h"

@interface PSAMainViewController : UIViewController

@property (strong, nonatomic) PSAVideoPanelViewController *videoPanelVC;
@property (strong, nonatomic) PSAMusicMainViewController *musicMainVC;
@property (strong, nonatomic) PSARadioPanelViewController *radioPanelVC;
@property (strong, nonatomic) PSASettingPanelViewController *settingPanelVC;

- (IBAction)swtichMainViewAction:(id)sender;
+ (PSAMainViewController *)createMainViewController;
- (void)reloadImageWithID:(NSString *)wallpaperId;

@end
