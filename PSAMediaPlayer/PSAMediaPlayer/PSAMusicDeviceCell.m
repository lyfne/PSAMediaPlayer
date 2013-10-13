//
//  PSAMusicDeviceCell.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-27.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicDeviceCell.h"
#import "PSAMusicConstantsConfig.h"
#import <QuartzCore/QuartzCore.h>

@implementation PSAMusicDeviceCell
@synthesize bgImageView;
@synthesize deviceNameLabel;

+ (PSAMusicDeviceCell *)createMusicDeviceCell:(NSString *)xibName
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil];
    return [array objectAtIndex:0];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setIsConnected:(BOOL)connected
{
    isConnected = connected;
    if (isConnected == YES) {
        bgImageView.backgroundColor = [UIColor blackColor];
        bgImageView.alpha = 0.6;
        deviceNameLabel.textColor = [UIColor whiteColor];
    } else if (isConnected == NO){
        bgImageView.backgroundColor = [UIColor clearColor];
        bgImageView.alpha = 1.0;
        deviceNameLabel.textColor = [UIColor blackColor];
    }
}

- (BOOL)getIsConnected
{
    return isConnected;
}

- (void)hidePartOfCell:(CGFloat)partHeight
{
    self.layer.mask = [self visibleCell:partHeight / self.frame.size.height];
    self.layer.masksToBounds = YES;
}

- (CAGradientLayer *)visibleCell:(CGFloat)origin
{
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.frame = self.bounds;
    mask.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:0] CGColor], (id)[[UIColor colorWithWhite:1 alpha:1] CGColor], nil];
    mask.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:origin], [NSNumber numberWithFloat:origin], nil];
    return mask;
}

@end
