//
//  NSArray+Cadenza.m
//  Cadenza
//
//  Created by goccy on 2015/01/04.
//  Copyright (c) 2015年 goccy. All rights reserved.
//

#import "NSArray+Cadenza.h"

@implementation NSArray (Cadenza)

- (NSArray *(^)(id (^)(id)))map
{
    return ^(id (^block)(id)) {
        NSMutableArray *array = [@[] mutableCopy];
        for (id elem in self) {
            id ret  = block(elem);
            if (ret) [array addObject:ret];
        }
        return array;
    };
}

- (NSArray *(^)(BOOL (^)(id)))grep
{
    return ^(BOOL (^block)(id)) {
        NSMutableArray *array = [@[] mutableCopy];
        for (id elem in self) {
            if (block(elem)) [array addObject:elem];
        }
        return array;
    };
}

- (NSArray *(^)(BOOL (^)(id)))filter
{
    return self.grep;
}

- (NSArray *(^)(BOOL (^)(id)))select
{
    return self.grep;
}

@end
