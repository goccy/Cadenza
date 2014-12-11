//
//  NSString+Cadenza.h
//  Cadenza
//
//  Created by masaaki goshima on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Cadenza)

- (id)loadFromJSONFile;
- (id)jsonToObject;
- (NSString *)md5;
+ (NSString *)applicationSupportDirectory ;

@end
