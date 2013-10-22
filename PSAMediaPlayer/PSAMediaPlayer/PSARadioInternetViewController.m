//
//  PSARadioInternetViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-9-11.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSARadioInternetViewController.h"
#import "PSAAppHeaderView.h"
#import "PSARadioInternetView.h"

#define kPSARadioInternetViewControllerNibName @"PSARadioInternetViewController"

@interface PSARadioInternetViewController ()

@end

@implementation PSARadioInternetViewController
@synthesize scrollView;

+ (PSARadioInternetViewController *)createRadioInternetViewController
{
    return [[PSARadioInternetViewController alloc] initWithNibName:kPSARadioInternetViewControllerNibName bundle:nil];
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
    [self initArrayAndDictionary];
    [self initScrollView];
    [self initHeaderAndInternetView];
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
}

- (void)initScrollView
{
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height+20);
}

- (void)initHeaderAndInternetView
{
    PSAAppHeaderView *internetHeaderView = [PSAAppHeaderView createAppHeaderView];
    [internetHeaderView setTitle:@"INTERNET (4)"];
    [internetHeaderView setX:0 Y:0];
    [self.scrollView addSubview:internetHeaderView];
    
    for (int i=0; i<4; i++) {
        PSARadioInternetView *internetView = [PSARadioInternetView createFMViewWithName:[[[resourceDictionary objectForKey:@"Internet"] objectForKey:[NSString stringWithFormat:@"%d",i+1]] objectForKey:@"Name"] type:[[[resourceDictionary objectForKey:@"Internet"] objectForKey:[NSString stringWithFormat:@"%d",i+1]] objectForKey:@"Type"] detail:[[[resourceDictionary objectForKey:@"Internet"] objectForKey:[NSString stringWithFormat:@"%d",i+1]] objectForKey:@"Detail"]];
        [internetView setX:27+(186*(i%5)) Y:55+(i/5)*140];
        [scrollView addSubview:internetView];
    }
}


@end
