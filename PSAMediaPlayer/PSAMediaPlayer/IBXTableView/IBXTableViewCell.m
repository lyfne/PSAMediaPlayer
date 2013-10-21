//
//  IBXTableViewCell.m
//  IBXTableView
//
//  Created by 剑锋 屠 on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PSAMusicConstantsConfig.h"
#import "IBXTableViewCell.h"
#import "PSAMusicPlayer.h"

#define DEFAULT_CELL_HEIGHT 62
#define DEFAULT_PADDING 5
#define kInitFrame CGRectMake(0,0,576,85)
#define kSelectButtonTag 999
#define kfirstAnimationWidth 450

#define kSelectedCellBG @"Device_coverlist_selected.png"
#define kNormalCellBG @"Device_coverlist_bg.png"

@interface IBXTableViewCell ()
{ 
    CGPoint _startPoint;
}

@end

@implementation IBXTableViewCell

@synthesize extended = _extended;
@synthesize delegate = _delegate;
@synthesize titleLabel = _titleLabel;
@synthesize subTitleLabel = _subTitleLabel;
@synthesize thiTitleLabel = _thiTitleLabel;
@synthesize bgImageView = _bgImageView;
@synthesize exchangeButton = _exchangeButton;
@synthesize selectButton = _selectButton;
@synthesize infoView = _infoView;
@synthesize albumImageView = _albumImageView;


- (void)dealloc
{
    _delegate = nil;

    [_titleLabel release];
    [_subTitleLabel release];
    [_thiTitleLabel release];
    [_infoView release];
    [_albumImageView release];
    [_selectButton release];
    [_exchangeButton release];
    [_bgImageView release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setOptionalViewCell
{
    self.frame = CGRectMake(0, 0, 400, DEFAULT_CELL_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    
    enableHighlight = YES;
    _bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
    _bgImageView.image = [UIImage imageNamed:@"OptionCellBG.png"];
    [self addSubview:_bgImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 14, 293, 21)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_titleLabel useRegularFontWithSize:20];
    [self addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 34, 259, 19)];
    _subTitleLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AlbumBlueColor.png"]];
    _subTitleLabel.backgroundColor = [UIColor clearColor];
    [_subTitleLabel useRegularFontWithSize:14];
    [self addSubview:_subTitleLabel];
    
    _exchangeButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OptionMenuIcon.png"]];
    _exchangeButton.frame = CGRectMake(355, 22, 24, 17);
    _exchangeButton.userInteractionEnabled = YES;
    [self addSubview:_exchangeButton];
    
    if ([[PSAMusicPlayer sharedPSAMusicPlayer] getNowPlayingSource] == kNowPlayingSourceDVD) {
        _exchangeButton.hidden = YES;
    }
    
    UILongPressGestureRecognizer * longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longReceived:)];
    [_exchangeButton addGestureRecognizer:longRecognizer];
    [longRecognizer release];
}

- (void)setCoverListCell
{
    self.frame = CGRectMake(0, 0, 576, 85);
    self.backgroundColor = [UIColor clearColor];
    
    enableHighlight = NO;
    _bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
    [_bgImageView setHeight:self.frame.size.height+1];
    _bgImageView.image = [UIImage imageNamed:@"Device_coverlist_bg.png"];
    [self addSubview:_bgImageView];
    
    _selectButton = [[UIImageView alloc] initWithFrame:CGRectMake(25, 30, 25, 25)];
    _selectButton.image = [UIImage imageNamed: @"List_minus.png"];
    _selectButton.userInteractionEnabled = YES;
    [self addSubview:_selectButton];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAction)];
    [_selectButton addGestureRecognizer:tapRecognizer];
    [tapRecognizer release];
    
    _infoView = [[UIView alloc] initWithFrame:self.frame];
    _infoView.backgroundColor = [UIColor clearColor];
    [self addSubview:_infoView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 11, 400, 27)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_titleLabel useRegularFontWithSize:18];
    [_infoView addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 264, 21)];
    _subTitleLabel.backgroundColor = [UIColor clearColor];
    [_subTitleLabel useRegularFontWithSize:14];
    [_infoView addSubview:_subTitleLabel];
    
    _thiTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 52, 177, 21)];
    _thiTitleLabel.backgroundColor = [UIColor clearColor];
    _thiTitleLabel.textColor = [UIColor whiteColor];
    [_thiTitleLabel useRegularFontWithSize:14];
    [_infoView addSubview:_thiTitleLabel];
    
    _albumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
    [_infoView addSubview:_albumImageView];
    
    _exchangeButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OptionMenuIcon.png"]];
    _exchangeButton.frame = CGRectMake(531, 35, 24, 17);
    _exchangeButton.userInteractionEnabled = YES;
    _exchangeButton.hidden = YES;
    [self addSubview:_exchangeButton];
    [self bringSubviewToFront:_exchangeButton];
    
    UILongPressGestureRecognizer * longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longReceived:)];
    [_exchangeButton addGestureRecognizer:longRecognizer];
    [longRecognizer release];
}

#pragma mark Public Method

- (void)switchToNormalMode
{
    [self moveInfoViewTo:-kCoverListCellMoveOffset withTime:0.5f];
    _exchangeButton.hidden = YES;
}

- (void)switchToEditMode
{
    [self moveInfoViewTo:kCoverListCellMoveOffset withTime:0.5f];
    _exchangeButton.hidden = NO;
}

- (void)moveInfoViewTo:(CGFloat)xNum withTime:(float)time
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:time];
    _infoView.transform = CGAffineTransformTranslate(_infoView.transform, xNum, 0);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

#pragma mark - gesture

- (void)longReceived:(UILongPressGestureRecognizer *)recognizer
{
    if (_delegate && [_delegate respondsToSelector:@selector(longPress:cell:)]) {
        [_delegate longPress:recognizer cell:self];
    }
}

- (void)deleteAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteCell:)]) {
        [_delegate deleteCell:self];
    }
}

#pragma mark - resize

- (void)toggleView
{
    _extended = !_extended;
    if (_delegate && [_delegate respondsToSelector:@selector(toggled:)]) {
        [_delegate toggled:self];
    }
}

#pragma mark - slide

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch * touch = [touches anyObject];
    if ([touch tapCount] == 1) {
        [self performSelector:@selector(toggleView) withObject:nil afterDelay:0.2];
    }
    
    if (enableHighlight == YES) {
        _bgImageView.image = [UIImage imageNamed:@"OptionCellBG.png"];
        _subTitleLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AlbumBlueColor.png"]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (enableHighlight == YES) {
        _bgImageView.image = [UIImage imageNamed:@"OptionCellBG.png"];
        _subTitleLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AlbumBlueColor.png"]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch * touch = [touches anyObject];
    _startPoint = [touch locationInView:self.superview];
    
    if (enableHighlight == YES) {
        _bgImageView.image = [UIImage imageNamed:@"MusicOptionalCellBG_selected.png"];
        _subTitleLabel.textColor = [UIColor whiteColor];
    }
}

#pragma mark - setFocus

- (void)setFocus:(BOOL)focus
{
    if (focus) {
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.75;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    else {
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0;
        self.layer.shadowColor = [UIColor blackColor].CGColor;        
    }
}

@end
