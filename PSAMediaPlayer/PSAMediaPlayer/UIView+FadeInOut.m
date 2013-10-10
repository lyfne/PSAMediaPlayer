//
//  UIView+FadeInOut.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-10-1.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "UIView+FadeInOut.h"

@implementation UIView (FadeInOut)

- (void) fadeOut:(float)time{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:time];
    [self setAlpha:0.0f];
    [UIView commitAnimations];
}

- (void) fadeIn:(float)time{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:time];
    [self setAlpha:1.0f];
    [UIView commitAnimations];
}

@end
