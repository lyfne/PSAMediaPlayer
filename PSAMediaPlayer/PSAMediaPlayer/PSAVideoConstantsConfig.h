//
//  PSAVideoConstantsConfig.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-9-11.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#ifndef PDemoS1_PSAVideoConstantsConfig_h
#define PDemoS1_PSAVideoConstantsConfig_h

//     VideoPanel

#define kSwitchVideoNotifySign @"SWITCHVIDEO"
#define kVideoUserInfo @"VideoUserInfo"
#define kVideoSegmentButtonTagBasic 3000

//     Device

#define kSwitchButtonListState 3
#define kSwitchButtonCoverState 4
#define kEditButtonSelectedState 5
#define kEditButtonNormalState 6
#define kDeviceSearchCellTag 888
#define kDeviceIPhoneCellTag 777

//     DVD

#define kVideoDiskImage @"Video_DVD_disk.png"
#define kVideoDiskSelectedImage @"Video_DVD_disk_onPlayingBG.png"
#define kDiskScrollWidth 340*2+576
#define kVideoDiskViewFrame CGRectMake(318+i*340, 120, 280, 280)
#define kTagOffset 300

//     CoverView

#define kVideoItemViewFrame CGRectMake(20+270*(i%2),10+200*(i/2),270,195)
#define kVideoItemTagOffset 600

#endif
