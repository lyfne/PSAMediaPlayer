//
//  PSAVideoCoverItemView.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-21.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAVideoCoverItemView.h"

#define kPSAVideoCoverItemViewNibName @"PSAVideoCoverItemView"
#define kSwitchVideoNotifySign @"SWITCHVIDEO"
#define kVideoUserInfo @"VideoUserInfo"

@implementation PSAVideoCoverItemView

+ (PSAVideoCoverItemView *)createVideoItemViewWithName:(NSString *)movieName time:(NSString *)movieTime
{
    PSAVideoCoverItemView *videoItemView = [PSAVideoCoverItemView createVideoItemView];
    
    videoItemView.movieImageView.image = [UIImage imageNamed:[movieName stringByAppendingString:@".png"]];
    videoItemView.movieNameLabel.text = movieName;
    
    videoItemView.movieTimeLabel.text = movieTime;
    
    return videoItemView;
}

+ (PSAVideoCoverItemView *)createVideoItemView
{
    PSAVideoCoverItemView *videoItemView = [[[NSBundle mainBundle] loadNibNamed:kPSAVideoCoverItemViewNibName
                                                                         owner:self options:nil] lastObject];
    [videoItemView configureVideoItemView];
    
    return videoItemView;
}

- (void)configureVideoItemView
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTune)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)selectTune
{
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:self.movieNameLabel.text] forKeys:[NSArray arrayWithObject:kVideoUserInfo]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchVideoNotifySign object:self userInfo:dictionary];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
