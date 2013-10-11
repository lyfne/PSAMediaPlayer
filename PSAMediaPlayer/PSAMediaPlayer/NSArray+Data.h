//
//  NSArray+Data.h
//  PDemoS1
//
//  Created by 吴 wuziqi on 13-7-27.
//  Copyright (c) 2013年 CDI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Data)

- (void)saveToFile:(NSString *)fileName key:(NSString *)key atomically:(BOOL)atomically;
+ (NSArray *)loadFromFile:(NSString *)fileName key:(NSString *)key;

@end
