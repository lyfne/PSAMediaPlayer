//
//  PSARadioInternetViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-9-11.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSARadioInternetViewController : UIViewController{
    NSMutableDictionary *resourceDictionary;
}

+ (PSARadioInternetViewController *)createRadioInternetViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
