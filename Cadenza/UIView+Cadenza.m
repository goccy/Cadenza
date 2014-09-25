//
//  UIView+Cadenza.m
//  Cadenza
//
//  Created by goccy on 2014/09/17.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import "UIView+Cadenza.h"
#import <objc/runtime.h>

@implementation UIView (Cadenza)

@dynamic singleTapEventHandler;
@dynamic longPressEventHandler;

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    self.frame   = CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    self.frame   = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    self.frame   = CGRectMake(origin.x, origin.y, frame.size.width, frame.size.height);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    self.frame   = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    self.frame   = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    self.frame   = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height);
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    self.center    = CGPointMake(centerX, center.y);
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    self.center    = CGPointMake(center.x, centerY);
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGPoint)leftTop
{
    return self.frame.origin;
}

- (CGPoint)rightTop
{
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y);
}

- (CGPoint)leftBottom
{
    return CGPointMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height);
}

- (CGPoint)rightBottom
{
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height);
}

- (CGPoint)absolutePosition
{
    CGPoint ret = CGPointMake(0, 0);
    CGPoint pos = self.frame.origin;
    UIView *superView = self.superview;
    if (superView) {
        CGPoint superPos = [superView absolutePosition];
        ret = CGPointMake(pos.x + superPos.x, pos.y + superPos.y);
    } else {
        ret = pos;
    }
    return ret;
}

- (UIView *)rootView
{
    UIView *superView = self.superview;
    return (superView) ? [superView rootView] : self;
}

- (void)singleTap:(void(^)(UIGestureRecognizer *))callback
{
    objc_setAssociatedObject(self, @"singleTapEventHandler", callback, OBJC_ASSOCIATION_RETAIN);
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapEvent:)];
    [self addGestureRecognizer:singleTap];
}

- (void)singleTapEvent:(UIGestureRecognizer *)sender
{
    void(^callback)(UIGestureRecognizer *) = objc_getAssociatedObject(self, @"singleTapEventHandler");
    if (callback) callback(sender);
}

- (void)longPress:(void(^)(UILongPressGestureRecognizer *))callback
{
    objc_setAssociatedObject(self, @"longPressEventHandler", callback, OBJC_ASSOCIATION_RETAIN);
    UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    [self addGestureRecognizer:longPress];
}

- (void)longPressEvent:(UILongPressGestureRecognizer *)sender
{
    void(^callback)(UILongPressGestureRecognizer *) = objc_getAssociatedObject(self, @"longPressEventHandler");
    if (callback) callback(sender);
}

@end
