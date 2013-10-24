//
//  PSAMusicDVDViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-24.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSAMusicDiskView.h"
#import "StyledPageControl.h"
#import "DMPagingScrollView.h"

@protocol PSADVDSwitchDelegate

- (void)switchDiskAtIndax:(int)index;

@end

@interface PSAMusicDVDViewController : UIViewController<DiskViewDelegate,UIScrollViewDelegate>{
    StyledPageControl *pageControl;
    int currentDisk;
}

@property (weak, nonatomic) IBOutlet DMPagingScrollView *diskScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) id<PSADVDSwitchDelegate> delegate;

+ (PSAMusicDVDViewController *)createMusicDVDViewController;

@end
