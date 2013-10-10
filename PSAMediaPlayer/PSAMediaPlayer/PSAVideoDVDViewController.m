//
//  PSAVideoDVDViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAVideoDVDViewController.h"
#import "PSAVideoConstantsConfig.h"
#import "UIView+Subview.h"

#define kPSAVideoDVDViewControllerNibName @"PSAVideoDVDViewController"

@interface PSAVideoDVDViewController ()
@property (strong, nonatomic)NSMutableArray *diskArray;
@end

@implementation PSAVideoDVDViewController
@synthesize diskScrollView;

+ (PSAVideoDVDViewController *)createVideoDVDViewController
{
    return [[PSAVideoDVDViewController alloc] initWithNibName:kPSAVideoDVDViewControllerNibName bundle:nil];
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
    [self initScrollView];
    [self initDiskView];
    [self initPageControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)diskArray
{
    if (_diskArray == nil) {
        _diskArray = [[NSMutableArray alloc] init];
    }
    return _diskArray;
}

#pragma mark Init Method

- (void)initPageControl
{
    pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(408, 503, 100, 40)];
    [pageControl setCurrentPage:0];
    [self.view addSubview:pageControl];
    [pageControl setPageControlStyle:PageControlStyleThumb];
    [pageControl setThumbImage:[UIImage imageNamed:@"PSALockPanelPageControlDot"]];
    [pageControl setSelectedThumbImage:[UIImage imageNamed:@"PSALockPanelPageControlFocus"]];
    [pageControl setGapWidth:5];
    [pageControl setNumberOfPages:2];
    [pageControl setUserInteractionEnabled:NO];
}

- (void)initScrollView
{
    diskScrollView.delegate = self;
    diskScrollView.pageWidth = 340;
    diskScrollView.contentSize = CGSizeMake(kDiskScrollWidth, diskScrollView.frame.size.height);
    diskScrollView.clipsToBounds = NO;
    [diskScrollView calculateSuitablePositionXForNextSubview];
}

- (void)initDiskView
{
    NSArray *timeArray = [[NSArray alloc] initWithObjects:@"89:07",@"65:15", nil];
    for (int i=0; i<2; i++) {
        PSAMusicDiskView *diskView = [[PSAMusicDiskView alloc] initWithFrame:kVideoDiskViewFrame];
        diskView.delegate = self;
        [diskView setDiskIndex:i];
        [diskView setIsMusic:NO];
        [self.diskArray addObject:diskView];
        diskView.tag = kTagOffset+i;
        [diskView setDiskLabel:[NSString stringWithFormat:@"Disk %d",i+1] andTrackLabel:[timeArray objectAtIndex:i]];
        [diskView setSelectedImage:kVideoDiskImage andNormalImage:kVideoDiskImage];
        [diskScrollView addSubview:diskView];
    }
}

#pragma mark ScrollView Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (int i = 0; i<[self.diskArray count]; i++) {
        float offset = diskScrollView.contentOffset.x-i*340 > 0 ? diskScrollView.contentOffset.x-i*340 : i*340-diskScrollView.contentOffset.x;
        PSAMusicDiskView *tempDiskView = (PSAMusicDiskView*)[self.diskArray objectAtIndex:i];
        if (offset<340) {
            tempDiskView.diskLabel.alpha = 1-offset*0.4/340;
            tempDiskView.trackLabel.alpha = 1-offset*0.4/340;
        }
    }
    int page = floor((scrollView.contentOffset.x - diskScrollView.pageWidth/2)/diskScrollView.pageWidth)+1;
    [pageControl setCurrentPage:page];
}

#pragma mark Public Method

- (void)setTimeColor:(UIColor *)color
{
    for (int i=0; i<2; i++) {
        PSAMusicDiskView *diskView = (PSAMusicDiskView *)[diskScrollView viewWithTag:kTagOffset+i];
        [diskView setDiskLabelColor:color andTrackLabelColor:[UIColor whiteColor]];
    }
}

#pragma mark Delegate

- (void)resetOtherDiskBGImage
{
    for (int i=0; i<[self.diskArray count]; i++) {
        [[self.diskArray objectAtIndex:i] setNormalState];
    }
}

- (void)switchDisk
{
    for (int i=0; i<[self.diskArray count]; i++) {
        if ([[self.diskArray objectAtIndex:i] isSelected]) {
            [diskScrollView scrollRectToVisible:CGRectMake(i*340, 0, diskScrollView.frame.size.width, diskScrollView.frame.size.height) animated:YES];
            NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:[NSString stringWithFormat:@"Disk%d",i+1]] forKeys:[NSArray arrayWithObject:kVideoUserInfo]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchVideoNotifySign object:self userInfo:dictionary];
        }
    }
}

@end
