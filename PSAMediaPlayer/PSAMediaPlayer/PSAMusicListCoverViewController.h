//
//  PSAMusicListCoverViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-26.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAMusicListCoverViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *coverScrollView;

+ (PSAMusicListCoverViewController *)createMusicListCoverViewController;

- (void)reloadData;

@end
