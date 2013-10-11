//
//  NSArray+Data.m
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-27.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import "NSArray+Data.h"

@implementation NSArray (Data)

- (void)saveToFile:(NSString *)fileName key:(NSString *)key atomically:(BOOL)atomically
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self forKey:key];
    [archiver finishEncoding];
    
    [data writeToFile:filePath atomically:atomically];
}

+ (NSArray *)loadFromFile:(NSString *)fileName key:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    return [unarchiver decodeObjectForKey:key];
}

@end
