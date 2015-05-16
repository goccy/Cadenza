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

@dynamic singleTapRecognizer;
@dynamic longPressRecognizer;
@dynamic rotateRecognizer;
@dynamic pinchRecognizer;
@dynamic singleTapEventHandler;
@dynamic longPressEventHandler;
@dynamic rotateEventHandler;
@dynamic pinchEventHandler;

- (instancetype)initWithNibName:(NSString *)nibName
{
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
}

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

- (void)setZIndex:(NSInteger)zIndex
{
    self.layer.zPosition = zIndex;
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

- (NSInteger)zIndex
{
    return self.layer.zPosition;
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
    objc_setAssociatedObject(self, @"singleTapRecognizer", singleTap, OBJC_ASSOCIATION_RETAIN);
    self.userInteractionEnabled = YES;
}

- (UITapGestureRecognizer *)singleTapRecognizer
{
    return objc_getAssociatedObject(self, @"singleTapRecognizer");
}

- (void)activateSingleTap
{
    UITapGestureRecognizer *singleTapRecognizer = objc_getAssociatedObject(self, @"singleTapRecognizer");
    [self addGestureRecognizer:singleTapRecognizer];
}

- (void)deactivateSingleTap
{
    UITapGestureRecognizer *singleTapRecognizer = objc_getAssociatedObject(self, @"singleTapRecognizer");
    [self removeGestureRecognizer:singleTapRecognizer];
}

- (void)singleTapEvent:(UIGestureRecognizer *)sender
{
    void(^callback)(UIGestureRecognizer *) = objc_getAssociatedObject(self, @"singleTapEventHandler");
    if (callback) callback(sender);
}

- (void)longPress:(void(^)(UILongPressGestureRecognizer *))callback duration:(CGFloat)duration
{
    UILongPressGestureRecognizer *prevLongPressGesture = [self longPressRecognizer];
    if (prevLongPressGesture) {
        [self removeGestureRecognizer:prevLongPressGesture];
    }
    objc_setAssociatedObject(self, @"longPressEventHandler", callback, OBJC_ASSOCIATION_RETAIN);
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    longPress.minimumPressDuration = duration;
    [self addGestureRecognizer:longPress];
    objc_setAssociatedObject(self, @"longPressRecognizer", longPress, OBJC_ASSOCIATION_RETAIN);
    self.userInteractionEnabled = YES;
}

- (UILongPressGestureRecognizer *)longPressRecognizer
{
    return objc_getAssociatedObject(self, @"longPressRecognizer");
}

- (void)activateLongPress
{
    UILongPressGestureRecognizer *longPressRecognizer = objc_getAssociatedObject(self, @"longPressRecognizer");
    [self addGestureRecognizer:longPressRecognizer];
}

- (void)deactivateLongPress
{
    UILongPressGestureRecognizer *longPressRecognizer = objc_getAssociatedObject(self, @"longPressRecognizer");
    [self removeGestureRecognizer:longPressRecognizer];
}

- (void)longPressEvent:(UILongPressGestureRecognizer *)sender
{
    void(^callback)(UILongPressGestureRecognizer *) = objc_getAssociatedObject(self, @"longPressEventHandler");
    if (callback) callback(sender);
}

- (void)rotate:(void(^)(UIRotationGestureRecognizer *))callback
{
    objc_setAssociatedObject(self, @"rotateEventHandler", callback, OBJC_ASSOCIATION_RETAIN);
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateEvent:)];
    [self addGestureRecognizer:rotateGesture];
    objc_setAssociatedObject(self, @"rotateRecognizer", rotateGesture, OBJC_ASSOCIATION_RETAIN);
    self.userInteractionEnabled = YES;
}

- (UIRotationGestureRecognizer *)rotateRecognizer
{
    return objc_getAssociatedObject(self, @"rotateRecognizer");
}

- (void)activateRotate
{
    UIRotationGestureRecognizer *rotateRecognizer = objc_getAssociatedObject(self, @"rotateRecognizer");
    [self addGestureRecognizer:rotateRecognizer];
}

- (void)deactivateRotate
{
    UIRotationGestureRecognizer *rotateRecognizer = objc_getAssociatedObject(self, @"rotateRecognizer");
    [self removeGestureRecognizer:rotateRecognizer];
}

- (void)rotateEvent:(UIRotationGestureRecognizer *)sender
{
    void(^callback)(UIRotationGestureRecognizer *) = objc_getAssociatedObject(self, @"rotateEventHandler");
    if (callback) callback(sender);
}

- (void)pinch:(void(^)(UIPinchGestureRecognizer *))callback
{
    objc_setAssociatedObject(self, @"pinchEventHandler", callback, OBJC_ASSOCIATION_RETAIN);
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchEvent:)];
    [self addGestureRecognizer:pinchGesture];
    objc_setAssociatedObject(self, @"pinchRecognizer", pinchGesture, OBJC_ASSOCIATION_RETAIN);
    self.userInteractionEnabled = YES;
}

- (UIPinchGestureRecognizer *)pinchRecognizer
{
    return objc_getAssociatedObject(self, @"pinchRecognizer");
}

- (void)activatePinch
{
    UIPinchGestureRecognizer *pinchRecognizer = objc_getAssociatedObject(self, @"pinchRecognizer");
    [self addGestureRecognizer:pinchRecognizer];
}

- (void)deactivatePinch
{
    UIPinchGestureRecognizer *pinchRecognizer = objc_getAssociatedObject(self, @"pinchRecognizer");
    [self removeGestureRecognizer:pinchRecognizer];
}

- (void)pinchEvent:(UIPinchGestureRecognizer *)sender
{
    void(^callback)(UIPinchGestureRecognizer *) = objc_getAssociatedObject(self, @"pinchEventHandler");
    if (callback) callback(sender);
}

@end
