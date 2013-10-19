//
//  PSATune.h
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-20.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSATune : NSObject<NSCoding>

@property (copy, nonatomic) NSString *songName;
@property (copy, nonatomic) NSString *singerName;
@property (copy, nonatomic) NSString *albumName;

+ (PSATune *)loadMusicInfoWithName:(NSString *)name singer:(NSString *)singerName album:(NSString *)albumName;

@end
