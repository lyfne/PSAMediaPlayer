//
//  PSAMusicListCoverViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-26.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicListCoverViewController.h"
#import "PSAMusicConstantsConfig.h"
#import "PSAMusicPlayer.h"
#import "PSAMusicCoverItemView.h"

#define kPSAMusicListCoverViewControllerNibName @"PSAMusicListCoverViewController"
#define kScrollHeight 50+204*((([[self loadCurrentShowList] count]-1)/3)+1)
#define kCoverItemViewFrame CGRectMake(25+178*(i%3),16+204*(i/3),167,201)
#define kCoverItemTagOffset 500

@interface PSAMusicListCoverViewController ()
@property (strong, nonatomic) NSMutableArray *items;
@end

@implementation PSAMusicListCoverViewController
@synthesize coverScrollView;

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

+ (PSAMusicListCoverViewController *)createMusicListCoverViewController
{
    return [[PSAMusicListCoverViewController alloc] initWithNibName:kPSAMusicListCoverViewControllerNibName bundle:nil];
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
    [self initScrollView];
    [self createCoverItem];
}

#pragma mark Init Method

- (void)initScrollView
{
    coverScrollView.delegate = self;
    coverScrollView.contentSize = CGSizeMake(coverScrollView.frame.size.width, kScrollHeight);
}

- (void)createCoverItem
{
    for (int i=0; i<[[self loadCurrentShowList] count];i++) {
        PSAMusicCoverItemView *itemView = [PSAMusicCoverItemView createMusicCoverItemViewWithTuneInfo:[[self loadCurrentShowList] tuneAtIndex:i]];
        itemView.frame = kCoverItemViewFrame;
        itemView.tag = i+kCoverItemTagOffset;
        [self.items addObject:itemView];
        [coverScrollView addSubview:itemView];
    }
}

#pragma mark Data Method

- (PSATunesList *)loadCurrentShowList
{
    return [[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentShowList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)reloadData
{
    for (int i=0; i<[self.items count]; i++) {
        [[coverScrollView viewWithTag:i+kCoverItemTagOffset] removeFromSuperview];
    }
    [self.items removeAllObjects];
    coverScrollView.contentSize = CGSizeMake(coverScrollView.frame.size.width, kScrollHeight);
    [self createCoverItem];
}

@end
