//
//  PSAMusicListViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-23.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicListViewController.h"
#import "PSAMusicListCell.h"
#import "PSAMusicPlayer.h"
#import "PSAAppListHeaderView.h"
#import "IBXTableViewDataSource.h"
#import "IBXTableViewDataItem.h"
#import "PSAMusicCoverListItem.h"

#define kPSAMusicListViewControllerNibName @"PSAMusicListViewController"
#define kfavoriteButtonTag 999
#define kListCellTagOffset 500

@interface PSAMusicListViewController (){
    IBXTableView * _tableView;
    IBXTableViewDataSource * _tableViewDataSource;
}
@end

@implementation PSAMusicListViewController
@synthesize listTableView;
@synthesize editButton,switchSowButton;
@synthesize listBGImageView,listEditBGImageView,listTableBGImageView,editScrollView;

+ (PSAMusicListViewController *)createMusicListViewController
{
    return [[PSAMusicListViewController alloc] initWithNibName:kPSAMusicListViewControllerNibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.clipsToBounds = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[PSAMusicPlayer sharedPSAMusicPlayer] setCurrentShowListIndex:currentListIndex];
    [self ListReloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initTableView];
    [self loadCoverView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Function

- (void)initData
{
    firstLoad = YES;
    currentListIndex = initDiskIndex-3;
    switchButtonState = kSwitchButtonCoverState;
    editButtonState = kEditButtonNormalState;
}

- (void)initTableView
{
    listTableView.delegate = self;
    listTableView.dataSource = self;
}

#pragma mark Cover View Method

- (void)loadCoverView
{
    if (firstLoad == NO) {
        [self removeCoverView];
    }
    if (switchButtonState==kSwitchButtonListState) {
        self.musicListCoverViewController = [PSAMusicListCoverViewController createMusicListCoverViewController];
        [self.musicListCoverViewController.view setX:kCoverViewX Y:kCoverViewY];
        [self.view addSubview:self.musicListCoverViewController.view];
    }else{
        [self loadIBXTableView];
    }
}

- (void)removeCoverView
{
    if (switchButtonState == kSwitchButtonListState) {
        [_tableView removeFromSuperview];
        _tableView = nil;
        _tableViewDataSource = nil;
    }else{
        [self.musicListCoverViewController.view removeFromSuperview];
    }
}

#pragma mark IBXTableViewDelegate

- (void)createItemWithTune:(PSATune *)tune
{
    PSAMusicCoverListItem * item = [[PSAMusicCoverListItem alloc] init];
    item.title = tune.songName;
    item.subTitle = tune.albumName;
    item.thiTitle = tune.singerName;
    item.albumName = [tune.albumName stringByAppendingFormat:@"Small.png"];
    [_tableViewDataSource addItem:item];
}

- (void)cellClicked:(NSUInteger)index
{
    if (editButtonState!=kEditButtonSelectedState) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] setNowPlayingSource:kNowPlayingSourceList];
        
        if (![[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentTune].songName isEqualToString:[[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentShowList] tuneAtIndex:index].songName]) {
            [[PSAMusicPlayer sharedPSAMusicPlayer] setTuneIndex:index];
            [[PSAMusicPlayer sharedPSAMusicPlayer] setCurrentListWithIndex:[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentShowListIndex]];
            if ([[PSAMusicPlayer sharedPSAMusicPlayer] getPlayMode] == kPlayModeShuffle) {
                [[PSAMusicPlayer sharedPSAMusicPlayer] playShuffle];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchSongNotifySign object:self];
        }
    }
}

- (void)cellDeleted:(NSUInteger)index
{
    [_tableViewDataSource removeItemAtIndex:index];
    [[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentShowList] removeTuneAtIndex:index];
    [[PSAMusicPlayer sharedPSAMusicPlayer] serialze];
    [listTableView reloadData];
}

#pragma mark Mini Function

- (void)loadIBXTableView
{
    if (_tableView == nil) {
        _tableView = [[IBXTableView alloc] init];
        _tableViewDataSource = [[IBXTableViewDataSource alloc] init];
        _tableView.ibxDelegate = self;
        _tableView.ibxDataSource = _tableViewDataSource;
        _tableView.frame = CGRectMake(kCoverViewX, kCoverViewY, kCoverViewWidght, kCoverViewHeight);
        [self.view addSubview:_tableView];
        
        for (int i=0; i<([[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentShowList] count]); ++i) {
            PSATune *tune = [[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentShowList] tuneAtIndex:i];
            [self createItemWithTune:tune];
        }
    }else{
        [_tableView removeFromSuperview];
        _tableView = nil;
        _tableViewDataSource = nil;
        [self loadIBXTableView];
    }
}

#pragma mark IBAction Method

- (IBAction)switchShowMode:(id)sender {
    if (switchButtonState == kSwitchButtonListState) {
        switchButtonState = kSwitchButtonCoverState;
        [switchSowButton setTitle:@"Cover Mode" forState:UIControlStateNormal];
    }else{
        switchButtonState = kSwitchButtonListState;
        [switchSowButton setTitle:@"List Mode" forState:UIControlStateNormal];
    }
    [self loadCoverView];
}

- (IBAction)editAction:(id)sender {
    if (editButtonState == kEditButtonNormalState) {
        editButtonState = kEditButtonSelectedState;
        [editButton setTitle:@"Done" forState:UIControlStateNormal];
        [_tableView switchToMode:kEditButtonSelectedState];
        switchSowButton.hidden = YES;
    }else{
        editButtonState = kEditButtonNormalState;
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [_tableView switchToMode:kEditButtonNormalState];
        switchSowButton.hidden = NO;
    }
}

