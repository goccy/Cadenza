//
//  UIColor+Cadenza.m
//  PhotoFilterProcessor
//
//  Created by masaaki goshima on 2014/10/01.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "UIColor+Cadenza.h"

@implementation UIColor (Cadenza)

- (BOOL)isEqualToColor:(UIColor *)color
{
    const size_t numComponents    = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat *components  = CGColorGetComponents(color.CGColor);
    
    float red, blue, green, alpha = 0.0f;
    if (numComponents == 4) {
        red     = components[0];
        green   = components[1];
        blue    = components[2];
        alpha   = CGColorGetAlpha(color.CGColor);
    } else {
        red     = components[0];
        green   = components[0];
        blue    = components[0];
        alpha   = components[1];
    }
    
    const size_t currentNumComponents   = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat *currentComponents = CGColorGetComponents(self.CGColor);
    float currentRed, currentBlue, currentGreen, currentAlpha = 0.0f;
    if (currentNumComponents == 4) {
        currentRed     = currentComponents[0];
        currentGreen   = currentComponents[1];
        currentBlue    = currentComponents[2];
        currentAlpha   = CGColorGetAlpha(self.CGColor);
    } else {
        currentRed     = currentComponents[0];
        currentGreen   = currentComponents[0];
        currentBlue    = currentComponents[0];
        currentAlpha   = currentComponents[1];
    }
    
    BOOL result = YES;
    if(currentRed != red)     return NO;
    if(currentGreen != green) return NO;
    if(currentBlue != blue)   return NO;
    if(currentAlpha != alpha) return NO;
    
    return result;
}

+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha
{
    NSScanner *colorScanner = [NSScanner scannerWithString:hex];
    [colorScanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    unsigned int color;
    if (![colorScanner scanHexInt:&color]) return nil;
    CGFloat r = ((color & 0xFF0000) >> 16)/255.0f;
    CGFloat g = ((color & 0x00FF00) >> 8) /255.0f;
    CGFloat b =  (color & 0x0000FF) /255.0f;
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

- (NSString *)hexString
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
}

@end
