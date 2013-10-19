//
//  PSAVideoNowPlayingViewController.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PSAVideoNowPlayingSegmentViewController.h"

@protocol VideoNowPlayingDelegate

- (void)resetToNormalSize;

@end

@interface PSAVideoNowPlayingViewController : UIViewController<VideoNowPlayingSegmentDelegate>{
    MPMoviePlayerController *moviePlayer;
    NSTimer *processTimer;
}

- (void)initPlayerController:(NSString *)videoName;
- (void)stopVideo;

@property (weak, nonatomic) id<VideoNowPlayingDelegate> delegate;

@property (strong, nonatomic) PSAVideoNowPlayingSegmentViewController *videoNowPlayingSegmentViewController;

+ (PSAVideoNowPlayingViewController *)createVideoNowPlayingViewController;

@end
