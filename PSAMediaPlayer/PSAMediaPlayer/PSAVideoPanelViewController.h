//
//  VideoPanelViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-15.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import "PSAVideoDeviceViewController.h"
//#import "PSAVideoDVDViewController.h"
//#import "PSAVideoNowPlayingViewController.h"
//#import "PSAVideoYoukuViewController.h"
//#import "PSAVideoLoginViewController.h"

@interface PSAVideoPanelViewController : UIViewController/*<PSAFunctionViewControllerProtocol,VideoNowPlayingDelegate,VideoYoukuDelegate>*/{
    UIColor *selectedColor;
    UIImage *screenShot;
    UIView *shadowView;
}

@property (weak, nonatomic) IBOutlet UIButton *dvdButton;
@property (weak, nonatomic) IBOutlet UIButton *deviceButton;
@property (weak, nonatomic) IBOutlet UIButton *youkuButton;

@property (weak, nonatomic) IBOutlet UIView *segmentView;

//@property (strong ,nonatomic) PSAVideoNowPlayingViewController *videoNowPlayingViewController;
//@property (strong ,nonatomic) PSAVideoDeviceViewController *videoDeviceViewController;
//@property (strong ,nonatomic) PSAVideoDVDViewController *videoDVDViewController;
//@property (strong, nonatomic) PSAVideoYoukuViewController *videoYoukuViewController;
//@property (strong, nonatomic) PSAVideoLoginViewController *videoLoginViewController;

- (IBAction)switchVideoSourceAction:(id)sender;

+ (PSAVideoPanelViewController *)createVideoViewController;

@end
