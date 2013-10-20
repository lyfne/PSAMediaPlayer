//
//  PSAMusicListCoverWithListViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-27.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSAMusicListModeCell.h"

@protocol CoverListSyncDelegate

- (void)syncSong:(int)add;
- (void)syncFinished;

@end

@interface PSAMusicListCoverWithListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CoverListCellDelegate>{
    int listIndex;
    int listMode;
    NSString *nameStr;
}

@property (weak, nonatomic) id<CoverListSyncDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *coverWithListTableView;

+ (PSAMusicListCoverWithListViewController *)createMusicListCoverWithListViewController;

- (void)reloadDataWithIndex:(int)index;
- (void)switchToMode:(int)mode;
- (void)resetSelectedArray;
- (void)syncMusicToLocal;

@end
