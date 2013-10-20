//
//  PSAMusicCreateListViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-10-13.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicCreateListViewController.h"
#import "UIView+FadeInOut.h"
#import "PSAMusicPlayer.h"

#define kPSAMusicCreateListViewControllerNibName @"PSAMusicCreateListViewController"

@interface PSAMusicCreateListViewController ()

@end

@implementation PSAMusicCreateListViewController
@synthesize bgImageView,createAlertView;
@synthesize listNameTextField;
@synthesize okButton,cancelButton;

+ (PSAMusicCreateListViewController *)createMusicCreateListViewController
{
    return [[PSAMusicCreateListViewController alloc] initWithNibName:kPSAMusicCreateListViewControllerNibName bundle:nil];
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
    [self initView];
    [self bgFadeIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initView
{
    backToUpside = YES;
    [listNameTextField setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    listNameTextField.delegate = self;
    okButton.exclusiveTouch = YES;
    cancelButton.exclusiveTouch = YES;
}

#pragma mark IBAction Method

- (IBAction)okAction:(id)sender {
    if (![listNameTextField.text isEqualToString:@""]) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] createNewList:listNameTextField.text];
        [self.delegate ListReloadData];
    }
    [self bgFadeOut];
}

- (IBAction)cancelAction:(id)sender {
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
        [createAlertView setY:89];
    }completion:^(BOOL finished){
        [listNameTextField becomeFirstResponder];
    }];
}

- (void)bgFadeOut
{
    [UIView animateWithDuration:0.3f animations:^{
        [createAlertView setY:-224];
    }completion:^(BOOL finished){
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3f];
        [bgImageView setAlpha:0.0f];
        [UIView commitAnimations];
        
        [self performSelector:@selector(removeView) withObject:nil afterDelay:0.3f];
    }];
}

- (void)removeView
{
    [self.view removeFromSuperview];
}

#pragma mark TextfieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3f animations:^{
        [createAlertView setY:89];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3f animations:^{
        [createAlertView setY:195];
    }];
}

@end
