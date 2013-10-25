//
//  PSAMusicLoginViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-10-14.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicLoginViewController.h"
#import "UIView+FadeInOut.h"

#define kPSAMusicLoginViewControllerNibName @"PSAMusicLoginViewController"

@interface PSAMusicLoginViewController ()

@end

@implementation PSAMusicLoginViewController
@synthesize bgImageView,loginAlertView;

+ (PSAMusicLoginViewController *)createMusicLoginViewController
{
    return [[PSAMusicLoginViewController alloc] initWithNibName:kPSAMusicLoginViewControllerNibName bundle:nil];
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
    [loginAlertView setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    [self bgFadeIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark IBAction Method

- (IBAction)okAction:(id)sender {
    [self bgFadeOut];
}

#pragma mark Public Method

- (void)bgFadeIn
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2f];
    [bgImageView setAlpha:0.6f];
    [UIView commitAnimations];
    [self performSelector:@selector(addAlertView) withObject:nil afterDelay:0.2f];
}

- (void)addAlertView
{
    [UIView animateWithDuration:0.3f animations:^{
        [loginAlertView setY:195];
    }];
}

- (void)bgFadeOut
{
    [UIView animateWithDuration:0.3f animations:^{
        [loginAlertView setY:-224];
    }completion:^(BOOL finished){
        [bgImageView fadeOut:0.3f];
        [self performSelector:@selector(removeView) withObject:nil afterDelay:0.3f];
    }];
}

- (void)removeView
{
    [self.view removeFromSuperview];
}

@end
