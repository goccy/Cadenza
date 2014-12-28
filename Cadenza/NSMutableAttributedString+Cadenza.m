//
//  NSMutableAttributedString+Cadenza.m
//  Cadenza
//
//  Created by goccy on 2014/12/28.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import "NSMutableAttributedString+Cadenza.h"

@implementation NSMutableAttributedString (Cadenza)

- (void)addFont:(UIFont *)font
{
    [self addAttribute:NSFontAttributeName
                 value:font
                 range:NSMakeRange(0, self.length)];
}

- (void)addParagraphStyleWithTextAlignment:(NSTextAlignment)alignment withLineHeight:(CGFloat)lineHeight
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple       = lineHeight;
    paragraphStyle.alignment                = alignment;
    [self addAttribute:NSParagraphStyleAttributeName
                 value:paragraphStyle
                 range:NSMakeRange(0, self.length)];
}

- (void)addTextColor:(UIColor *)textColor
{
    if (!textColor) return;
    [self addAttribute:NSForegroundColorAttributeName
             value:textColor
             range:NSMakeRange(0, self.length)];
}

- (void)addBorderColor:(UIColor *)borderColor
{
    if (!borderColor) return;
    [self addBorderColor:borderColor withBorderSize:-3.0f];
}

- (void)addBorderColor:(UIColor *)borderColor withBorderSize:(CGFloat)borderSize
{
    if (!borderColor) return;
    [self addAttributes:@{
        NSStrokeColorAttributeName : borderColor,
        NSStrokeWidthAttributeName : @(borderSize)
    } range:NSMakeRange(0, self.length)];
}

@end
