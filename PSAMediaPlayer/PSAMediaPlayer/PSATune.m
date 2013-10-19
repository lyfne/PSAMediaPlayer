//
//  PSATune.m
//  PDemoS1
//
//  Created by Fan's Mac on 13-7-20.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "PSATune.h"
#import "PSAMusicConstantsConfig.h"

@implementation PSATune

- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:self.songName forKey:kSongName];
    [coder encodeObject:self.singerName forKey:kSingerName];
    [coder encodeObject:self.albumName forKey:kAlbumName];
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    
    if (self) {
        self.songName = [coder decodeObjectForKey:kSongName];
        self.singerName = [coder decodeObjectForKey:kSingerName];
        self.albumName = [coder decodeObjectForKey:kAlbumName];
    }
    
    return self;
}

+ (PSATune *)loadMusicInfoWithName:(NSString *)name singer:(NSString *)singerName album:(NSString *)albumName
{
    PSATune *tune = [[PSATune alloc] init];
    
    tune.songName = name;
    tune.singerName = singerName;
    tune.albumName = albumName;
    
    return tune;
}

@end
