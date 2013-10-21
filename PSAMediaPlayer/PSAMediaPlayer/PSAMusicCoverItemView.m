//
//  PSAMusicCoverItemView.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-30.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicCoverItemView.h"
#import "PSAMusicPlayer.h"
#import "PSAMusicConstantsConfig.h"

#define kPSAMusicCoverItemViewNibName @"PSAMusicCoverItemView"

@interface PSAMusicCoverItemView()
@property (strong, nonatomic) PSATune* tune;
@end

@implementation PSAMusicCoverItemView
@synthesize tune;

+ (PSAMusicCoverItemView *)createMusicCoverItemViewWithTuneInfo:(PSATune *)tune
{
    PSAMusicCoverItemView *tuneItemView = [PSAMusicCoverItemView createTuneItemViewWithAlbum:tune.albumName name:tune.songName singer:tune.singerName];
    tuneItemView.tune = tune;
    return tuneItemView;
}

+ (PSAMusicCoverItemView *)createTuneItemViewWithAlbum:(NSString *)albumName name:(NSString *)songName singer:(NSString *)singerName
{
    PSAMusicCoverItemView *tuneItemView = [PSAMusicCoverItemView createTuneItemView];
    
    tuneItemView.albumImageView.image = [UIImage imageNamed:[albumName stringByAppendingString:@"Mid.png"]];
    tuneItemView.singerNameLabel.text = singerName;
    
    NSArray *tickerStrings = [NSArray arrayWithObjects:songName, nil];
	
	JHTickerView *newLabel = [[JHTickerView alloc] initWithFrame:CGRectMake(17, 151, 136, 21)];
    tuneItemView.songNameLabel = newLabel;
    [tuneItemView.songNameLabel setDirection:JHTickerDirectionLTR];
	[tuneItemView.songNameLabel setTickerStrings:tickerStrings];
	[tuneItemView.songNameLabel setTickerSpeed:60.0f];
	[tuneItemView.songNameLabel start];
    
    [tuneItemView addSubview:tuneItemView.songNameLabel];
    
    return tuneItemView;
}

+ (PSAMusicCoverItemView *)createTuneItemView
{
    PSAMusicCoverItemView *tuneItemView = [[[NSBundle mainBundle] loadNibNamed:kPSAMusicCoverItemViewNibName
                                                                 owner:self options:nil] lastObject];
    [tuneItemView configureTuneItemView];
    
    return tuneItemView;
}

- (void)configureTuneItemView
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTune)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)selectTune
{
    [[PSAMusicPlayer sharedPSAMusicPlayer] setNowPlayingSource:kNowPlayingSourceList];
        
    if (![[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentTune].songName isEqualToString:tune.songName]) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] setTuneIndex:self.tag-500];
        [[PSAMusicPlayer sharedPSAMusicPlayer] setCurrentListWithIndex:[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentShowListIndex]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchSongNotifySign object:self];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
