//
//  PSAMusicListModeCell.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-26.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    PSADeviceListSyncStateDefault = 0,
    PSADeviceListSyncStateSyncing = 1,
    PSADeviceListSyncStateSynced = 2
}PSADeviceListSyncState;

@protocol CoverListCellDelegate

- (void)reloadCoverListData;
- (void)addToSelectedArrayWithTag:(int)tag;
- (void)removeSelectedCell:(int)tag;
- (void)syncFinished;
- (void)syncStart;

@end

@interface PSAMusicListModeCell : UITableViewCell{
    BOOL isSelected;
}

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) id<CoverListCellDelegate> delegate;

+ (PSAMusicListModeCell *)createMusicListModeCell;

- (void)setIsSelected:(BOOL)selected;
- (void)switchToNormalMode;
- (void)switchToEditMode;
- (void)editMode;
- (void)normalMode;

- (void)syncMusic;
- (void)cellSelectedAction;

@end
