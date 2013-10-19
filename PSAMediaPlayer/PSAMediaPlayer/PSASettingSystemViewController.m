//
//  PSASettingSystemViewController.m
//  pdemos1
//
//  Created by BuG.BS on 13-10-13.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#define kPSASettingSystemViewControllerNibName @"PSASettingSystemViewController"
#define kPSASettingSystemCellNibName @"PSASettingSystemCell"
#define kPSASettingSystemCellReuseIdentifier @"PSASettingSystemCell"

#import "PSASettingSystemViewController.h"
#import "PSASettingSystemCell.h"
@interface PSASettingSystemViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    int currentWallpaper;
    BOOL isFirstShow;
}
@property (nonatomic, strong) NSArray *tableViewData;

@end

@implementation PSASettingSystemViewController

+ (PSASettingSystemViewController *)createSettingSystemViewController
{
    return [[PSASettingSystemViewController alloc] initWithNibName:kPSASettingSystemViewControllerNibName bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableViewData = @[@{@"index":@"TOUCH SCREEN", @"item":@[@"Appearance", @"Time & Location", @"Sound", @"Device & Sync", @"Accounts"]}, @{@"index":@"CAR", @"item":@[@"Cruise", @"Interior Lights", @"Exterior Lights"]}];
        currentWallpaper = 1;
        isFirstShow = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.listTableView registerNib:[UINib nibWithNibName:kPSASettingSystemCellNibName bundle:nil] forCellReuseIdentifier:kPSASettingSystemCellReuseIdentifier];
    [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self tableView:self.listTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    isFirstShow = NO;
    ((UIButton *)[self.view viewWithTag:1]).selected = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegate/Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.tableViewData objectAtIndex:section] objectForKey:@"index"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableViewData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)[[self.tableViewData objectAtIndex:section] objectForKey:@"item"]).count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSASettingSystemCell *cell = (PSASettingSystemCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.settingLabel useMediumFontWithSize:20.0f];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSASettingSystemCell *cell = (PSASettingSystemCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.settingLabel useUltraLightFontWithSize:20.0f];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 340, 38)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    [sectionView setClipsToBounds:YES];
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 37, 340, 1)];
    [seperator setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.2f]];
    [sectionView addSubview:seperator];
    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 1.0f, 340, 38)];
    [indexLabel setBackgroundColor:[UIColor clearColor]];
    [indexLabel useDemiBoldFontWithSize:12.0f];
    [indexLabel setTextColor:[UIColor colorWithWhite:0.0f alpha:0.4f]];
    indexLabel.text = [[self.tableViewData objectAtIndex:section] objectForKey:@"index"];
    [sectionView addSubview:indexLabel];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSASettingSystemCell *newCell = [tableView dequeueReusableCellWithIdentifier:kPSASettingSystemCellReuseIdentifier];
    newCell.settingLabel.text = [[[self.tableViewData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row];
    UIImageView *selectedBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PSAPhoneContactCellSelectedBackground"]];
    [selectedBackground setX:0.0f Y:0.0f Width:340 Height:60];
    newCell.selectedBackgroundView = selectedBackground;
    newCell.backgroundColor = [UIColor clearColor];
    return newCell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (PSASettingSystemCell *cell in self.listTableView.visibleCells) {
        CGFloat hiddenFrameHeight = scrollView.contentOffset.y + 38 - cell.frame.origin.y;
        if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
            [cell hidePartOfCell:hiddenFrameHeight];
        }
    }
}

- (IBAction)wallpaperButtonPressed:(UIButton *)sender
{
    if (!sender.isSelected) {
        ((UIButton *)[self.view viewWithTag:currentWallpaper]).selected = NO;
        NSString *wallpaperId = @"1";
        switch (sender.tag) {
            case 1:
                wallpaperId = @"1";
                break;
            case 2:
                wallpaperId = @"2";
                break;
            case 3:
                wallpaperId = @"3";
                break;
            case 4:
                wallpaperId = @"4";
                break;
            case 5:
                wallpaperId = @"5";
                break;
            case 6:
                wallpaperId = @"6";
                break;
            case 7:
                wallpaperId = @"Blue";
                break;
            case 8:
                wallpaperId = @"Berry";
                break;
            case 9:
                wallpaperId = @"Green";
                break;
            case 10:
                wallpaperId = @"Purple";
                break;
            case 11:
                wallpaperId = @"Orange";
                break;
            case 12:
                wallpaperId = @"Red";
                break;
            default:
                break;
        }
        NSDictionary *dictionary = @{@"id":wallpaperId};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeWallpaper" object:self userInfo:dictionary];
    }
    sender.selected = YES;
    currentWallpaper = sender.tag;
}


@end
