//
//  NSArray+Cadenza.h
//  Cadenza
//
//  Created by goccy on 2015/01/04.
//  Copyright (c) 2015年 goccy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Cadenza)

@property(nonatomic, readonly) NSArray *(^map)(id(^)(id));

@property(nonatomic, readonly) NSArray *(^grep)(BOOL(^)(id));
@property(nonatomic, readonly) NSArray *(^filter)(BOOL(^)(id));
@property(nonatomic, readonly) NSArray *(^select)(BOOL(^)(id));

@end
