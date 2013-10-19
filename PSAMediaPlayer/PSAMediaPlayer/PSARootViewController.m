//
//  PSARootViewController.m
//  PSAMediaPlayer
//
//  Created by Fan's Mac on 13-10-16.
//  Copyright (c) 2013年 Fan's Mac. All rights reserved.
//

#import "PSARootViewController.h"
#import "UIImage+Blur.h"

@interface PSARootViewController ()

@end

@implementation PSARootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainVC = [PSAMainViewController createMainViewController];
    [self.mainVC.view setX:0 Y:77];
    [self.view addSubview:self.mainVC.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWallpaperWithID:) name:@"ChangeWallpaper" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)changeWallpaperWithID:(NSNotification *)notification
{
    CGRect frame = self.mainVC.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    NSDictionary *dic = [notification userInfo];
    UIImageView *screenshot = [[UIImageView alloc] initWithFrame:frame];
    screenshot.image = [UIImage screenshotOfView:self.mainVC.view];
    screenshot.backgroundColor = [UIColor blackColor];
    screenshot.frame = frame;
    [screenshot setContentMode:UIViewContentModeCenter];
    [self.mainVC.view addSubview:screenshot];
    
    UIView *loadingView;
    UIActivityIndicatorView *loadingSpinner;
    loadingView = [[UIView alloc] initWithFrame:frame];
    loadingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7];
    loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingSpinner setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
    [loadingView addSubview:loadingSpinner];
    
    [loadingSpinner startAnimating];
    loadingView.alpha = 0.0f;
    loadingView.frame = frame;
    [self.mainVC.view addSubview:loadingView];
    [UIView animateWithDuration:0.5 animations:^{
        loadingView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.mainVC reloadImageWithID:[dic objectForKey:@"id"]];
        [UIView animateWithDuration:0.5 delay:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            loadingView.alpha = 0.0f;
            screenshot.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [screenshot removeFromSuperview];
            [loadingSpinner stopAnimating];
            [loadingSpinner removeFromSuperview];
            [loadingView removeFromSuperview];
        }];
    }];
}


@end
