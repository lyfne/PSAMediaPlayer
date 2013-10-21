//
//  IBXTableView.m
//  IBXTableView
//
//  Created by Inbox.com on 4/7/12.
//  Copyright (c) 2012 VNT. All rights reserved.
//

#import "IBXTableView.h"
#import "IBXTableViewDataItem.h"
#import "IBXTableViewCell.h"
#import "PSAMusicConstantsConfig.h"

#define BOTTOM_PADDING 5

@interface IBXTableView () 
{
    IBXTableViewDataSource * _ibxDataSource;
    id<IBXTableViewDelegate> _ibxDelegate;
    NSMutableArray * _cells;
    
    NSInteger _needLayoutFrame;
    
    IBXTableViewCell * _moveCell;
    CGFloat cellStartY;
    CGFloat touchStartY;
    
    BOOL _layouting;
}

@end

@implementation IBXTableView

@synthesize ibxDelegate = _ibxDelegate;
@synthesize ibxDataSource = _ibxDataSource;


- (void)dealloc
{
    _ibxDataSource = nil;
    //_ibxDataSource.delegate = nil;
    
    [_cells release];
    
    
    [super dealloc];
}


- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        
        _cells = [[NSMutableArray alloc] init];       
    }
    
    return self;
}

#pragma mark Public Method

- (void)switchToMode:(int)mode
{
    if (mode==kEditButtonSelectedState) {
        [self switchToEditMode];
    }else{
        [self switchToNormalMode];
    }
}

- (void)switchToEditMode
{
    for (IBXTableViewCell *cell in _cells) {
        [cell switchToEditMode];
    }
}

- (void)switchToNormalMode
{
    for (IBXTableViewCell *cell in _cells) {
        [cell switchToNormalMode];
    }
}

#pragma mark - layout

- (void)layoutFrame
{
    CGFloat y = _moveCell.frame.size.height;
    for (IBXTableViewCell * cell in _cells) {
        if (cell == _moveCell) continue;
            
        if ((y - cell.frame.size.height / 2.)<_moveCell.frame.origin.y) {
            cell.frame = CGRectMake(0, y - _moveCell.frame.size.height, self.frame.size.width, cell.frame.size.height);
        }
        else {
            cell.frame = CGRectMake(0, y, self.frame.size.width, cell.frame.size.height);    
        }
        y += cell.frame.size.height;        
    }
            
    self.contentSize = CGSizeMake(self.contentSize.width, MAX(y + BOTTOM_PADDING, self.frame.size.height + BOTTOM_PADDING));    
}

- (BOOL)needLayoutFrame
{
    CGFloat y = _moveCell.frame.size.height;
    for (IBXTableViewCell * cell in _cells) {
        if (cell == _moveCell) continue;
        
        if ((y + cell.frame.size.height / 2.)<_moveCell.frame.origin.y) {
            if (cell.frame.origin.y != y - _moveCell.frame.size.height) return YES;
        }
        else {
            if (cell.frame.origin.y != y) return YES;
        }
        y += cell.frame.size.height;
    }
    
    return NO;
}

- (NSUInteger)indexOfMoveCell
{
    NSUInteger index = 0;
    for (IBXTableViewCell * cell in _cells) {
        if (cell == _moveCell) continue;
        if (cell.frame.origin.y < _moveCell.frame.origin.y) index++;
    }    
    
    return index;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (_needLayoutFrame > 0) {
        [self layoutFrame];
        
        _needLayoutFrame--;
    }

}

- (void)updateUI
{
    _needLayoutFrame++;
    [self setNeedsLayout];
}

#pragma mark - auto scroll

static CGFloat delay = 0.05f;
static CGFloat skip = 3;

- (void)autoScroll
{
    if (_moveCell.frame.origin.y < self.contentOffset.y
        && self.contentOffset.y > 0) {
        self.contentOffset = CGPointMake(0, MAX(self.contentOffset.y - skip, 0));
        if (_moveCell.frame.origin.y > skip) {
            CGRect frame = _moveCell.frame;
            frame.origin.y -= skip;
            _moveCell.frame = frame;
        }
    }
    else if (CGRectGetMaxY(_moveCell.frame) > self.contentOffset.y + self.frame.size.height
             && self.contentOffset.y + self.frame.size.height < self.contentSize.height) {
        self.contentOffset = CGPointMake(0, MAX(self.contentOffset.y + skip, 0));
        if (_moveCell.frame.origin.y + _moveCell.frame.size.height < self.contentSize.height - skip) {
            CGRect frame = _moveCell.frame;
            frame.origin.y += skip;
            _moveCell.frame = frame;
        }        
    }
    
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:delay];
}

#pragma mark - cell

- (IBXTableViewCell *)allocCellWithItem:(IBXTableViewDataItem *)item
{
    IBXTableViewCell * cell = [[item class] allocTableViewCell];
    cell.delegate = self;        
        
    return cell;
}

- (IBXTableViewCell *)cellAtIndex:(NSUInteger)index
{
    if (index < [_cells count]) {
        return [_cells objectAtIndex:index];
    }

    return nil;
}

- (NSUInteger)indexOfCell:(IBXTableViewCell *)cell
{
    int index = 0;
    for (IBXTableViewCell * tempCell in _cells) {
        if (cell == tempCell) return index;
            
        index++;
    }
    
    return NSNotFound;
}

