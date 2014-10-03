//
//  UIColor+Cadenza.h
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/10/01.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Cadenza)

+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha;
- (BOOL)isEqualToColor:(UIColor *)color;
- (NSString *)hexString;

@end
