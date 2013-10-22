//
//  PSARadioSliderView.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-13.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSARadioSliderView.h"
#import "math.h"
#import "PSAMusicPlayer.h"
#import "PSARadioPlayer.h"
#import "PSARadioConstantsConfig.h"
#import "PSAMusicConstantsConfig.h"

#define kPSARadioFMViewNibName @"PSARadioSliderView"

@implementation PSARadioSliderView
@synthesize fmScrollView;
@synthesize delegate;
@synthesize tunerImageView,pointerImageView;

+ (PSARadioSliderView *)createRadioSlider
{
    PSARadioSliderView *sliderView = [PSARadioSliderView createRadioSliderView];
    return sliderView;
}

+ (PSARadioSliderView *)createRadioSliderView
{
    PSARadioSliderView *sliderView = [[[NSBundle mainBundle] loadNibNamed:kPSARadioFMViewNibName
                                                                owner:self options:nil] lastObject];
    [sliderView configureRadioSliderView];
    
    return sliderView;
}

- (void)configureRadioSliderView
{
    [self initData];
    [self initScrollView];
}

#pragma mark Init Method

- (void)initData
{
    onStation = YES;
    whichStation = 0;
    valueArray = [[NSArray alloc] initWithObjects:@"89.2",@"93.7",@"97.9",@"101.5",@"107.7",nil];
}

- (void)initScrollView
{
    fmScrollView.delegate = self;
    fmScrollView.contentSize = CGSizeMake(2798, fmScrollView.frame.size.height);
    fmScrollView.bounces = NO;
    [fmScrollView scrollRectToVisible:CGRectMake([self valueToX:(89.2-kValueOffset)], 0, fmScrollView.frame.size.width, fmScrollView.frame.size.height) animated:NO];
    nowPlayingValue = @"89.2";
}

- (void)initLabelAndImage
{
    NSMutableDictionary *dictionary = [self getResourceDictionary];
    
    labelY = 0;
    imageViewY = 0;
    if (sliderType == kRadioNowPlayingType) {
        labelY=8;
        imageViewY = 16;
    }else{
        labelY=17;
        [tunerImageView setY:9];
        [pointerImageView setY:8];
    }
    
    for (int i=0; i<=numOfLabel; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(350+104*i, labelY, 32, 20)];
        label.text = [NSString stringWithFormat:@"%d",88+i];
        label.tag = kLabelTagOffset+i;
        [label useRegularFontWithSize:14];
        [fmScrollView addSubview:label];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.alpha = 0.4-(fabsf([label.text floatValue]-fmValue)*0.4/kValueOffset);
    }
    
    int num = [[[dictionary objectForKey:@"FM"] objectForKey:@"Num"] intValue];
    favoriteNum = num;
    for (int i=0; i<num; ++i) {
        UIImageView *favoriteImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Radio_favorites.png"]];
        favoriteImageView.frame = CGRectMake([self valueToX:[[[dictionary objectForKey:@"FM"] objectForKey:[NSString stringWithFormat:@"%d",i+1]] floatValue]]-5, imageViewY, 22, 22);
        favoriteImageView.tag = kFavoriteTagOffset+i;
        [fmScrollView addSubview:favoriteImageView];
    }
}

#pragma mark Mini Function

- (float)offsetToValue:(float)offset
{
    float value = 88+offset/104;
    return value;
}

- (float)valueToX:(float)value
{
    return 350+(value-88)*104;
}

