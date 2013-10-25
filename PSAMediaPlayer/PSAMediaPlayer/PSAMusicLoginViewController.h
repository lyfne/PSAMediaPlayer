//
//  PSAMusicLoginViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-10-14.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAMusicLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *loginAlertView;

+ (PSAMusicLoginViewController *)createMusicLoginViewController;

- (IBAction)okAction:(id)sender;

@end
