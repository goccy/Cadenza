//
//  NSMutableAttributedString+Cadenza.h
//  Cadenza
//
//  Created by goccy on 2014/12/28.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Cadenza)

- (void)addFont:(UIFont *)font;
- (void)addTextColor:(UIColor *)textColor;
- (void)addParagraphStyleWithTextAlignment:(NSTextAlignment)alignment withLineHeight:(CGFloat)lineHeight;
- (void)addBorderColor:(UIColor *)borderColor withBorderSize:(CGFloat)borderSize;
- (void)addBorderColor:(UIColor *)borderColor;

@end