#pragma mark ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    onStation = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    fmValue = [self offsetToValue:fmScrollView.contentOffset.x];
    if (fmValue>=88&&fmValue<=108) {
        [delegate valueChanged:fmValue];
        
        for (int i=0; i<5; ++i) {
            if ([[NSString stringWithFormat:@"%.1f",[self offsetToValue:fmScrollView.contentOffset.x]] isEqualToString:[valueArray objectAtIndex:i]]) {
                if (![self.delegate isPlayingOrNot]) {
                    [delegate playRadio:[valueArray objectAtIndex:i]];
                    nowPlayingValue = [valueArray objectAtIndex:i];
                }
            }
        }
        
        NSMutableDictionary *dictionary = [self getResourceDictionary];
        int num = [[[dictionary objectForKey:@"FM"] objectForKey:@"Num"] intValue];
        
        for (int i=0; i<num; ++i) {
            [fmScrollView viewWithTag:kFavoriteTagOffset+i].alpha = 1-(fabs([[[dictionary objectForKey:@"FM"] objectForKey:[NSString stringWithFormat:@"%d",i+1]] floatValue]-fmValue)*1.0/kValueOffset);
        }
        
        for (int i=0; i<=numOfLabel; ++i) {
            UILabel *label = (UILabel *)[fmScrollView viewWithTag:kLabelTagOffset+i];
            label.alpha = 0.4-(fabsf([label.text floatValue]-fmValue)*0.4/kValueOffset);
        }
        
        if (![nowPlayingValue isEqualToString:[NSString stringWithFormat:@"%.1f",fmValue]] && onStation == NO) {
            [delegate stopPlay];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate==NO) {
        for (int i=0; i<5; ++i) {
            if ([[NSString stringWithFormat:@"%.1f",[self offsetToValue:fmScrollView.contentOffset.x]] isEqualToString:[valueArray objectAtIndex:i]]) {
                onStation = YES;
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (int i=0; i<5; ++i) {
        if ([[NSString stringWithFormat:@"%.1f",[self offsetToValue:fmScrollView.contentOffset.x]] isEqualToString:[valueArray objectAtIndex:i]]) {
            onStation = YES;
        }
    }
}

#pragma mark Mini Function

- (NSMutableDictionary *)getResourceDictionary
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPathInDoc = [paths objectAtIndex:0];
    NSString *finishedPath =[plistPathInDoc stringByAppendingPathComponent:@"RadioFMList.plist"];
    NSMutableDictionary *resourceDictionary = [NSDictionary dictionaryWithContentsOfFile:finishedPath];
    return resourceDictionary;
}

#pragma mark Public Method

- (void)scrollToNext
{
    for (int i=0; i<5; ++i) {
        if ([[valueArray objectAtIndex:i] floatValue]>fmValue) {
            whichStation = i-1;
            break;
        }
    }
    if (whichStation<4) {
        whichStation++;
        if (onStation == YES && whichStation<4) {
            whichStation++;
        }
        [delegate playRadio:[valueArray objectAtIndex:whichStation]];
        [fmScrollView scrollRectToVisible:CGRectMake([self valueToX:([[valueArray objectAtIndex:whichStation] floatValue]-kValueOffset)], 0, fmScrollView.frame.size.width, fmScrollView.frame.size.height) animated:YES];
        onStation=YES;
        nowPlayingValue = [valueArray objectAtIndex:whichStation];
    }
}

- (void)scrollToPre
{
    whichStation = 5;
    for (int i=0; i<5; ++i) {
        if ([[valueArray objectAtIndex:i] floatValue]>=fmValue) {
            whichStation = i;
            break;
        }
    }
    
    if (whichStation>0) {
        whichStation--;
        [fmScrollView scrollRectToVisible:CGRectMake([self valueToX:([[valueArray objectAtIndex:whichStation] floatValue]-kValueOffset)], 0, fmScrollView.frame.size.width, fmScrollView.frame.size.height) animated:YES];
        onStation = YES;
        [delegate playRadio:[valueArray objectAtIndex:whichStation]];
        nowPlayingValue = [valueArray objectAtIndex:whichStation];
    }
}

- (void)setType:(int)type
{
    sliderType = type;
    [self initLabelAndImage];
}

- (BOOL)isOnStation
{
    return onStation;
}

- (void)scrollTo:(NSString *)value animate:(BOOL)animated
{
    nowPlayingValue = value;
    [fmScrollView scrollRectToVisible:CGRectMake([self valueToX:([value floatValue]-kValueOffset)], 0, fmScrollView.frame.size.width, fmScrollView.frame.size.height) animated:animated];
    for (int i=0; i<[valueArray count]; ++i) {
        if ([value isEqualToString:[valueArray objectAtIndex:i]]) {
            whichStation = i;
            break;
        }
    }
}

- (void)resetFavorite
{
    for (int i=0; i<favoriteNum; ++i) {
        [[fmScrollView viewWithTag:kFavoriteTagOffset+i] removeFromSuperview];
    }
    
    NSMutableDictionary *dictionary = [self getResourceDictionary];
    int num = [[[dictionary objectForKey:@"FM"] objectForKey:@"Num"] intValue];
    favoriteNum = num;
    for (int i=0; i<num; ++i) {
        UIImageView *favoriteImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Radio_favorites.png"]];
        favoriteImageView.frame = CGRectMake([self valueToX:[[[dictionary objectForKey:@"FM"] objectForKey:[NSString stringWithFormat:@"%d",i+1]] floatValue]]-5, imageViewY, 22, 22);
        favoriteImageView.tag = kFavoriteTagOffset+i;
        [fmScrollView addSubview:favoriteImageView];
    }
}

- (int)getWhichStation
{
    return whichStation;
}

@end
