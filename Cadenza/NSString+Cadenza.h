//
//  NSString+Cadenza.h
//  Cadenza
//
//  Created by masaaki goshima on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Cadenza)

- (NSInteger)numberOfLines;
- (CGRect)contentFrame:(UIFont *)font;
- (id)loadFromJSONFile;
- (id)jsonToObject;
- (NSString *)md5;
+ (NSString *)applicationSupportDirectory ;

@end