#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return ([[PSAMusicPlayer sharedPSAMusicPlayer] getListsCountWithHeader:kListHeader]+1);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PSAAppListHeaderView *headerView = [PSAAppListHeaderView createAppListHeaderView];
    if (section == 0) {
        headerView.sectionNameLabel.text = @"DEAFULT";
    }else {
        headerView.sectionNameLabel.text = [NSString stringWithFormat:@"MY LIST(%d)",[[PSAMusicPlayer sharedPSAMusicPlayer] getListsCountWithHeader:kListHeader]];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idStr = @"PSAMusicListCell";
    static NSString *idPlusStr = @"PSAMusicPlusCell";
    if (indexPath.section==0) {
        PSAMusicPlusCell *cell = [listTableView dequeueReusableCellWithIdentifier:idPlusStr];
        if (cell==nil) {
            cell = [PSAMusicPlusCell createMusicPlusCell:idPlusStr];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        if (editButtonState==kEditButtonSelectedState) {
            cell.userInteractionEnabled = NO;
        }else{
            cell.userInteractionEnabled = YES;
        }
        
        cell.tag = kfavoriteButtonTag;
        cell.detailLabel.text = @"Favorites";
        cell.actionButton.hidden = YES;
        cell.headerImageView.image = [UIImage imageNamed:@"List_like.png"];
        cell.tunesNumLabel.text = [NSString stringWithFormat:@"%d",[[[PSAMusicPlayer sharedPSAMusicPlayer] getListWithIndex:initDiskIndex-3] count]];
        
        if (firstLoad) {
            [cell setIsSelected:YES];
            firstLoad = NO;
        }
        
        return cell;
    }else {
        if (indexPath.row==0) {
            PSAMusicPlusCell *cell = [listTableView dequeueReusableCellWithIdentifier:idPlusStr];
            if (cell==nil) {
                cell = [PSAMusicPlusCell createMusicPlusCell:idPlusStr];
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            if (editButtonState==kEditButtonSelectedState) {
                cell.userInteractionEnabled = NO;
            }else{
                cell.userInteractionEnabled = YES;
            }
            
            cell.delegate = self;
            cell.tag = indexPath.section*kListCellTagOffset+indexPath.row;
            cell.detailLabel.text = @"Create new list...";
            cell.headerImageView.image = [UIImage imageNamed:@"List_plus_deviceList.png"];
            cell.tunesNumLabel.hidden = YES;
            
            return cell;
            
        }else{
            PSAMusicListCell *cell = [listTableView dequeueReusableCellWithIdentifier:idStr];
            if (cell==nil) {
                cell = [PSAMusicListCell createMusicListCell:idStr];
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            if (editButtonState==kEditButtonSelectedState) {
                cell.userInteractionEnabled = NO;
            }else{
                cell.userInteractionEnabled = YES;
            }
            
            cell.tag = indexPath.section*kListCellTagOffset+indexPath.row;
            PSATunesList *tunesList = [[PSAMusicPlayer sharedPSAMusicPlayer] getListWithIndex:indexPath.row-1+initDiskIndex];
            cell.listNameLabel.text = [tunesList getNameWithoutHeader];
            cell.listSongNumLabel.text = [NSString stringWithFormat:@"%d",[tunesList count]];
            
            return cell;
        }
    }
}

#pragma TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editButtonState!=kEditButtonSelectedState) {
        for (int i=0; i<[[PSAMusicPlayer sharedPSAMusicPlayer] getListsCountWithHeader:kListHeader]+1; ++i) {
            [(PSAMusicListCell *)[tableView viewWithTag:kListCellTagOffset+i] setIsSelected:NO];
            [(PSAMusicPlusCell *)[tableView viewWithTag:kfavoriteButtonTag] setIsSelected:NO];
        }
        
        if (indexPath.section == 0) {
            [[PSAMusicPlayer sharedPSAMusicPlayer] setCurrentShowListIndex:initDiskIndex-3];
            if (switchButtonState == kSwitchButtonCoverState) {
                [self loadIBXTableView];
            }else if(switchButtonState == kSwitchButtonListState){
                [self.musicListCoverViewController reloadData];
            }
            currentListIndex = initDiskIndex-3;
            
            [(PSAMusicPlusCell *)[tableView viewWithTag:kfavoriteButtonTag] setIsSelected:YES];
            
        }else{
            [[PSAMusicPlayer sharedPSAMusicPlayer] setCurrentShowListIndex:indexPath.row-1+initDiskIndex];
            if (switchButtonState==kSwitchButtonCoverState) {
                [self loadIBXTableView];
            }else if (switchButtonState == kSwitchButtonListState){
                [self.musicListCoverViewController reloadData];
            }
                
            currentListIndex = indexPath.row-1+initDiskIndex;
                
            [(PSAMusicListCell *)[tableView viewWithTag:indexPath.section*kListCellTagOffset+indexPath.row] setIsSelected:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (PSAMusicListCell *cell in listTableView.visibleCells) {
        CGFloat hiddenFrameHeight = scrollView.contentOffset.y + kPSAStoreListHeaderViewHeight - cell.frame.origin.y;
        if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
            [cell hidePartOfCell:hiddenFrameHeight];
        }
    }
}

#pragma mark MusicPlusCellDelegate

- (void)showView
{
    [self.delegate addCreateView];
}

#pragma mark MusicCreateDelegate

- (void)ListReloadData
{
    [self.listTableView reloadData];
}

@end
