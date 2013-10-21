//
//  PSAMusicMainViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-23.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PSAMusicOnlineViewController.h"
#import "PSAMusicListViewController.h"
//#import "PSAMusicDeviceViewController.h"
//#import "PSAMusicNowPlayingViewController.h"
//#import "PSAMusicDVDViewController.h"
//#import "PSAFunctionViewControllerProtocol.h"
//#import "PSAMusicCreateListViewController.h"
//#import "PSAMusicLoginViewController.h"

@interface PSAMusicMainViewController : UIViewController<MusicListDelegate>/*,MusicOnlineDelegate>*/{
    BOOL needInitNowPlayingView;
}

@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIButton *dvdButton;
@property (weak, nonatomic) IBOutlet UIButton *deviceButton;
@property (weak, nonatomic) IBOutlet UIButton *onlineButton;
@property (weak, nonatomic) IBOutlet UIButton *fromMyFriendButton;

@property (weak, nonatomic) IBOutlet UIView *sourceView;
//@property (strong, nonatomic) PSAMusicOnlineViewController *musicOnlineViewController;
@property (strong, nonatomic) PSAMusicListViewController *musicListViewController;
//@property (strong, nonatomic) PSAMusicDeviceViewController *musicDeviceViewController;
//@property (strong, nonatomic) PSAMusicNowPlayingViewController *musicNowPlayingViewController;
//@property (strong, nonatomic) PSAMusicDVDViewController *musicDVDViewController;
//@property (strong, nonatomic) PSAMusicCreateListViewController *musicCreateListViewController;
//@property (strong, nonatomic) PSAMusicLoginViewController *musicLoginViewController;

+ (PSAMusicMainViewController *)createMusicMainViewController;

- (IBAction)switchMusicSourceAction:(id)sender;

@end
