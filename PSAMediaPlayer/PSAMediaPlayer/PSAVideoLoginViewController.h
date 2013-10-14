//
//  PSAVideoLoginViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-11-4.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAVideoLoginViewController : UIViewController

+ (PSAVideoLoginViewController *)createVideoLoginViewController;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *loginAlertView;

- (IBAction)okAction:(id)sender;

@end
