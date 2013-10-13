//
//  PSAVideoDeviceViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSAVideoCoverViewController.h"

@interface PSAVideoDeviceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    int switchButtonState;
    int editButtonState;
}

@property (weak, nonatomic) IBOutlet UITableView *deviceTableView;
@property (strong, nonatomic) PSAVideoCoverViewController *videoCoverViewController;

+ (PSAVideoDeviceViewController *)createVideoDeviceViewController;

@end
