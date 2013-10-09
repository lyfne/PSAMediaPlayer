//
//  UIView+Frame.m
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setX:(CGFloat)x Y:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)moveXByOffset:(CGFloat)offsetX
{
    CGRect frame = self.frame;
    frame.origin.x += offsetX;
    self.frame = frame;
}

- (void)moveYByOffset:(CGFloat)offsetY
{
    CGRect frame = self.frame;
    frame.origin.y += offsetY;
    self.frame = frame;
}

- (void)moveXByOffset:(CGFloat)offsetX andOffsetY:(CGFloat)offsetY
{
    CGRect frame = self.frame;
    frame.origin.x += offsetX;
    frame.origin.y += offsetY;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.width = width;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height
{
    CGRect frame = CGRectMake(x, y, width, height);
    self.frame = frame;
}

- (void)resizeWidthByDeltaWidth:(CGFloat)delta
{
    CGRect frame = self.frame;
    frame.size.width += delta;
    self.frame = frame;
}

- (void)resizeHeightByDeltaHeight:(CGFloat)delta
{
    CGRect frame = self.frame;
    frame.size.height = delta;
    self.frame = frame;
}

- (void)resizeHeightByDeltaWidth:(CGFloat)deltaWidth andDeltaHeight:(CGFloat)deltaHeight
{
    CGRect frame = self.frame;
    frame.size.width += deltaWidth;
    frame.size.height += deltaHeight;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)x
{
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (void)setCenterY:(CGFloat)y
{
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

- (void)setCenterX:(CGFloat)x centerY:(CGFloat)y
{
    CGPoint center = self.center;
    center.x = x;
    center.y = y;
    self.center = center;
}

- (CGFloat)getHeight
{
    return CGRectGetHeight(self.frame);
}

- (CGFloat)getWidth
{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)getX
{
    return self.frame.origin.x;
}

- (CGFloat)getY
{
    return self.frame.origin.y;
}

@end
