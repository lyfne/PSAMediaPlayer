//
//  PSAMusicDeviceViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-23.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSAMusicListCoverWithListViewController.h"

@interface PSAMusicDeviceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CoverListSyncDelegate>
{
    int switchButtonState;
    int editButtonState;
    int selectedCellNum;
}

@property (weak, nonatomic) IBOutlet UITableView *deviceTableView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *syncButton;

@property (strong, nonatomic) PSAMusicListCoverWithListViewController *musicListCoverWithListViewController;

+ (PSAMusicDeviceViewController *)createMusicDeviceViewController;

- (IBAction)syncAction:(id)sender;
- (IBAction)editAction:(id)sender;

@end
