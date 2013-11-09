//
//  PSAVideoDeviceViewController.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAVideoDeviceViewController.h"
#import "PSAMusicDeviceCell.h"
#import "PSAAppListHeaderView.h"
#import "PSAMusicPlusCell.h"
#import "PSAMusicConstantsConfig.h"
#import "PSAVideoConstantsConfig.h"

#define kPSAVideoDeviceViewControllerNibName @"PSAVideoDeviceViewController"

@interface PSAVideoDeviceViewController ()

@end

@implementation PSAVideoDeviceViewController
@synthesize deviceTableView;

+ (PSAVideoDeviceViewController *)createVideoDeviceViewController
{
    return [[PSAVideoDeviceViewController alloc] initWithNibName:kPSAVideoDeviceViewControllerNibName bundle:nil];
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
    [self initData];
    [self initCoverList];
    [self initTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Init Method

- (void)initData
{
    editButtonState = kEditButtonNormalState;
}

- (void)initCoverList
{
    self.videoCoverViewController = [PSAVideoCoverViewController createVideoCoverViewController];
    [self.videoCoverViewController.view setX:kCoverViewX Y:kCoverViewY];
    [self.view addSubview:self.videoCoverViewController.view];
}

- (void)initTableView
{
    deviceTableView.delegate = self;
    deviceTableView.dataSource = self;
}

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
    headerView.sectionNameLabel.textColor = [UIColor whiteColor];
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
        cell.headerImageView.image = [UIImage imageNamed:@"Video_plus_deviceList.png"];
        cell.tunesNumLabel.hidden = YES;
        cell.detailLabel.textColor = [UIColor whiteColor];
        
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
            cell.deviceNameLabel.text = @"Fan's iPhone";
        }else{
            [cell setIsConnected:NO];
            cell.deviceNameLabel.text = @"Fan's iPad";
        }
        
        if ([cell getIsConnected]) {
            cell.connectStateImageView.image = [UIImage imageNamed:@"MusicDeviceConnected.png"];
            cell.bgImageView.image = [UIImage imageNamed:kCellSelectedImage];
            [cell.deviceNameLabel useRegularFontWithSize:20];
        }else{
            cell.connectStateImageView.image = [UIImage imageNamed:@"MusicDeviceUnconnected.png"];
            cell.userInteractionEnabled = NO;
        }
        
        cell.deviceNameLabel.textColor = [UIColor whiteColor];
        return cell;
    }
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editButtonState!=kEditButtonSelectedState) {
        
        [(PSAMusicDeviceCell *)[tableView viewWithTag:kDeviceIPhoneCellTag] setIsConnected:NO];
        
        if (indexPath.row!=0) {
            [(PSAMusicPlusCell *)[tableView viewWithTag:kDeviceSearchCellTag] setIsSelected:YES];
            [self performSelector:@selector(deselect) withObject:nil afterDelay:0.3f];
        }else{
            [(PSAMusicDeviceCell *)[tableView viewWithTag:kDeviceIPhoneCellTag] setIsConnected:YES];
        }
    }
}

- (void)deselect
{
    [(PSAMusicPlusCell *)[deviceTableView viewWithTag:kDeviceSearchCellTag] setIsSelected:NO];
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


@end
