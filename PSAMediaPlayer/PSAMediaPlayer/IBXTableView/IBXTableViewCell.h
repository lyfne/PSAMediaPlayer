//
//  IBXTableViewCell.h
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IBXTableViewCell;

@protocol IBXTableViewCellDelegate <NSObject>

@required
- (void)toggled:(IBXTableViewCell *)cell;
- (void)longPress:(UILongPressGestureRecognizer *)recognizer 
             cell:(IBXTableViewCell *)cell;

@optional
- (void)deleteCell:(IBXTableViewCell *)cell;

@end

@interface IBXTableViewCell : UIView
{
    BOOL _extended;
    BOOL enableHighlight;
}

@property (nonatomic, assign) id<IBXTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL extended;
@property (nonatomic, readonly) UILabel * titleLabel;
@property (nonatomic, readonly) UILabel * subTitleLabel;
@property (nonatomic, readonly) UILabel * thiTitleLabel;
@property (nonatomic, readonly) UIImageView *bgImageView;
@property (nonatomic, readonly) UIImageView *exchangeButton;

@property (nonatomic, readonly) UIImageView *selectButton;
@property (nonatomic, retain) UIView *infoView;
@property (nonatomic, readonly) UIImageView *albumImageView;

- (void)toggleView;
- (void)setFocus:(BOOL)focus;
- (void)setOptionalViewCell;
- (void)setCoverListCell;
- (void)switchToNormalMode;
- (void)switchToEditMode;

@end
