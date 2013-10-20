//
//  PSAMusicListViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-23.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSAMusicListCoverViewController.h"
#import "PSAMusicConstantsConfig.h"
#import "IBXTableView.h"
#import "PSAMusicPlusCell.h"
#import "PSAMusicCreateListViewController.h"

@protocol MusicListDelegate

- (void)addCreateView;

@end

@interface PSAMusicListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,IBXTableViewDelegate,MusicPlusCellDelegate,MusicCreateDelegate>
{
    int favoritesState;
    int switchButtonState;
    int editButtonState;
    int currentListIndex;
    
    BOOL firstLoad;
}

@property (weak, nonatomic) id<MusicListDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (weak, nonatomic) IBOutlet UIButton *switchSowButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIImageView *listBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *listTableBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *listEditBGImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *editScrollView;

@property (strong, nonatomic) PSAMusicListCoverViewController *musicListCoverViewController;

+ (PSAMusicListViewController *)createMusicListViewController;

- (IBAction)switchShowMode:(id)sender;
- (IBAction)editAction:(id)sender;

@end
