//
//  PSARadioNowPlayingSegmentViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-7.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSARadioSliderView.h"

@protocol RadioNowPlayingSegmentDelegate

- (void)resetMyStation;
- (void)pausePlay;
- (void)resumePlay;
- (BOOL)isPlayingOrNot;

@end

@interface PSARadioNowPlayingSegmentViewController : UIViewController<RadioSliderDelegate>{
    PSARadioSliderView *sliderView;
}

+ (PSARadioNowPlayingSegmentViewController *)createRadioNowPlayingSegmentViewController;

@property (weak, nonatomic) id<RadioNowPlayingSegmentDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *fmValueLabel;
@property (weak, nonatomic) IBOutlet UIView *touchView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)preRadioAction:(id)sender;
- (IBAction)likeAction:(id)sender;
- (IBAction)nextRadioAction:(id)sender;
- (IBAction)stopPlayingAction:(id)sender;

- (void)scrollToPlayingStation:(NSString *)value animate:(BOOL)animated;
- (void)switchRadioFromDic:(NSDictionary *)dic;

@end
