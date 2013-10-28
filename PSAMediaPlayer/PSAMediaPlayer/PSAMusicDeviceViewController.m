//
//  PSAMusicDeviceViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-23.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicDeviceViewController.h"
#import "PSAMusicConstantsConfig.h"
#import "PSAMusicDeviceCell.h"
#import "PSAMusicPlayer.h"
#import "PSAAppListHeaderView.h"
#import "PSAMusicPlusCell.h"

#define kPSAMusicDeviceViewControllerNibName @"PSAMusicDeviceViewController"
#define kDeviceIndexOffset 2
#define kDeviceSearchCellTag 888
#define kDeviceIPhoneCellTag 777

@interface PSAMusicDeviceViewController ()

@end

@implementation PSAMusicDeviceViewController
@synthesize deviceTableView;
@synthesize editButton,syncButton;

+ (PSAMusicDeviceViewController *)createMusicDeviceViewController
{
    return [[PSAMusicDeviceViewController alloc] initWithNibName:kPSAMusicDeviceViewControllerNibName bundle:nil];
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
    [[PSAMusicPlayer sharedPSAMusicPlayer] setCurrentShowListIndex:initDiskIndex-kDeviceIndexOffset];
    [self.musicListCoverWithListViewController reloadDataWithIndex:initDiskIndex-kDeviceIndexOffset];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCoverList];
    [self initTableView];
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark IBAction Method

- (IBAction)syncAction:(id)sender {
    
}

- (IBAction)editAction:(id)sender {
    if (editButtonState == kEditButtonNormalState) {
        editButtonState = kEditButtonSelectedState;
        [editButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.musicListCoverWithListViewController switchToMode:kEditButtonSelectedState];
        syncButton.hidden = NO;
    }else{
        editButtonState = kEditButtonNormalState;
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.musicListCoverWithListViewController switchToMode:kEditButtonNormalState];
        [self.musicListCoverWithListViewController resetSelectedArray];
        [[PSAMusicPlayer sharedPSAMusicPlayer] clearAddArray];
        syncButton.hidden = YES;
        [syncButton setTitle:@"Sync Songs" forState:UIControlStateNormal];
    }
    [deviceTableView reloadData];
}

#pragma mark Init Method

- (void)initData
{
    editButtonState = kEditButtonNormalState;
    selectedCellNum = 0;
}

- (void)initCoverList
{
    self.musicListCoverWithListViewController = [PSAMusicListCoverWithListViewController createMusicListCoverWithListViewController];
    [self.musicListCoverWithListViewController.view setX:kCoverViewX Y:kCoverViewY];
    [self.view addSubview:self.musicListCoverWithListViewController.view];
    self.musicListCoverWithListViewController.delegate = self;
}

- (void)initTableView
{
    deviceTableView.delegate = self;
    deviceTableView.dataSource = self;
}

#pragma mark Mini Function

#pragma mark TableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 37;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PSAAppListHeaderView *headerView = [PSAAppListHeaderView createAppListHeaderView];
    headerView.sectionNameLabel.text = @"MY DEVICES";
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idStr = @"PSAMusicDeviceCell";
    static NSString *idPlusStr = @"PSAMusicPlusCell";
    
    if (indexPath.row==2) {
        PSAMusicPlusCell *cell = [deviceTableView dequeueReusableCellWithIdentifier:idPlusStr];
        if (cell==nil) {
            cell = [PSAMusicPlusCell createMusicPlusCell:idPlusStr];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        if (editButtonState==kEditButtonSelectedState) {
            cell.userInteractionEnabled = NO;
        }else{
            cell.userInteractionEnabled = YES;
        }
        
        cell.tag = kDeviceSearchCellTag;
        cell.detailLabel.text = @"Search new device...";
        cell.headerImageView.image = [UIImage imageNamed:@"List_plus_deviceList.png"];
        cell.tunesNumLabel.hidden = YES;
        
        return cell;
        
    }else{
        PSAMusicDeviceCell *cell = [deviceTableView dequeueReusableCellWithIdentifier:idStr];
        if (cell==nil) {
            cell = [PSAMusicDeviceCell createMusicDeviceCell:idStr];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        if (editButtonState==kEditButtonSelectedState) {
            cell.userInteractionEnabled = NO;
        }else{
            cell.userInteractionEnabled = YES;
        }

        if (indexPath.row==0) {
            [cell setIsConnected:YES];
            cell.tag = kDeviceIPhoneCellTag;
        }else{
            [cell setIsConnected:NO];
        }
        
        if ([cell getIsConnected]) {
            cell.connectStateImageView.image = [UIImage imageNamed:@"MusicDeviceConnected.png"];
            cell.bgImageView.image = [UIImage imageNamed:kCellSelectedImage];
            [cell.deviceNameLabel useRegularFontWithSize:20];
        }else{
            cell.connectStateImageView.image = [UIImage imageNamed:@"MusicDeviceUnconnected.png"];
            cell.userInteractionEnabled = NO;
        }
        
        PSATunesList *tunesList = [[PSAMusicPlayer sharedPSAMusicPlayer] getListWithIndex:indexPath.row+initDiskIndex-kDeviceIndexOffset];
        cell.deviceNameLabel.text = [tunesList getNameWithoutHeader];
        return cell;
    }
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editButtonState!=kEditButtonSelectedState) {
        
        [(PSAMusicDeviceCell *)[tableView viewWithTag:kDeviceIPhoneCellTag] setIsConnected:NO];
        [[PSAMusicPlayer sharedPSAMusicPlayer] setCurrentShowListIndex:indexPath.row-kDeviceIndexOffset+initDiskIndex];
        [self.musicListCoverWithListViewController reloadDataWithIndex:indexPath.row-kDeviceIndexOffset+initDiskIndex];
            
        [(PSAMusicDeviceCell *)[tableView viewWithTag:kDeviceIPhoneCellTag] setIsConnected:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (PSAMusicDeviceCell *cell in deviceTableView.visibleCells) {
        CGFloat hiddenFrameHeight = scrollView.contentOffset.y + kPSAStoreListHeaderViewHeight - cell.frame.origin.y;
        if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
            [cell hidePartOfCell:hiddenFrameHeight];
        }
    }
}

#pragma mark CoverListSyncDelegate

- (void)syncSong:(int)add
{
    if (add!=0) {
        [syncButton setTitle:[NSString stringWithFormat:@"Sync %d Songs",add] forState:UIControlStateNormal];
        selectedCellNum = add;
    }else{
        [syncButton setTitle:@"Sync Songs" forState:UIControlStateNormal];
    }
}

- (void)syncFinished
{
    selectedCellNum = 0;
    syncButton.userInteractionEnabled = YES;
    editButton.userInteractionEnabled = YES;
    [syncButton setTitle:@"Sync songs" forState:UIControlStateNormal];
}

@end
