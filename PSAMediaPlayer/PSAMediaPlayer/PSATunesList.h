//
//  PSATunesList.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-20.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSATune.h"

@interface PSATunesList : NSObject

@property (assign, nonatomic, readonly) NSInteger count;
@property (copy, nonatomic) NSString *listName;

+ (PSATunesList *)createTunesList;
- (void)addTune:(PSATune *)tune;
- (NSInteger)count;
- (PSATune *)tuneAtIndex:(int)index;
- (void)removeTuneAtIndex:(int)index;
- (NSString *)getNameWithoutHeader;
- (void)exchangeObjectAtIndex:(int)preIndex withObjectAtIndex:(int)newIndex;

@end
