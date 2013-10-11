//
//  PSATunesList.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-20.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSATunesList.h"
#import "PSAMusicConstantsConfig.h"

#define kTunesArrayData @"TunessArrayData"
#define kListName @"ListName"

@interface PSATunesList()
@property (strong, nonatomic) NSMutableArray *tunesArray;
@end

@implementation PSATunesList
@synthesize tunesArray = _tunesArray;

- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:self.tunesArray forKey:kTunesArrayData];
    [coder encodeObject:self.listName forKey:kListName];
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    
    if (self) {
        self.tunesArray = [coder decodeObjectForKey:kTunesArrayData];
        self.listName = [coder decodeObjectForKey:kListName];
    }
    
    return self;
}

- (NSMutableArray *)tunesArray
{
    if (_tunesArray == nil) {
        _tunesArray = [[NSMutableArray alloc] init];
    }
    return _tunesArray;
}

#pragma mark - Public

+ (PSATunesList *)createTunesList
{
    return [[PSATunesList alloc] init];
}

- (void)addTune:(PSATune *)tune
{
    [self.tunesArray addObject:tune];
}

- (NSInteger)count
{
    return [self.tunesArray count];
}

- (PSATune *)tuneAtIndex:(int)index
{
    return [_tunesArray objectAtIndex:index];
}

- (void)removeTuneAtIndex:(int)index
{
    [self.tunesArray removeObjectAtIndex:index];
}

- (NSString *)getNameWithoutHeader
{
    return [self.listName substringFromIndex:5];
}

- (void)exchangeObjectAtIndex:(int)preIndex withObjectAtIndex:(int)newIndex
{
    [self.tunesArray insertObject:[self.tunesArray objectAtIndex:preIndex] atIndex:newIndex];
    [self.tunesArray removeObjectAtIndex:preIndex+1];
}


@end
