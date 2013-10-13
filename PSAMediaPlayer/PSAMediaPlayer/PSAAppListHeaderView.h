//
//  PSAAppListHeaderView.h
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-25.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAAppListHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UILabel *sectionNameLabel;

+ (PSAAppListHeaderView *)createAppListHeaderView;

@end
