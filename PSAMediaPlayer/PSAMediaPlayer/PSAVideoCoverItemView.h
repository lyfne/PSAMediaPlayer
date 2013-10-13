//
//  PSAVideoCoverItemView.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-21.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAVideoCoverItemView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieTimeLabel;

+ (PSAVideoCoverItemView *)createVideoItemViewWithName:(NSString *)movieName time:(NSString *)movieTime;

@end
