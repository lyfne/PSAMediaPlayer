//
//  PSARadioInternetView.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-8-4.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSARadioInternetView : UIView{
    NSString *nameStr;
    NSString *typeStr;
    NSString *detailStr;
}

@property (weak, nonatomic) IBOutlet UILabel *centerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

+ (PSARadioInternetView *)createFMViewWithName:(NSString *)name type:(NSString *)type detail:(NSString *)detail;

@end
