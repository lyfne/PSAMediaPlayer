//
//  PSAAppListHeaderView.m
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-25.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAAppListHeaderView.h"

@implementation PSAAppListHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (PSAAppListHeaderView *)createAppListHeaderView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PSAAppListHeaderView" owner:self options:nil];
    return [array objectAtIndex:0];
}

@end
