//
//  PSAMusicCoverItemView.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-30.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSATune.h"
#import "JHTickerView.h"

@interface PSAMusicCoverItemView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) JHTickerView *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;

+ (PSAMusicCoverItemView *)createMusicCoverItemViewWithTuneInfo:(PSATune *)tune;

@end
