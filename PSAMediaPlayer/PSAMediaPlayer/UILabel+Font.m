//
//  UILabel+Font.m
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-18.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "UILabel+Font.h"

@implementation UILabel (Font)

- (void)useRegularFontWithSize:(CGFloat)size
{
    [self setFont:[UIFont fontWithName:kAvenirNextRegular size:size]];
}

- (void)useDemiBoldFontWithSize:(CGFloat)size
{
    [self setFont:[UIFont fontWithName:kAvenirNextDemiBold size:size]];
}

- (void)useUltraLightFontWithSize:(CGFloat)size
{
    [self setFont:[UIFont fontWithName:kAvenirNextUltraLight size:size]];
}

- (void)useMediumFontWithSize:(CGFloat)size
{
    [self setFont:[UIFont fontWithName:kAvenirNextMedium size:size]];
}

@end
