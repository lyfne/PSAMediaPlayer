//
//  UIImage+Blur.h
//  pdemos1
//
//  Created by BuG.BS on 13-7-21.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

- (UIImage *)blurWithRadius: (CGFloat)blurRadius;

- (UIImage *)cropInRectWithX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)width Height:(CGFloat)height;

- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

+ (UIImage *)screenshotOfView:(UIView *)targetView;

@end
