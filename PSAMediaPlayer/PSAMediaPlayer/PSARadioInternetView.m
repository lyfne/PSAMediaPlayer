//
//  PSARadioInternetView.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-4.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSARadioInternetView.h"

#define kPSARadioInternetViewNibName @"PSARadioInternetView"

@implementation PSARadioInternetView

+ (PSARadioInternetView *)createFMViewWithName:(NSString *)name type:(NSString *)type detail:(NSString *)detail
{
    PSARadioInternetView *internetView = [PSARadioInternetView createInternetView];
    
    internetView.centerNameLabel.text = name;
    internetView.leftNameLabel.text = name;
    internetView.typeLabel.text = type;
    internetView.detailLabel.text  =detail;
    
    return internetView;
}

+ (PSARadioInternetView *)createInternetView
{
    PSARadioInternetView *internetView = [[[NSBundle mainBundle] loadNibNamed:kPSARadioInternetViewNibName
                                                            owner:self options:nil] lastObject];
    [internetView configureInternetView];
    
    return internetView;
}

- (void)configureInternetView
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectInternet)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)selectInternet
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
