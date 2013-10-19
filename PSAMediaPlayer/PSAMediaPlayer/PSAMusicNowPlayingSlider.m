//
//  PSAMusicNowPlayingSlider.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-30.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicNowPlayingSlider.h"

@implementation PSAMusicNowPlayingSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate touchEnd];
}

@end
