//
//  PSAVideoCoverViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-21.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAVideoCoverViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *videoCoverScrollView;

+ (PSAVideoCoverViewController *)createVideoCoverViewController;

@end
