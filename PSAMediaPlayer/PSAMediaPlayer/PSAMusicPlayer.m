//
//  PSAMusicPlayer.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-17.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSAMusicPlayer.h"
#import "PSAMusicConstantsConfig.h"
#import "PSARadioPlayer.h"
#import "PSARadioConstantsConfig.h"
#import "NSArray+Data.h"

static PSAMusicPlayer *psaMusicPlayerInstance;
static int songIndex;
static int shufflePlayIndex;
static int musicViewState;
static int musicPlayerState;

@interface PSAMusicPlayer()
@property (nonatomic, strong) NSString *musicBasePath;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (strong, nonatomic) PSATunesList *currentList;
@property (strong, nonatomic) NSMutableArray *localLists;
@property (strong, nonatomic) NSMutableArray *addTuneArray;
@end

@implementation PSAMusicPlayer

+ (PSAMusicPlayer *)sharedPSAMusicPlayer
{
    static dispatch_once_t PSAFileManagerLock;
    dispatch_once(&PSAFileManagerLock, ^{
        psaMusicPlayerInstance = [[PSAMusicPlayer alloc] init];
    });

    return psaMusicPlayerInstance;
}

- (NSMutableArray *)localLists
{
    if (_localLists == nil) {
        
        _localLists = [[NSMutableArray alloc] initWithArray:[NSArray loadFromFile:kLocalTunesFileName key:kLocalTunesKey]];
    }
    return _localLists;
}

- (NSMutableArray *)addTuneArray
{
    if (_addTuneArray == nil) {
        _addTuneArray = [[NSMutableArray alloc] init];
    }
    return _addTuneArray;
}

- (void)serialze
{
    [self.localLists saveToFile:kLocalTunesFileName key:kLocalTunesKey atomically:YES];
}

- (BOOL)firstLoad
{
    return firstLoad;
}

- (void)firstLoadFinished
{
    firstLoad = NO;
}

