//
//  PSARadioFMView.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-4.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadioFMDelegate

- (void)playRadioWithValue:(NSString *)value;

@end

@interface PSARadioFMView : UIView{
    NSString *radioValue;
}

@property (weak, nonatomic) IBOutlet UILabel *fmValueLabel;

@property (weak, nonatomic) id<RadioFMDelegate> delegate;

+ (PSARadioFMView *)createFMViewWithValue:(NSString *)value;

@end
