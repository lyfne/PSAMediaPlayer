//
//  PSAMusicOnlineViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-23.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicOnlineViewController.h"

#define kPSAMusicOnlineViewControllerNibName @"PSAMusicOnlineViewController"

@interface PSAMusicOnlineViewController ()

@end

@implementation PSAMusicOnlineViewController
@synthesize diskImage1,diskImage2,diskImage3,diskImage4,diskImage5;

+ (PSAMusicOnlineViewController *)createMusicOnlineViewController
{
    return [[PSAMusicOnlineViewController alloc] initWithNibName:kPSAMusicOnlineViewControllerNibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initShadow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initShadow
{
    [self addShadow:diskImage1];
    [self addShadow:diskImage2];
    [self addShadow:diskImage3];
    [self addShadow:diskImage4];
    [self addShadow:diskImage5];
}  

#pragma mark Mini Method

- (void)addShadow:(UIView *)view
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addLoginViewToMainView)];
    [view addGestureRecognizer:tapGesture];
    [view.layer setShadowOffset:CGSizeMake(0, 6)];
    [view.layer setShadowRadius:6];
    [view.layer setShadowOpacity:0.5f];
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
}

- (void)addLoginViewToMainView
{
    [self.delegate addLoginView];
}

@end