- (void)playOrder
{
    [shufflePlayArray removeAllObjects];
    for (int i=0; i<[self.currentList count]; ++i) {
        [shufflePlayArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    shufflePlayIndex=songIndex;
    playTime = 0;
    psaMusicPlayerInstance.numberOfLoops = 0;
}

- (void)playShuffle
{
    int tempNumber = 0;
    NSString *tempString;
    BOOL equalOrNot;
    [shufflePlayArray removeAllObjects];
    [shufflePlayArray addObject:[NSString stringWithFormat:@"%d",songIndex]];
    do {
        tempNumber = (arc4random() % [self.currentList count]);
        
        tempString = [NSString stringWithFormat:@"%i",tempNumber];
        
        equalOrNot = YES;
        for(int countNum=0;countNum<[shufflePlayArray count];countNum++)
        {
            if([tempString isEqualToString:[shufflePlayArray objectAtIndex:countNum]])
            {
                equalOrNot = NO;
                break;
            }
        }
        if (equalOrNot==YES) {
            [shufflePlayArray addObject:tempString];
        }
    } while ([shufflePlayArray count]<[self.currentList count]);
    shufflePlayIndex = 0;
    playTime = 0;
    psaMusicPlayerInstance.numberOfLoops = 0;
}

- (void)playCycle
{
    [shufflePlayArray removeAllObjects];
    for (int i=0; i<[self.currentList count]; ++i) {
        [shufflePlayArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    shufflePlayIndex=songIndex;
    playTime = 100;
    psaMusicPlayerInstance.numberOfLoops = 100;
}

#pragma mark Init Method

- (id)init
{
    self = [super init];
    if (self) {
        [self initFileManagement];
        [self initTunesList];
        [self setMusicViewState:kExitState];
        songIndex = 0;
        musicPlayerState = kMusicPlayerStateStop;
        nowPlayingSource = 0;
        currentShowListIndex = 3;
        playTime = 0;
        firstLoad = YES;
    }
    return self;
}

- (void)initFileManagement
{
    self.fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.musicBasePath = [paths objectAtIndex:0];
}

- (void)initTunesList
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:
     [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]  forKey:@"MusicPlayerFirstLoad"]];
    
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"MusicPlayerFirstLoad"];
    
    if ([number boolValue]==YES) {
        musicListPath = [[NSBundle mainBundle] pathForResource:@"MusicList" ofType:@"plist"] ;
        musicListDictionary = [NSDictionary dictionaryWithContentsOfFile:musicListPath];
        
        NSMutableArray *diskList1 = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
        self.currentList = [self createTunesList:@"_Disk1" WithArray:diskList1];
        [self addTunesListToLists:self.currentList];
        
        NSMutableArray *diskList2 = [[NSMutableArray alloc] initWithObjects:@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",nil];
        [self addTunesListToLists:[self createTunesList:@"_Disk2" WithArray:diskList2]];
        
        NSMutableArray *diskList3 = [[NSMutableArray alloc] initWithObjects:@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",nil];
        [self addTunesListToLists:[self createTunesList:@"_Disk3" WithArray:diskList3]];
        
        //     favorites
        
        NSMutableArray *favoritesList1 = [[NSMutableArray alloc] initWithObjects:@"0",@"20",@"44",@"5",@"7",@"12",@"52",@"12",@"29",@"65",@"63",@"70",nil];
        [self addTunesListToLists:[self createTunesList:@"_Favo" WithArray:favoritesList1]];
        
        //     Device
        
        NSMutableArray *deviceList1 = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"21",@"22",@"23",@"24",@"25",@"61",@"62",@"70",@"71",@"40",@"41",nil];
        [self addTunesListToLists:[self createTunesList:@"_DeviFan's iPhone" WithArray:deviceList1]];
        
        NSMutableArray *deviceList2 = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"6",@"7",@"25",@"26",@"28",@"60",@"65",@"67",@"45",@"52",@"20",@"75",nil];
        [self addTunesListToLists:[self createTunesList:@"_DeviFan's iPad" WithArray:deviceList2]];
        
        //     list
        
        NSMutableArray *songList1 = [[NSMutableArray alloc] initWithObjects:@"1",@"10",@"20",@"31",@"7",@"65",@"72",nil];
        [self addTunesListToLists:[self createTunesList:@"_ListFreedom" WithArray:songList1]];
        
        NSMutableArray *songList2 = [[NSMutableArray alloc] initWithObjects:@"0",@"2",@"12",@"60",@"68",@"73",@"75",@"49",nil];
        [self addTunesListToLists:[self createTunesList:@"_ListOn The Road" WithArray:songList2]];
        
        NSMutableArray *songList3 = [[NSMutableArray alloc] initWithObjects:@"5",@"8",@"11",@"22",@"27",@"31",nil];
        [self addTunesListToLists:[self createTunesList:@"_ListMy Love" WithArray:songList3]];
        
        NSArray *tempMyLists = [NSArray arrayWithObjects:diskList1,diskList2,diskList3,favoritesList1,deviceList1,deviceList2,songList1,songList2,songList3,nil];
        [tempMyLists saveToFile:kLocalTunesFileName key:kLocalTunesKey atomically:YES];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MusicPlayerFirstLoad"];
        
    }else{
        self.currentList = [self.localLists objectAtIndex:3];
    }
    shufflePlayArray = [[NSMutableArray alloc] initWithObjects:nil];
    [self playOrder];
    songCount = [self.currentList count];
}

#pragma Music Control

- (PSATune *)loadMusicWithTunesList:(PSATunesList *)tunesList withDelegate:(id)delegate
{
    PSATune *tune = [tunesList tuneAtIndex: songIndex];
    nowPlayingTune = tune;
    
    [PSAMusicPlayer needSaveMusic:tune.songName];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",tune.songName]];
    NSURL* url = [NSURL fileURLWithPath:uniquePath];
    
    psaMusicPlayerInstance = [psaMusicPlayerInstance initWithContentsOfURL:url error:nil];
    psaMusicPlayerInstance.delegate = delegate;
    psaMusicPlayerInstance.numberOfLoops = playTime;
    psaMusicPlayerInstance.volume = 1.0f;
    [psaMusicPlayerInstance prepareToPlay];
    
    return tune;
}

