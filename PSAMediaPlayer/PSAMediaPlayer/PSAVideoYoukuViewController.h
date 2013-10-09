//
//  PSAVideoYoukuViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-9-10.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoYoukuDelegate

- (void)addLoginView;

@end

@interface PSAVideoYoukuViewController : UIViewController

+ (PSAVideoYoukuViewController *)createVideoYoukuViewController;

@property (weak, nonatomic) id<VideoYoukuDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *videoImage1;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage2;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage3;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage4;

@end
