//
//  PSAMusicDVDViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-24.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicDVDViewController.h"
#import "PSAMusicDiskView.h"
#import "PSAMusicPlayer.h"
#import "PSAMusicConstantsConfig.h"
#import "UIView+Subview.h"

#define kPSAMusicDVDViewControllerNibName @"PSAMusicDVDViewController"

@interface PSAMusicDVDViewController ()
@property (strong, nonatomic)NSMutableArray *diskArray;
@end

@implementation PSAMusicDVDViewController
@synthesize diskScrollView;
@synthesize bgImageView;

+ (PSAMusicDVDViewController *)createMusicDVDViewController
{
    return [[PSAMusicDVDViewController alloc] initWithNibName:kPSAMusicDVDViewControllerNibName bundle:nil];
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
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] getNowPlayingSource]!=kNowPlayingSourceDVD) {
        for (PSAMusicDiskView *disk in self.diskArray) {
            [disk setNormalState];
            currentDisk = 0;
        }
    }
    [diskScrollView scrollRectToVisible:CGRectMake(currentDisk*340, 0, diskScrollView.frame.size.width, diskScrollView.frame.size.height) animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initScrollView];
    [self initDiskView];
    [self initPageControl];
    [self initAnimation];
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
    pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(383, 420, 150, 40)];
    [pageControl setCurrentPage:0];
    [self.view addSubview:pageControl];
    [pageControl setPageControlStyle:PageControlStyleThumb];
    [pageControl setThumbImage:[UIImage imageNamed:@"PSALockPanelPageControlDot"]];
    [pageControl setSelectedThumbImage:[UIImage imageNamed:@"PSALockPanelPageControlFocus"]];
    [pageControl setGapWidth:5];
    [pageControl setNumberOfPages:3];
    [pageControl setUserInteractionEnabled:NO];
}

- (void)initScrollView
{
    currentDisk = 3;
    diskScrollView.delegate = self;
    diskScrollView.pageWidth = 340;
    diskScrollView.contentSize = CGSizeMake(kScrollViewWidght, diskScrollView.frame.size.height);
    diskScrollView.clipsToBounds = NO;
    [diskScrollView calculateSuitablePositionXForNextSubview];
}

- (void)initDiskView
{
    for (int i=0; i<[[PSAMusicPlayer sharedPSAMusicPlayer] getListsCountWithHeader:kDiskHeader]; i++) {
        PSAMusicDiskView *diskView = [[PSAMusicDiskView alloc] initWithFrame:kMusicDiskViewFrame];
        diskView.delegate = self;
        [diskView setDiskIndex:i];
        [diskView setIsMusic:YES];
        [self.diskArray addObject:diskView];
        diskView.tag = kTagOffset+i;
        [diskView setDiskLabel:[NSString stringWithFormat:@"Disk %d",i+1] andTrackLabel:[NSString stringWithFormat:@"%d tracks",[[[PSAMusicPlayer sharedPSAMusicPlayer] getListWithIndex:i] count]]];
        [diskView setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
        [diskView setSelectedImage:kMusicDiskSelectedImage andNormalImage:kMusicDiskImage];
        [diskView setDiskLabelColor:[UIColor blackColor] andTrackLabelColor:[UIColor whiteColor]];
        [diskScrollView addSubview:diskView];
    }
}

- (void)initAnimation
{
    [diskScrollView setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
    [bgImageView setEasingFunction:kPSAAnimationDefaultEaseCurve forKeyPath:@"frame"];
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
            [self.delegate switchDiskAtIndax:i];
            currentDisk = i;
            [diskScrollView scrollRectToVisible:CGRectMake(currentDisk*340, 0, diskScrollView.frame.size.width, diskScrollView.frame.size.height) animated:YES];
        }
    }
}

@end
