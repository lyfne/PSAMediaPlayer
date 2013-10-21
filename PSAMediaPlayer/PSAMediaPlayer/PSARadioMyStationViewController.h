//
//  PSARadioMyStationViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-4.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSARadioInternetView.h"
#import "PSARadioFMView.h"

@protocol RadioMyStationDelegate

- (void)playRadioWithValue:(NSString *)value;

@end

@interface PSARadioMyStationViewController : UIViewController<RadioFMDelegate>{
    NSMutableDictionary *resourceDictionary;
    NSMutableArray *favoriteArray;
    int favoriteNum;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) id<RadioMyStationDelegate> delegate;

+ (PSARadioMyStationViewController *)createRadioMyStationViewController;

- (void)resetMyStation;

@end
