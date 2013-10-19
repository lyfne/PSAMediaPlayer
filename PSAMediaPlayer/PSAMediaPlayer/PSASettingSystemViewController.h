//
//  PSASettingSystemViewController.h
//  pdemos1
//
//  Created by BuG.BS on 13-10-13.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSASettingSystemViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

+ (PSASettingSystemViewController *)createSettingSystemViewController;

@end
