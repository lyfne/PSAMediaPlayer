//
//  PSAMusicPlusCell.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-11.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicPlusCellDelegate

- (void)showView;

@end

@interface PSAMusicPlusCell : UITableViewCell{
    BOOL isSelected;
}

@property (weak, nonatomic) id<MusicPlusCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *tunesNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)otherAction:(id)sender;

+ (PSAMusicPlusCell *)createMusicPlusCell:(NSString *)xibName;

- (void)hidePartOfCell:(CGFloat)partHeight;

- (void)setIsSelected:(BOOL)selected;

@end
