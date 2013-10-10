//
//  PSAVideoDVDViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSAMusicDiskView.h"
#import "DMPagingScrollView.h"
#import "StyledPageControl.h"

@interface PSAVideoDVDViewController : UIViewController<UIScrollViewDelegate,DiskViewDelegate>{
    StyledPageControl *pageControl;
}

+ (PSAVideoDVDViewController *)createVideoDVDViewController;

- (void)setTimeColor:(UIColor *)color;

@property (weak, nonatomic) IBOutlet DMPagingScrollView *diskScrollView;

@end
