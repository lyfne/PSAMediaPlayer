//
//  PSAMusicPlayer.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PSATunesList.h"

@interface PSAMusicPlayer : AVAudioPlayer{
    int songCount;
    int currentShowListIndex;
    int playMode;
    int nowPlayingSource;
    int playTime;
    int optionalViewMode;
    BOOL firstLoad;
    NSString *musicListPath;
    NSDictionary *musicListDictionary;
    NSMutableArray *shufflePlayArray;
    PSATune *nowPlayingTune;
}

+ (PSAMusicPlayer *)sharedPSAMusicPlayer;

- (PSATune *)loadMusicWithTunesList:(PSATunesList *)tunesList withDelegate:(id)delegate;
- (void)playTuneAtIndex:(int)index withDelegate:(id)delegate;
- (void)playTuneWithName:(NSDictionary *)musicDic withDelegate:(id)delegate;

- (void)serialze;
- (BOOL)firstLoad;
- (void)firstLoadFinished;

- (void)playOrder;
- (void)playShuffle;
- (void)playCycle;

- (void)resetPlayer;

//     Tune

//- (void)setNowPlayingTune:(PSATune *)tune;
- (PSATune *)getCurrentTune;
- (void)addTuneToArray:(PSATune *)tune;
- (void)removeTuneFromArray:(PSATune *)tune;
- (void)clearAddArray;
- (int)getAddArrayCount;
- (void)addTuneToListFromArray:(NSString *)listName;
- (void)addTune:(PSATune *)tune toList:(NSString *)listName;
- (void)exchangeObjectAtIndex:(int)preIndex withObjectAtIndex:(int)newIndex;
- (void)exchangeObjectInShowListAtIndex:(int)preIndex withObjectAtIndex:(int)newIndex;
- (void)playMusic;
- (void)pauseMusic;

//     List

- (NSMutableArray *)getShufflePlayArray;
- (PSATunesList *)getCurrentList;
- (void)setCurrentListWithIndex:(int)index;

- (void)setCurrentShowListIndex:(int)index;
- (int)getCurrentShowListIndex;
- (PSATunesList *)getCurrentShowList;

- (void)addTunesListToLists:(PSATunesList *)list;
- (void)createNewList:(NSString *)listName;
- (PSATunesList *)getListWithIndex:(int)index;

//     Music Data

- (int)getListsCountWithHeader:(NSString *)header;
- (void)setNowPlayingSource:(int)source;
- (int)getNowPlayingSource;
- (int)getSongCount;
- (int)currentTune;
- (int)setShufflePlayIndex:(int)index;
- (int)getShufflePlayIndex;
- (void)resetTune;
- (void)setTuneIndex:(int)index;
- (void)setMusicViewState:(int)state;
- (int)getMusicViewState;
- (void)setPlayMode:(int)mode;
- (int)getPlayMode;
- (int)getMusicPlayerState;
- (int)getOptionalViewMode;
- (void)setOptionalViewMode:(int)mode;

@end
