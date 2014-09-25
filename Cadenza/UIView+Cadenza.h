//
//  UIView+Cadenza.h
//  Cadenza
//
//  Created by goccy on 2014/09/17.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Cadenza)

@property(nonatomic) void(^singleTapEventHandler)(UIGestureRecognizer *);
@property(nonatomic) void(^longPressEventHandler)(UILongPressGestureRecognizer *);

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;
- (CGPoint)leftTop;
- (CGPoint)rightTop;
- (CGPoint)leftBottom;
- (CGPoint)rightBottom;
- (CGSize)size;
- (CGPoint)origin;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (CGPoint)absolutePosition;
- (UIView *)rootView;
- (void)singleTap:(void(^)(UIGestureRecognizer *))callback;
- (void)longPress:(void(^)(UILongPressGestureRecognizer *))callback;

@end
