//
//  PSAVideoCoverViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-21.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAVideoCoverViewController.h"
#import "PSAVideoCoverItemView.h"
#import "PSAVideoConstantsConfig.h"

#define kPSAVideoCoverViewControllerNibName @"PSAVideoCoverViewController"

@interface PSAVideoCoverViewController ()
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation PSAVideoCoverViewController
@synthesize videoCoverScrollView;

- (NSMutableArray *)items
{
    if (_items == nil) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

+ (PSAVideoCoverViewController *)createVideoCoverViewController
{
    return [[PSAVideoCoverViewController alloc] initWithNibName:kPSAVideoCoverViewControllerNibName bundle:nil];
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
    [self initVideoItemView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initScrollView
{
    videoCoverScrollView.delegate = self;
    videoCoverScrollView.contentSize = CGSizeMake(videoCoverScrollView.frame.size.width, videoCoverScrollView.frame.size.height+30);
}

- (void)initVideoItemView
{
    NSArray *videoArray = [[NSArray alloc] initWithObjects:@"Gaptain America",@"The Hunger Games",nil];
    NSArray *timeArray = [[NSArray alloc] initWithObjects:@"102min",@"97min", nil];
    for (int i=0; i<2;i++) {
        PSAVideoCoverItemView *itemView = [PSAVideoCoverItemView createVideoItemViewWithName:[videoArray objectAtIndex:i] time:[timeArray objectAtIndex:i]];
        itemView.frame = kVideoItemViewFrame;
        itemView.tag = i+kVideoItemTagOffset;
        [self.items addObject:itemView];
        [videoCoverScrollView addSubview:itemView];
    }
}

@end
