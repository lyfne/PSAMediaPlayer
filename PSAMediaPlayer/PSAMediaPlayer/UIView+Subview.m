//
//  UIView+Subview.m
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-24.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "UIView+Subview.h"

@implementation UIView (Subview)

- (CGFloat)calculateSuitablePositionXForNextSubview
{
    return [self getLastSubViewOriginX] + [self getLastSubViewWidth];
}

- (CGFloat)calculateSuitablePositionYForNextSubview
{
    return [self getLastSubviewOriginY] + [self getLastSubviewHeight];
}

- (CGFloat)getLastSubviewHeight
{
    if ([self.subviews count] == 0) return 0;
    UIView *view = [[self subviews] lastObject];
    return view.frame.size.height;
}

- (CGFloat)getLastSubViewWidth
{
    if ([self.subviews count] == 0) return 0;
    UIView *view = [[self subviews] lastObject];
    return view.frame.size.width;
}

- (CGFloat)getLastSubviewOriginY
{
    if ([self.subviews count] == 0) return 0;
    UIView *view = [[self subviews] lastObject];
    return view.frame.origin.y;
}

- (CGFloat)getLastSubViewOriginX
{
    if ([self.subviews count] == 0) return 0;
    UIView *view = [[self subviews] lastObject];
    return view.frame.origin.x;
}

@end
