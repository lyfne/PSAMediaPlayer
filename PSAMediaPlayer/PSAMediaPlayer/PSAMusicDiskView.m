//
//  PSAMusicDiskView.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-24.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicDiskView.h"
#import "PSAMusicConstantsConfig.h"
#import "PSAMusicPlayer.h"

@implementation PSAMusicDiskView
@synthesize bgImageView;
@synthesize diskLabel,trackLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initImageViewAndLabel];
        isSelected = NO;
        diskIndex = 0;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setSelectedState];
}

#pragma mark Init Method

- (void)initImageViewAndLabel
{
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:bgImageView];
    
    diskLabel = [[UILabel alloc] initWithFrame:kDiskLabelFrame];
    [diskLabel useUltraLightFontWithSize:50];
    diskLabel.textColor = [UIColor blackColor];
    diskLabel.backgroundColor = [UIColor clearColor];
    [diskLabel setTextAlignment:NSTextAlignmentCenter];
    diskLabel.alpha = 0.6f;
    [self addSubview:diskLabel];
    
    trackLabel = [[UILabel alloc] initWithFrame:kTrackLabelFrame];
    [trackLabel useRegularFontWithSize:24];
    trackLabel.textColor = [UIColor whiteColor];
    trackLabel.backgroundColor = [UIColor clearColor];
    [trackLabel setTextAlignment:NSTextAlignmentCenter];
    trackLabel.alpha = 0.6f;
    [self addSubview:trackLabel];

}

#pragma mark Public Method

- (void)setDiskLabel:(NSString *)diskStr andTrackLabel:(NSString *)trackStr
{
    diskLabel.text = diskStr;
    trackLabel.text = trackStr;
}

- (void)setDiskLabelColor:(UIColor *)color andTrackLabelColor:(UIColor *)trackColor
{
    diskLabel.textColor = color;
    trackLabel.textColor = trackColor;
}

- (void)setSelectedImage:(NSString *)imageName andNormalImage:(NSString *)normalName
{
    selectedImageName = imageName;
    normalImageName = normalName;
    bgImageView.image = [UIImage imageNamed:normalImageName];
}

- (void)setSelectedState
{
    self.userInteractionEnabled = NO;
    if (isMusic == YES) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] setNowPlayingSource:kNowPlayingSourceDVD];
    }
    [self.delegate resetOtherDiskBGImage];
    isSelected = YES;
    bgImageView.image = [UIImage imageNamed:selectedImageName];
    [self.delegate switchDisk];
}

- (void)setNormalState
{
    isSelected = NO;
    bgImageView.image = [UIImage imageNamed:normalImageName];
    self.userInteractionEnabled = YES;
}

- (BOOL)isSelected
{
    return isSelected;
}

- (void)setDiskIndex:(int)index
{
    diskIndex = index;
}

- (void)setIsMusic:(BOOL)is
{
    isMusic = is;
}

@end
