//
//  PSAAppHeaderView.m
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-18.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAAppHeaderView.h"
#define kPSAAppHeaderViewNibName @"PSAAppHeaderView"

@implementation PSAAppHeaderView

+ (PSAAppHeaderView *)createAppHeaderView
{
    PSAAppHeaderView *appHeaderView = [[[NSBundle mainBundle] loadNibNamed:kPSAAppHeaderViewNibName
                                                                 owner:self options:nil] lastObject];
    [appHeaderView configureHeaderView];
    return appHeaderView;
}

- (void)configureHeaderView
{
    self.headerSeparatorImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PSAAppSeparator"]];
}

- (void)setTitle:(NSString *)name
{
    [self.titleLabel setText:name];
    [self.titleLabel sizeToFit];
}

@end
