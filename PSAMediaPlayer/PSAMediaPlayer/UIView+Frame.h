//
//  UIView+Frame.h
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x Y:(CGFloat)y;

- (void)moveXByOffset:(CGFloat)offsetX;
- (void)moveYByOffset:(CGFloat)offsetY;
- (void)moveXByOffset:(CGFloat)offsetX andOffsetY:(CGFloat)offsetY;

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width height:(CGFloat)height;

- (void)setX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height;

- (void)resizeWidthByDeltaWidth:(CGFloat)delta;
- (void)resizeHeightByDeltaHeight:(CGFloat)delta;
- (void)resizeHeightByDeltaWidth:(CGFloat)deltaWidth andDeltaHeight:(CGFloat)deltaHeight;

- (void)setCenterX:(CGFloat)x;
- (void)setCenterY:(CGFloat)y;
- (void)setCenterX:(CGFloat)x centerY:(CGFloat)y;

- (CGFloat)getWidth;
- (CGFloat)getHeight;
- (CGFloat)getX;
- (CGFloat)getY;

@end