- (void)playTuneAtIndex:(int)index withDelegate:(id)delegate
{
    PSATune *tune = [self.currentList tuneAtIndex:index];
    nowPlayingTune = tune;
    
    [PSAMusicPlayer needSaveMusic:tune.songName];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",tune.songName]];
    NSURL* url = [NSURL fileURLWithPath:uniquePath];
    
    [psaMusicPlayerInstance stop];
    psaMusicPlayerInstance = [psaMusicPlayerInstance initWithContentsOfURL:url error:nil];
    psaMusicPlayerInstance.delegate = delegate;
    psaMusicPlayerInstance.numberOfLoops = playTime;
    psaMusicPlayerInstance.volume= 1.0f;
    [psaMusicPlayerInstance prepareToPlay];
    [psaMusicPlayerInstance play];
    musicPlayerState = kMusicPlayerStatePlaying;
}

#pragma mark Tune Method

- (PSATune *)getCurrentTune
{
    return nowPlayingTune;
}

- (void)addTuneToArray:(PSATune *)tune
{
    [self.addTuneArray addObject:tune];
}

- (void)removeTuneFromArray:(PSATune *)tune
{
    [self.addTuneArray removeObject:tune];
}

- (void)clearAddArray
{
    [self.addTuneArray removeAllObjects];
}

- (int)getAddArrayCount
{
    return [self.addTuneArray count];
}

- (void)addTuneToListFromArray:(NSString *)listName
{
    BOOL inList = NO;
    for (PSATunesList *tunesList in self.localLists) {
        if ([tunesList.listName isEqualToString:listName]) {
            for (int i=0; i<[self.addTuneArray count]; ++i) {
                PSATune *tune = [self.addTuneArray objectAtIndex:i];
                for (int j=0; j<[tunesList count]; ++j) {
                    if ([tune.songName isEqualToString:[tunesList tuneAtIndex:j].songName]) {
                        inList = YES;
                        break;
                    }
                }
                if (inList == NO) {
                    [tunesList addTune:tune];
                }
                inList = NO;
            }
        }
    }
    [self serialze];
    [self clearAddArray];
}

- (void)addTune:(PSATune *)tune toList:(NSString *)listName
{
    for (PSATunesList *tunesList in self.localLists) {
        if ([[tunesList getNameWithoutHeader] isEqualToString:listName]) {
            [tunesList addTune:tune];
        };
    }
    [self serialze];
}

- (void)exchangeObjectInShowListAtIndex:(int)preIndex withObjectAtIndex:(int)newIndex
{
    [[[PSAMusicPlayer sharedPSAMusicPlayer] getCurrentShowList] exchangeObjectAtIndex:preIndex withObjectAtIndex:newIndex];
    [[PSAMusicPlayer sharedPSAMusicPlayer] serialze];
}

- (void)playMusic
{
    if ([[PSARadioPlayer sharedPSARadioPlayer] getRadioPlayerState] == kRadioPlayerStatePlaying) {
        [[PSARadioPlayer sharedPSARadioPlayer] setRadioPlayerState:kRadioPlayerStateStop];
        [[PSARadioPlayer sharedPSARadioPlayer] pause];
    }
    musicPlayerState = kMusicPlayerStatePlaying;
    [psaMusicPlayerInstance play];
}

- (void)pauseMusic
{
    musicPlayerState = kMusicPlayerStateStop;
    [psaMusicPlayerInstance pause];
}

#pragma mark List Method

- (NSMutableArray *)getShufflePlayArray
{
    return shufflePlayArray;
}

- (PSATunesList *)getCurrentList
{
    return self.currentList;
}

- (void)setCurrentListWithIndex:(int)index
{
    self.currentList = [self.localLists objectAtIndex:index];
    songCount = [self.currentList count];
    [self playOrder];
}

