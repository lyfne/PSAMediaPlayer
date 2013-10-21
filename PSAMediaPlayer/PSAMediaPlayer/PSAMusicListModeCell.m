//
//  PSAMusicListModeCell.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-26.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicListModeCell.h"
#import "PSAMusicConstantsConfig.h"
#import "PSAMusicPlayer.h"

#define kSelectedCellBG @"Device_coverlist_selected.png"
#define kNormalCellBG @"Device_coverlist_bg.png"

#define kInitFrame CGRectMake(0,0,576,85)
#define kSelectButtonTag 999
#define kfirstAnimationWidth 450

@implementation PSAMusicListModeCell
@synthesize songNameLabel,singerNameLabel,albumNameLabel;
@synthesize bgImageView,albumImageView;
@synthesize infoView;
@synthesize selectButton;

+ (PSAMusicListModeCell *)createMusicListModeCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PSAMusicListModeCell" owner:self options:nil];
    PSAMusicListModeCell *cell = [array objectAtIndex:0];
    [cell initProgressView];
    return cell;
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

- (void)initProgressView
{
    [self.progressView setWidth:0];
}

#pragma mark Mini Function

- (void)switchToNormalMode
{
    [self moveInfoViewTo:-kCoverListCellMoveOffset withTime:0.5f];
    [[self viewWithTag:kSelectButtonTag] removeFromSuperview];
    bgImageView.image = [UIImage imageNamed:kNormalCellBG];
    [selectButton setImage:nil forState:UIControlStateNormal];
}

- (void)switchToEditMode
{
    [self moveInfoViewTo:kCoverListCellMoveOffset withTime:0.5f];
    selectButton.tag = kSelectButtonTag;
    selectButton.frame = CGRectMake(0, 0, 75, self.frame.size.height);
    [selectButton addTarget:self action:@selector(cellSelectedAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)moveInfoViewTo:(CGFloat)xNum withTime:(float)time
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:time];
    infoView.transform = CGAffineTransformTranslate(infoView.transform, xNum, 0);
    [UIView setAnimationDidStopSelector:@selector(finishAnimation)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)finishAnimation
{
    [self.delegate reloadCoverListData];
}

- (void)cellSelectedAction
{
    if ([bgImageView.image isEqual:[UIImage imageNamed:kSelectedCellBG]]) {
        bgImageView.image = [UIImage imageNamed:kNormalCellBG];
        [selectButton setImage:nil forState:UIControlStateNormal];
        [self setIsSelected:NO];
        [self.delegate removeSelectedCell:self.tag];
    }else{
        bgImageView.image = [UIImage imageNamed:kSelectedCellBG];
        [selectButton setImage:[UIImage imageNamed:@"Device_check.png"] forState:UIControlStateNormal];
        [self setIsSelected:YES];
        [self.delegate addToSelectedArrayWithTag:self.tag];
    }
}

- (void)editMode
{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = kSelectButtonTag;
    btn.frame = CGRectMake(0, 0, 75, self.frame.size.height);
    [btn addTarget:self action:@selector(cellSelectedAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    CGRect frame = infoView.frame;
    frame.origin.x = infoView.frame.origin.x+kCoverListCellMoveOffset;
    infoView.frame = frame;
}

- (void)normalMode
{
    [[self viewWithTag:kSelectButtonTag] removeFromSuperview];
    infoView.frame = kInitFrame;
}

- (void)setIsSelected:(BOOL)selected
{
    isSelected = selected;
}

- (void)syncMusic
{
    [self updateSyncState:PSADeviceListSyncStateSyncing];
    
    if (isSelected==YES) {
        [UIView animateWithDuration:2.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setWidth:kfirstAnimationWidth];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:2.5f animations:^{
                [self.progressView setWidth:self.frame.size.width];
            } completion:^(BOOL finished) {
                [self.progressView setWidth:0];
                [self updateSyncState:PSADeviceListSyncStateDefault];
            }];
        }];
    }
}

- (void)updateSyncState:(PSADeviceListSyncState)state
{
    if (state==PSADeviceListSyncStateSyncing) {
        [self.delegate syncStart];
    }else if(state==PSADeviceListSyncStateDefault) {
        [self cellSelectedAction];
        [self.delegate syncFinished];
    }
}
@end
