//
//  NSObject+Cadenza.m
//  Cadenza
//
//  Created by masaaki goshima on 2014/10/10.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import "NSObject+Cadenza.h"
#import "NSString+Cadenza.h"

@implementation NSObject (Cadenza)

- (NSString *)makeObjectID
{
    NSInteger createdAt = [[NSDate date] timeIntervalSince1970];
    NSString *ptr  = [NSString stringWithFormat:@"%p", self];
    NSString *base = [ptr stringByAppendingString:[NSString stringWithFormat:@"%ld", createdAt]];
    return [base md5];
}

@end
