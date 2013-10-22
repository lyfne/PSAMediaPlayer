//
//  PSARadioSliderView.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-13.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadioSliderDelegate

- (void)valueChanged:(float)value;
- (void)playRadio:(NSString *)value;
- (void)stopPlay;
- (BOOL)isPlayingOrNot;

@end

@interface PSARadioSliderView : UIView<UIScrollViewDelegate>{
    int sliderType;
    int favoriteNum;
    float fmValue;
    NSString *nowPlayingValue;
    int labelY;
    int imageViewY;
    int whichStation;
    BOOL onStation;
    NSArray *valueArray;
}

@property (weak, nonatomic) IBOutlet UIScrollView *fmScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *tunerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pointerImageView;

@property (weak, nonatomic) id<RadioSliderDelegate> delegate;

+ (PSARadioSliderView *)createRadioSlider;

- (void)setType:(int)type;
- (void)scrollToNext;
- (void)scrollToPre;
- (BOOL)isOnStation;
- (int)getWhichStation;

- (void)scrollTo:(NSString *)value  animate:(BOOL)animated;
- (void)resetFavorite;

@end
