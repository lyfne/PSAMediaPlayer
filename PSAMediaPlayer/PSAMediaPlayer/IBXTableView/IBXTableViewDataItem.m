//
//  IBXTableViewDataItem.m
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IBXTableViewDataItem.h"
#import "IBXTableViewCell.h"

@interface IBXTableViewDataItem ()
{
    NSString * _title;
    NSString * _subTitle;
    NSString * _thiTitle;
    NSString * _albumName;
}

@end

@implementation IBXTableViewDataItem

@synthesize title = _title;
@synthesize subTitle = _subTitle;
@synthesize thiTitle = _thiTitle;
@synthesize albumName = _albumName;

+ (IBXTableViewCell *)allocTableViewCell
{
    return [[IBXTableViewCell alloc] init];
}

- (void)updateCell:(IBXTableViewCell *)cell
{
    cell.titleLabel.text = _title;
    cell.subTitleLabel.text = _subTitle;
    
    [cell layoutSubviews];
}

- (void)dealloc
{
//    [_title release];
//    [_subTitle release];
//    [_thiTitle release];
    
    [super dealloc];
}

@end
