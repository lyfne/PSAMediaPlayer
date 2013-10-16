//
//  PSARootViewController.m
//  PSAMediaPlayer
//
//  Created by Fan's Mac on 13-10-16.
//  Copyright (c) 2013年 Fan's Mac. All rights reserved.
//

#import "PSARootViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
