//
//  PSAMusicListCell.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-26.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAMusicListCell : UITableViewCell{
    BOOL isSelected;
}

@property (weak, nonatomic) IBOutlet UILabel *listNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *listSongNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

+ (PSAMusicListCell *)createMusicListCell:(NSString *)xibName;

- (void)hidePartOfCell:(CGFloat)partHeight;

- (void)setIsSelected:(BOOL)selected;

@end