#pragma mark - changed

- (void)longPress:(UILongPressGestureRecognizer *)recognizer 
             cell:(IBXTableViewCell *)cell
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _moveCell = cell;
        [_moveCell setFocus:YES];
        [self bringSubviewToFront:_moveCell];
        
        [self performSelector:@selector(autoScroll) withObject:nil afterDelay:delay];
        
        cellStartY = cell.frame.origin.y;
        touchStartY = [recognizer locationInView:self].y;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat currentY = [recognizer locationInView:self].y;
        CGRect frame = cell.frame;
        frame.origin.y = cellStartY + (currentY - touchStartY);
        cell.frame = frame;
        
        [UIView animateWithDuration:0.2 
                              delay:0 
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^(void) {
            [self layoutFrame];
        } completion:^(BOOL finished) {
        }];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
        
        NSUInteger fromIndex = [_cells indexOfObject:_moveCell];
        NSUInteger newIndex = [self indexOfMoveCell];
        
        [_moveCell retain];
        [_cells removeObject:_moveCell];
        [_cells insertObject:_moveCell atIndex:newIndex];
        [_moveCell release];

        [_moveCell setFocus:NO];
        _moveCell = nil;
        
        [UIView animateWithDuration:0.2 animations:^(void) {
            [self layoutFrame];
        } completion:^(BOOL finished) {
            if (_ibxDelegate && [_ibxDelegate respondsToSelector:@selector(cellMovedFrom:index:)]) {
                [_ibxDelegate cellMovedFrom:fromIndex index:newIndex];
                [_ibxDataSource cellMovedFrom:fromIndex index:newIndex];
            }
        }];
    }
}

- (void)toggled:(IBXTableViewCell *)cell
{
    NSUInteger index = [_cells indexOfObject:cell];
    if (index != NSNotFound && _ibxDelegate
        && [_ibxDelegate respondsToSelector:@selector(cellClicked:)]) {
        [_ibxDelegate cellClicked:index];
    }
}

- (void)deleteCell:(IBXTableViewCell *)cell
{
    NSUInteger index = [_cells indexOfObject:cell];
    if (index != NSNotFound && _ibxDelegate
        && [_ibxDelegate respondsToSelector:@selector(cellDeleted:)]) {
        [_ibxDelegate cellDeleted:index];
    }
}

#pragma mark - data

- (void)itemInserted:(NSUInteger)index 
          dataSource:(IBXTableViewDataSource *)dataSource
{
    IBXTableViewDataItem * item = [dataSource itemAtIndex:index];
    IBXTableViewCell * cell = [self allocCellWithItem:item];
    [item updateCell:cell];
    [_cells insertObject:cell atIndex:index];
    CGRect frame = cell.frame;
    frame.origin.y -= frame.size.height;
    cell.frame = frame;
    [self addSubview:cell];
    [cell release];
    
    [self layoutFrame];
}

- (void)itemWillDeleted:(NSUInteger)index
             dataSource:(IBXTableViewDataSource *)dataSource
{
    [self removeAnimation:AnimationTypeNormal withIndex:index];
}


- (void)itemUpdated:(NSUInteger)index 
         dataSource:(IBXTableViewDataSource *)dataSource
{
    IBXTableViewDataItem * item = [dataSource itemAtIndex:index];
    IBXTableViewCell * cell = [_cells objectAtIndex:index];
    [item updateCell:cell];
    [UIView animateWithDuration:0.2 animations:^(void) {
        [self layoutFrame];
    }];
}

- (void)dataChanged:(IBXTableViewDataSource *)dataSource
{
    if ([dataSource count] == 0) {
        for (IBXTableViewCell * cell in _cells) {
            [cell removeFromSuperview];
        }
        [_cells removeAllObjects];
    }   
    else {
        IBXTableViewDataItem * sampleItem = [dataSource itemAtIndex:0];
        while ([_cells count] > [dataSource count]) {
            [[_cells objectAtIndex:0] removeFromSuperview];
            [_cells removeObjectAtIndex:0];
        }
        while ([_cells count] < [dataSource count]) {
            IBXTableViewCell * cell = [self allocCellWithItem:sampleItem];
            [_cells addObject:cell];
            [self addSubview:cell];
            [cell release];
        }
        
        int index = 0;
        for (IBXTableViewDataItem * item in dataSource) {
            IBXTableViewCell * cell = [_cells objectAtIndex:index++];
            [item updateCell:cell];
        }
    }

    [self updateUI];
}

- (void)setIbxDataSource:(IBXTableViewDataSource *)ibxDataSource
{
    _ibxDataSource = ibxDataSource;
    ibxDataSource.delegate = self;
}
     
#pragma mark - remove animation

- (void)removeAnimation:(RemoveAnimationType)type withIndex:(NSInteger)index
{
    IBXTableViewCell * cell = [_cells objectAtIndex:index];
    
    [UIView animateWithDuration:0.2f animations:^(void) {
        CGRect frame = cell.frame;
        if (type == AnimationTypeNormal) {
            frame.origin.x += cell.frame.size.width;
        }
        else if (type == AnimationTypeHide) {
            frame.size.height = 0;
        }
        cell.frame = frame;
        
    } completion:^(BOOL finished) {
        [cell removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^(void) {
            [_cells removeObject:cell];
            [self layoutFrame];
        }];
    }];
}

@end
