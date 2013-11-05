//
//  RadioPanelViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-15.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PSARadioMyStationViewController.h"
#import "PSARadioInternetViewController.h"
#import "PSARadioNowPlayingSegmentViewController.h"

@interface PSARadioPanelViewController : UIViewController<RadioNowPlayingSegmentDelegate,RadioMyStationDelegate>{
    NSString *resourcePath;
    NSMutableDictionary *resourceDictionary;
    UIImage *screenShot;
    NSArray *valueArray;
    BOOL showFMF;
}

@property (weak, nonatomic) IBOutlet UIButton *myStationButton;
@property (weak, nonatomic) IBOutlet UIButton *internetButton;

@property (weak, nonatomic) IBOutlet UIView *segmentView;

@property (strong, nonatomic) PSARadioNowPlayingSegmentViewController *radioNowPlayingSegmentViewController;
@property (strong, nonatomic) PSARadioMyStationViewController *radioMyStationViewController;
@property (strong, nonatomic) PSARadioInternetViewController *radioInternetViewController;

- (IBAction)switchRadioSourceAction:(id)sender;

+ (PSARadioPanelViewController *)createRadioViewController;

@end
