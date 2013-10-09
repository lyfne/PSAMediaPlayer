//
//  PSAMainViewController.m
//  PSAMediaPlayer
//
//  Created by Fan's Mac on 13-10-8.
//  Copyright (c) 2013年 Fan's Mac. All rights reserved.
//

#import "PSAMainViewController.h"

@interface PSAMainViewController ()

@end

@implementation PSAMainViewController

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
    [self initVideo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Init Method

- (void)initVideo
{
    self.videoPanelVC = [PSAVideoPanelViewController createVideoViewController];
    [self.videoPanelVC.view setX:54 Y:77];
    [self.view addSubview:self.videoPanelVC.view];
}

@end
