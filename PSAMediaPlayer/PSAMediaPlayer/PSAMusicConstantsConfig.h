//
//  PSAMusicConstantsConfig.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-24.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#ifndef PDemoS1_PSAMusicConstantsConfig_h
#define PDemoS1_PSAMusicConstantsConfig_h

//     Plist Key
#define kSongName @"SongName"
#define kAlbumName @"AlbumName"
#define kSingerName @"SingerName"

//     DVD
#define kRotateState 2
#define kStopState 1
#define kMusicDiskViewFrame CGRectMake(318+i*340, 87, 280, 280)
#define kMusicDiskImage @"Music_DVD_disk.png"
#define kMusicDiskSelectedImage @"Music_DVD_disk_onPlayingBG.png"
#define kScrollViewWidght 340*3+576
#define kTagOffset 300

//     Main
#define kMusicListTag 1001
#define kMusicDVDTag 1002
#define kMusicDevicesTag 1003
#define kMusicOnlineTag 1004
#define kMusicFromMyFriendTag 1005
#define kPSAMusicNowPlayingVCY 507
#define kMusicSegmentButtonTagBasic 1000

//     DiskView
#define kDiskLabelFrame CGRectMake(65, 103, 151, 58)
#define kTrackLabelFrame CGRectMake(66, 157, 138, 35)

//     Cell
#define kCellSelectedImage @"PSAPhoneContactCellSelectedBackground.png"
#define kCoverListCellMoveOffset 75

//     ListView
#define kSwitchButtonListState 3
#define kSwitchButtonCoverState 4
#define kSwitchButtonSelectedImage @"List_button_right_bg.png"
#define kEditButtonSelectedState 5
#define kEditButtonNormalState 6
#define kEditButtonSelectedImage @"List_button_left_bg.png"
#define kSwitchSongNotifySign @"SWITCHSONG"

//     Cover List
#define kCoverViewWidght 576
#define kCoverViewHeight 414
#define kCoverViewX 340
#define kCoverViewY 46

//     MusicPlayer
#define kLocalTunesFileName @"localTunes.plist"
#define kLocalTunesKey @"kLocalTunesKey"
#define kDiskTunesFileName @"diskTunes.plist"
#define kDiskTunesKey @"kDiskTunesKey"
#define kPlayModeShuffle 9999
#define kPlayModeOrder 9998
#define kPlayModeCycle 9997
#define kDiskListTag 2
#define kLocalListTag 1
#define initDiskIndex 6
#define kDiskHeader @"_Disk"
#define kListHeader @"_List"
#define kFavoriteHeader @"_Favo"
#define kDeviceHeader @"_Devi"
#define kNowPlayingSourceList 1
#define kNowPlayingSourceDVD 2
#define kNowPlayingSourceDevice 3
#define kOptionalViewSyncMode 100
#define kOptionalViewNormalMode 200

//     NowPlaying

#define kMusicPlayerStatePlaying 1
#define kMusicPlayerStateStop 2

#define kExitState 4
#define kBackgroundState 3
#define kNowPlayingState 2
#define kNormalState 1

#endif
