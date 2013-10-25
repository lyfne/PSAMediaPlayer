//
//  PSAMusicOnlineViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-23.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicOnlineDelegate

- (void)addLoginView;

@end

@interface PSAMusicOnlineViewController : UIViewController

+ (PSAMusicOnlineViewController *)createMusicOnlineViewController;

@property (weak, nonatomic) id<MusicOnlineDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *diskImage1;
@property (weak, nonatomic) IBOutlet UIImageView *diskImage2;
@property (weak, nonatomic) IBOutlet UIImageView *diskImage3;
@property (weak, nonatomic) IBOutlet UIImageView *diskImage4;
@property (weak, nonatomic) IBOutlet UIImageView *diskImage5;

@end