- (void)setCurrentShowListIndex:(int)index
{
    currentShowListIndex = index;
}

- (int)getCurrentShowListIndex
{
    return currentShowListIndex;
}

- (PSATunesList *)getCurrentShowList
{
    return [self getListWithIndex:[self getCurrentShowListIndex]];
}

- (void)addTunesListToLists:(PSATunesList *)list
{
    [self.localLists addObject:list];
}

- (void)createNewList:(NSString *)listName
{
    PSATunesList *tempList = [PSATunesList createTunesList];
    tempList.listName = [@"_List" stringByAppendingString:listName];
    [self addTunesListToLists:tempList];
    [self serialze];
}

- (PSATunesList *)getListWithIndex:(int)index
{
    return [self.localLists objectAtIndex:index];
}

#pragma mark Music Data Method

- (int)getListsCountWithHeader:(NSString *)header
{
    int count = 0;
    for (PSATunesList *tunesList in self.localLists) {
        if ([[tunesList.listName substringToIndex:5] isEqualToString:header]) {
            count++;
        };
    }
    return count;
}

- (void)setNowPlayingSource:(int)source
{
    nowPlayingSource = source;
}

- (int)getNowPlayingSource
{
    return nowPlayingSource;
}

- (int)getSongCount
{
    return songCount;
}

- (int)setShufflePlayIndex:(int)index
{
    shufflePlayIndex = index;
    return shufflePlayIndex;
}

- (int)getShufflePlayIndex
{
    return shufflePlayIndex;
}

- (int)currentTune
{
    return songIndex;
}

- (void)resetTune
{
    songIndex = 0;
}

- (void)setTuneIndex:(int)index
{
    songIndex = index;
}

- (void)setMusicViewState:(int)state
{
    musicViewState = state;
}

- (int)getMusicViewState
{
    return musicViewState;
}

- (void)setPlayMode:(int)mode
{
    playMode = mode;
}

- (int)getPlayMode
{
    return playMode;
}

- (int)getMusicPlayerState
{
    return musicPlayerState;
}

#pragma mark Private Method

- (PSATunesList *)createTunesList:(NSString *)listName WithArray:(NSMutableArray*)array
{
    PSATunesList *tempList = [PSATunesList createTunesList];
    for (int i=0; i<[array count];i++) {
        PSATune *tune = [PSATune loadMusicInfoWithName:[[musicListDictionary objectForKey:[array objectAtIndex:i]] objectForKey:kSongName] singer:[[musicListDictionary objectForKey:[array objectAtIndex:i]] objectForKey:kSingerName] album:[[musicListDictionary objectForKey:[array objectAtIndex:i]] objectForKey:kAlbumName]];
        [tempList addTune:tune];
    }
    tempList.listName = listName;
    return tempList;
}

+ (BOOL)needSaveMusic:(NSString *)name
{
    if ([[PSAMusicPlayer sharedPSAMusicPlayer].fileManager fileExistsAtPath:[[PSAMusicPlayer sharedPSAMusicPlayer].musicBasePath stringByAppendingPathComponent:[name stringByAppendingFormat:@".mp3"]]]){
        return false;
    } else {
        [[PSAMusicPlayer sharedPSAMusicPlayer] saveMusicToLocal:name];
        NSString *deletePath = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:deletePath];
        if (blHave) {
            NSFileManager *manager = [NSFileManager defaultManager];
            [manager removeItemAtPath:deletePath error:nil];
        }
        
        return true;
    }
}

- (void)saveMusicToLocal:(NSString *)name
{
    NSArray *paths;
    NSString *plistPathInDoc;
    NSString *achievementFinishedPath;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
    
    paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    plistPathInDoc = [paths objectAtIndex:0];
    
    achievementFinishedPath =[plistPathInDoc stringByAppendingPathComponent:[name stringByAppendingFormat:@".mp3"]];
    NSData *musicData = [NSData dataWithContentsOfFile:plistPath];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createFileAtPath:achievementFinishedPath contents:musicData attributes:nil];
}

@end
