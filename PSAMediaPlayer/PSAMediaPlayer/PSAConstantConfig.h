//
//  PSAConstantConfig.h
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-18.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#ifndef PDemoS1_PSAConstantConfig_h
#define PDemoS1_PSAConstantConfig_h

// PSAFunctionPanelState
typedef enum {
    PSAFunctionPanelStateExit = 0,
    PSAFunctionPanelStateRun = 1,
    PSAFunctionPanelStateLock = 2
} PSAFunctionPanelState;

// PSAFunctionID
typedef enum {
    PSAIDHOME = 1000,
    PSAIDMUSIC = 1001,
    PSAIDVIDEO = 1002,
    PSAIDRADIO = 1003,
    PSAIDNAVIGATION = 1004,
    PSAIDAPPS = 1005,
    PSAIDPHONE = 1006,
    PSAIDMYCAR = 1007,
    PSAIDSETTINGS = 1008,
    PSAIDLOCK = 1009,
    PSAIDSHARE = 1010,
    PSAIDFIND = 1011,
    PSAIDGUNO = 1012,
    PSAIDSTORE = 1013,
    PSAIDWEIBO = 1014,
    PSAIDNAVIGATIONFAVOR = 1015
} PSAPanelMenuID;

typedef enum {
    PSAWidgetTypeClock = 0,
    PSAWidgetTypeWeather = 1
}PSAWidgetType;

// PSAFunctionButtonSize
typedef enum {
    PSAFunctionButtonSizeNormal = 0,
    PSAFunctionButtonSizeMinimal = 1
} PSAFunctionButtonSize;

// PSAMainPanelView
#define kPSAMainPanelViewNormalWidth 916
#define kPSAMainPanelViewMinimalWidth 808
#define kPSAMainPanelViewHeight 614

//PSAMusicViewController
#define kPSAMusicPanelViewWeight 916
#define kPSAMusicPanelViewHeight 460
#define kPSAMusicPanelViewY 47

// PSAAppListViewHeader
#define kPSAStoreListHeaderViewHeight 38

// Font
#define kAvenirNextRegular @"AvenirNext-Regular"
#define kAvenirNextDemiBold @"AvenirNext-DemiBold"
#define kAvenirNextUltraLight @"AvenirNext-UltraLight"
#define kAvenirNextMedium @"AvenirNext-Medium"
#define kExitFunctionPanel @"ExitFunctionPanel" // 退出信号会由panel本身或是lock发出

#define kBackToHome @"BackToHome"

#define kNewNotification @"NewNotification"
#define kShowNotification @"ShowNotification"
#define kAdjustLockPanelWithNewNotification @"AdjustLockPanelWithNewNotification"
#define kDidShowFMF @"DidShowFMF"
#define kSelectNotification @"SelectNotification"
#define kDialPhoneNumber @"DialPhoneNumber"

#define kPlayerSourceChangeToMusic @"PlayerSourceChangeToMusic"
#define kPlayerSourceChangeToRadio @"PlayerSourceChangeToRadio"

#define kPSAAnimationDefaultDuration 0.7
#define kPSAAnimationDefaultEaseCurve CubicEaseOut

#endif
