//
//  PSAMusicDiskView.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-24.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiskViewDelegate

- (void)resetOtherDiskBGImage;
- (void)switchDisk;

@end

@interface PSAMusicDiskView : UIView{
    BOOL isSelected;
    int diskIndex;
    NSString *selectedImageName;
    NSString *normalImageName;
    BOOL isMusic;
}


@property (weak, nonatomic) id<DiskViewDelegate> delegate;

@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UILabel *diskLabel;
@property (strong, nonatomic) UILabel *trackLabel;

- (void)setDiskLabel:(NSString *)diskStr andTrackLabel:(NSString *)trackStr;
- (void)setDiskIndex:(int)index;

- (void)setDiskLabelColor:(UIColor *)color andTrackLabelColor:(UIColor *)trackColor;
- (void)setSelectedImage:(NSString *)imageName andNormalImage:(NSString *)normalName;
- (void)setIsMusic:(BOOL)is;

- (BOOL)isSelected;
- (void)setSelectedState;
- (void)setNormalState;

@end
