//
//  PSAVideoYoukuViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-9-10.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAVideoYoukuViewController.h"

#define kPSAVideoYoukuViewControllerNibName @"PSAVideoYoukuViewController"

@interface PSAVideoYoukuViewController ()

@end

@implementation PSAVideoYoukuViewController
@synthesize videoImage1,videoImage2,videoImage3,videoImage4;

+ (PSAVideoYoukuViewController *)createVideoYoukuViewController
{
    return [[PSAVideoYoukuViewController alloc] initWithNibName:kPSAVideoYoukuViewControllerNibName bundle:nil];
}

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
    [self initShadow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initShadow
{
    [self addShadow:videoImage1];
    [self addShadow:videoImage2];
    [self addShadow:videoImage3];
    [self addShadow:videoImage4];
}

#pragma mark Mini Function

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
