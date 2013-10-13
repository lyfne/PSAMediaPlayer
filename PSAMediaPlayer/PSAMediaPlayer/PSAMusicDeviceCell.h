//
//  PSAMusicDeviceCell.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-27.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAMusicDeviceCell : UITableViewCell{
    BOOL isConnected;
}

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *connectStateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

+ (PSAMusicDeviceCell *)createMusicDeviceCell:(NSString *)xibName;

- (void)setIsConnected:(BOOL)connected;
- (BOOL)getIsConnected;
- (void)hidePartOfCell:(CGFloat)partHeight;

@end
