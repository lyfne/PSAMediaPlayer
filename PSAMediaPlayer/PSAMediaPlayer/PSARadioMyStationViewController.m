//
//  PSARadioMyStationViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-4.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSARadioMyStationViewController.h"
#import "PSAAppHeaderView.h"
#import "PSARadioConstantsConfig.h"
#import "UIView+Subview.h"

#define kPSARadioMyStationViewControllerNibName @"PSARadioMyStationViewController"

@interface PSARadioMyStationViewController ()

@end

@implementation PSARadioMyStationViewController
@synthesize scrollView;
@synthesize delegate;
@synthesize bgImageView;

+ (PSARadioMyStationViewController *)createRadioMyStationViewController
{
    return [[PSARadioMyStationViewController alloc] initWithNibName:kPSARadioMyStationViewControllerNibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self resetMyStation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initArrayAndDictionary];
    [self initHeaderAndTunes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initArrayAndDictionary
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPathInDoc = [paths objectAtIndex:0];
    NSString *finishedPath =[plistPathInDoc stringByAppendingPathComponent:@"RadioFMList.plist"];
    resourceDictionary = [NSDictionary dictionaryWithContentsOfFile:finishedPath];
    
    favoriteArray = [[NSMutableArray alloc] initWithObjects:nil];
}

- (void)initHeaderAndTunes
{
    PSAAppHeaderView *headerView = [PSAAppHeaderView createAppHeaderView];
    [headerView setTitle:[NSString stringWithFormat:@"FM (%d)",[[[resourceDictionary objectForKey:@"FM"] objectForKey:@"Num"] intValue]]];
    [headerView setX:0 Y:[self.scrollView calculateSuitablePositionYForNextSubview]];
    headerView.tag = kFMHeaderTag;
    [self.scrollView addSubview:headerView];
    
    int num1 = [[[resourceDictionary objectForKey:@"FM"] objectForKey:@"Num"] intValue];
    favoriteNum = num1;
    
    for (int i=0; i<num1; i++) {
        PSARadioFMView *fmView = [PSARadioFMView createFMViewWithValue:[[resourceDictionary objectForKey:@"FM"] objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
        [fmView setX:27+(186*(i%5)) Y:55+(i/5)*140];
        fmView.delegate = self;
        fmView.tag = kFMViewTagBasic+i;
        [favoriteArray addObject:fmView];
        [scrollView addSubview:fmView];
    }
    
    PSAAppHeaderView *internetHeaderView = [PSAAppHeaderView createAppHeaderView];
    [internetHeaderView setTitle:[NSString stringWithFormat:@"INTERNET (%d)",[[[resourceDictionary objectForKey:@"Internet"] objectForKey:@"Num"] intValue]]];
    internetHeaderView.tag = kInternetHeaderTag;
    [internetHeaderView setX:0 Y:[self.scrollView calculateSuitablePositionYForNextSubview]+20];
    [self.scrollView addSubview:internetHeaderView];
    
    int num2 = [[[resourceDictionary objectForKey:@"Internet"] objectForKey:@"Num"] intValue];
    for (int i=0; i<num2; i++) {
        PSARadioInternetView *internetView = [PSARadioInternetView createFMViewWithName:[[[resourceDictionary objectForKey:@"Internet"] objectForKey:[NSString stringWithFormat:@"%d",i+1]] objectForKey:@"Name"] type:[[[resourceDictionary objectForKey:@"Internet"] objectForKey:[NSString stringWithFormat:@"%d",i+1]] objectForKey:@"Type"] detail:[[[resourceDictionary objectForKey:@"Internet"] objectForKey:[NSString stringWithFormat:@"%d",i+1]] objectForKey:@"Detail"]];
        internetView.tag = kInternetViewTagBasic + i;
        [internetView setX:27+(186*i) Y:internetHeaderView.frame.origin.y+internetHeaderView.frame.size.height+20];
        [scrollView addSubview:internetView];
    }
    
    [self refreshScrollView];
}

#pragma mark Mini Method

- (void)refreshScrollView
{
    CGFloat oldContentHeight = (self.scrollView.frame.size.height + 1);
    CGFloat contentHeight = oldContentHeight >= [self.scrollView calculateSuitablePositionYForNextSubview] ? oldContentHeight : [self.scrollView calculateSuitablePositionYForNextSubview];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, contentHeight);
}

- (void)resetMyStation
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPathInDoc = [paths objectAtIndex:0];
    NSString *finishedPath =[plistPathInDoc stringByAppendingPathComponent:@"RadioFMList.plist"];
    resourceDictionary = [NSDictionary dictionaryWithContentsOfFile:finishedPath];
    
    for (int i=0; i<favoriteNum; ++i) {
        [[scrollView viewWithTag:kFMViewTagBasic+i] removeFromSuperview];
    }
    
    int num = [[[resourceDictionary objectForKey:@"FM"] objectForKey:@"Num"] intValue];
    int num2 = [[[resourceDictionary objectForKey:@"Internet"] objectForKey:@"Num"] intValue];
    
    if (num==1 && favoriteNum==0){
        [UIView animateWithDuration:1.0f animations:^{
            [[scrollView viewWithTag:kInternetHeaderTag] setY:[scrollView viewWithTag:kInternetHeaderTag].frame.origin.y+140];
            for (int i=0; i<num2; ++i) {
                [[scrollView viewWithTag:kInternetViewTagBasic+i] setY:[scrollView viewWithTag:kInternetViewTagBasic+i].frame.origin.y+140];
            }
        } completion:^(BOOL finished){
            for (int i=0; i<num; ++i) {
                [(PSAAppHeaderView *)[scrollView viewWithTag:kFMHeaderTag] setTitle:[NSString stringWithFormat:@"FM(%d)",num]];
                PSARadioFMView *fmView = [PSARadioFMView createFMViewWithValue:[[resourceDictionary objectForKey:@"FM"] objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
                [fmView setX:27+(186*(i%5)) Y:55+(i/5)*140];
                fmView.delegate = self;
                fmView.tag = kFMViewTagBasic+i;
                [favoriteArray addObject:fmView];
                [scrollView addSubview:fmView];
            }
        }];
    }else{
        [(PSAAppHeaderView *)[scrollView viewWithTag:kFMHeaderTag] setTitle:[NSString stringWithFormat:@"FM(%d)",num]];
        for (int i=0; i<num; ++i) {
            PSARadioFMView *fmView = [PSARadioFMView createFMViewWithValue:[[resourceDictionary objectForKey:@"FM"] objectForKey:[NSString stringWithFormat:@"%d",i+1]]];
            [fmView setX:27+(186*(i%5)) Y:55+(i/5)*140];
            fmView.delegate = self;
            fmView.tag = kFMViewTagBasic+i;
            [favoriteArray addObject:fmView];
            [scrollView addSubview:fmView];
        }
        if(favoriteNum==1 && num==0) {
            [UIView animateWithDuration:1.0f animations:^{
                [[scrollView viewWithTag:kInternetHeaderTag] setY:[scrollView viewWithTag:kInternetHeaderTag].frame.origin.y-140];
                for (int i=0; i<num2; ++i) {
                    [[scrollView viewWithTag:kInternetViewTagBasic+i] setY:[scrollView viewWithTag:kInternetViewTagBasic+i].frame.origin.y-140];
                }
            } completion:nil];
        }
    }
    favoriteNum = num;
}

#pragma mark RadioFMDelegate

- (void)playRadioWithValue:(NSString *)value
{
    [delegate playRadioWithValue:value];
}

@end
