//
//  PSAMusicCoverListItem.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-22.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicCoverListItem.h"
#import "IBXTableViewCell.h"

@implementation PSAMusicCoverListItem

+ (IBXTableViewCell *)allocTableViewCell
{
    IBXTableViewCell * cell = [[IBXTableViewCell alloc] init];
    [cell setCoverListCell];
    return cell;
}

- (void)updateCell:(IBXTableViewCell *)cell
{
    cell.titleLabel.text = [self title];
    cell.subTitleLabel.text = [self subTitle];
    cell.thiTitleLabel.text = [self thiTitle];
    cell.albumImageView.image = [UIImage imageNamed:[self albumName]];
    
    [cell layoutSubviews];
}

@end
