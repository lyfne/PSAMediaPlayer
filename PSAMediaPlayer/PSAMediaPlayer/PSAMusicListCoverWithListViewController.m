//
//  PSAMusicListCoverWithListViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-27.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicListCoverWithListViewController.h"
#import "PSAMusicPlayer.h"
#import "PSAMusicConstantsConfig.h"

#define kPSAMusicListCoverWithListViewControllerNibName @"PSAMusicListCoverWithListViewController"
#define kCellOffset 3000

@interface PSAMusicListCoverWithListViewController ()
@property (strong, nonatomic)NSMutableArray *selectedCellArray;
@end

@implementation PSAMusicListCoverWithListViewController
@synthesize coverWithListTableView;

+ (PSAMusicListCoverWithListViewController*)createMusicListCoverWithListViewController
{
    return [[PSAMusicListCoverWithListViewController alloc] initWithNibName:kPSAMusicListCoverWithListViewControllerNibName bundle:nil];
}

- (NSMutableArray *)selectedCellArray
{
    if (_selectedCellArray == nil) {
        _selectedCellArray = [[NSMutableArray alloc] init];
    }
    return _selectedCellArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.selectedCellArray removeAllObjects];
    listMode = kEditButtonNormalState;
    listIndex = initDiskIndex-3;
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initTableView
{
    coverWithListTableView.delegate = self;
    coverWithListTableView.dataSource = self;
}

#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([[[PSAMusicPlayer sharedPSAMusicPlayer] getListWithIndex:listIndex] count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idStr = @"PSAMusicListModeCell";
    PSAMusicListModeCell *cell = [coverWithListTableView dequeueReusableHeaderFooterViewWithIdentifier:idStr];
    if (cell==nil) {
        cell = [PSAMusicListModeCell createMusicListModeCell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    PSATune *tune = [[[PSAMusicPlayer sharedPSAMusicPlayer] getListWithIndex:listIndex] tuneAtIndex:indexPath.row];
    cell.delegate = self;
    cell.songNameLabel.text = tune.songName;
    cell.singerNameLabel.text = tune.singerName;
    cell.albumNameLabel.text = tune.albumName;
    cell.albumImageView.image = [UIImage imageNamed:[tune.albumName stringByAppendingString:@"Small.png"]];
    cell.tag = indexPath.row + kCellOffset;
    
    for (int i=0;i<[self.selectedCellArray count];i++) {
        if (indexPath.row==[[self.selectedCellArray objectAtIndex:i] intValue]) {
            cell.bgImageView.image = [UIImage imageNamed:@"Device_coverlist_selected.png"];
            [cell.selectButton setImage:[UIImage imageNamed:@"Device_check.png"] forState:UIControlStateNormal];
            [cell setIsSelected:YES];
        }
    }
        
    
    if (listMode == kEditButtonSelectedState) {
        [cell editMode];
    }else{
        [cell normalMode];
    }
    return cell;
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (listMode!=kEditButtonSelectedState) {
        [[PSAMusicPlayer sharedPSAMusicPlayer] setNowPlayingSource:kNowPlayingSourceDevice];
        if (![[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentTune].songName isEqualToString:[[[PSAMusicPlayer sharedPSAMusicPlayer] getListWithIndex:listIndex] tuneAtIndex:indexPath.row].songName]) {
            [[PSAMusicPlayer sharedPSAMusicPlayer] setTuneIndex:indexPath.row];
            [[PSAMusicPlayer sharedPSAMusicPlayer] setCurrentListWithIndex:[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentShowListIndex]];
            if ([[PSAMusicPlayer sharedPSAMusicPlayer] getPlayMode] == kPlayModeShuffle) {
                [[PSAMusicPlayer sharedPSAMusicPlayer] playShuffle];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchSongNotifySign object:self];
        }
    }else{
        [(PSAMusicListModeCell *)[tableView viewWithTag:indexPath.row+kCellOffset] cellSelectedAction];
    }
}

#pragma mark Public Method

- (void)syncMusicToLocal
{
    for (int i=0; i<[[[PSAMusicPlayer sharedPSAMusicPlayer] getListWithIndex:listIndex] count]; ++i) {
        PSAMusicListModeCell *cell = (PSAMusicListModeCell *)[coverWithListTableView viewWithTag:i+kCellOffset];
        cell.userInteractionEnabled = NO;
        [cell syncMusic];
    }
}

#pragma Mini Function

- (void)switchToEditMode
{
    for (int i=0; i<[[coverWithListTableView visibleCells] count]; i++) {
        [[[coverWithListTableView visibleCells] objectAtIndex:i] switchToEditMode];
    }
}

- (void)switchToNormalMode
{
    for (int i=0; i<[[coverWithListTableView visibleCells] count]; i++) {
        [[[coverWithListTableView visibleCells] objectAtIndex:i] switchToNormalMode];
    }
}

- (void)reloadDataWithIndex:(int)index
{
    listIndex = index;
    [coverWithListTableView reloadData];
}

- (void)switchToMode:(int)mode
{
    listMode = mode;
    if (mode==kEditButtonSelectedState) {
        [self switchToEditMode];
    }else{
        [self switchToNormalMode];
    }
}

- (void)resetSelectedArray
{
    [self.selectedCellArray removeAllObjects];
}

#pragma mark CoverListCellDelegate

- (void)reloadCoverListData
{
    [coverWithListTableView reloadData];
}

- (void)addToSelectedArrayWithTag:(int)tag
{
    [self.selectedCellArray addObject:[NSString stringWithFormat:@"%d",tag-kCellOffset]];
    [[PSAMusicPlayer sharedPSAMusicPlayer] addTuneToArray:[[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentShowList] tuneAtIndex:tag-kCellOffset]];
    [self.delegate syncSong:[self.selectedCellArray count]];
}

- (void)removeSelectedCell:(int)tag
{
    [self.selectedCellArray removeObject:[NSString stringWithFormat:@"%d",tag-kCellOffset]];
    [[PSAMusicPlayer sharedPSAMusicPlayer] removeTuneFromArray:[[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentShowList] tuneAtIndex:tag-kCellOffset]];
    [self.delegate syncSong:[self.selectedCellArray count]];
}

- (void)syncFinished
{
    for (int i=0; i<[[[PSAMusicPlayer sharedPSAMusicPlayer] getListWithIndex:listIndex] count]; ++i) {
        [coverWithListTableView viewWithTag:i+kCellOffset].userInteractionEnabled = YES;
    }
    coverWithListTableView.scrollEnabled = YES;
    [self.delegate syncFinished];
}

- (void)syncStart
{
    coverWithListTableView.scrollEnabled = NO;
}

@end
