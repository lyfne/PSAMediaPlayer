//
//  PSARadioFMView.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-4.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSARadioFMView.h"

#define kPSARadioFMViewNibName @"PSARadioFMView"

@implementation PSARadioFMView
@synthesize delegate;

+ (PSARadioFMView *)createFMViewWithValue:(NSString *)value
{
    PSARadioFMView *fmView = [PSARadioFMView createFMView];
    
    fmView->radioValue = value;
    fmView.fmValueLabel.text = value;
    
    return fmView;
}

+ (PSARadioFMView *)createFMView
{
    PSARadioFMView *fmView = [[[NSBundle mainBundle] loadNibNamed:kPSARadioFMViewNibName
                                                                         owner:self options:nil] lastObject];
    [fmView configureTuneItemView];
    
    return fmView;
}

- (void)configureTuneItemView
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFM)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)selectFM
{
    [delegate playRadioWithValue:radioValue];
}

@end
