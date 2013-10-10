//
//  UIView+Subview.h
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-24.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Subview)

- (CGFloat)calculateSuitablePositionYForNextSubview;
- (CGFloat)calculateSuitablePositionXForNextSubview;

- (CGFloat)getLastSubviewOriginY;
- (CGFloat)getLastSubViewOriginX;

- (CGFloat)getLastSubViewWidth;
- (CGFloat)getLastSubviewHeight;

@end
