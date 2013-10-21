//
//  IBXTableView.h
//  IBXTableView
//
//  Created by Inbox.com on 4/7/12.
//  Copyright (c) 2012 VNT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IBXTableViewDataSource.h"
#import "IBXTableViewCell.h"

typedef enum {
    AnimationTypeNormal,
    AnimationTypeHide,
} RemoveAnimationType;

@protocol IBXTableViewDelegate <NSObject>

@required
- (void)cellMovedFrom:(NSUInteger)source index:(NSUInteger)to;
- (void)cellClicked:(NSUInteger)index;

@optional
- (void)cellDeleted:(NSUInteger)index;

@end
@interface IBXTableView : UIScrollView <IBXTableViewDataSourceDelegate, IBXTableViewCellDelegate>

@property (nonatomic, assign) IBXTableViewDataSource * ibxDataSource;
@property (nonatomic, assign) id<IBXTableViewDelegate> ibxDelegate;

- (void)updateUI;
- (void)layoutFrame;

- (IBXTableViewCell *)allocCellWithItem:(IBXTableViewDataItem *)item;
- (IBXTableViewCell *)cellAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfCell:(IBXTableViewCell *)cell;

- (void)removeAnimation:(RemoveAnimationType)type withIndex:(NSInteger)index;

- (void)switchToMode:(int)mode;

@end
