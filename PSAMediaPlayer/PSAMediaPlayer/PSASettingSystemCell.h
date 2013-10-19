//
//  PSASettingSystemCell.h
//  pdemos1
//
//  Created by BuG.BS on 13-10-13.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSASettingSystemCell : UITableViewCell

- (void)hidePartOfCell:(CGFloat)partHeight;

@property (weak, nonatomic) IBOutlet UILabel *settingLabel;

@end
