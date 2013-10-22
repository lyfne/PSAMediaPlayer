//
//  PSAAppHeaderView.h
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-18.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSAAppHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerSeparatorImageView;


+ (PSAAppHeaderView *)createAppHeaderView;
- (void)setTitle:(NSString *)name;

@end
