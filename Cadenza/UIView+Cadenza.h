//
//  UIView+Cadenza.h
//  Cadenza
//
//  Created by goccy on 2014/09/17.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Cadenza)

@property(nonatomic) UITapGestureRecognizer *singleTapRecognizer;
@property(nonatomic) UILongPressGestureRecognizer *longPressRecognizer;
@property(nonatomic) UIRotationGestureRecognizer *rotateRecognizer;
@property(nonatomic) UIPinchGestureRecognizer *pinchRecognizer;
@property(nonatomic) void(^singleTapEventHandler)(UIGestureRecognizer *);
@property(nonatomic) void(^longPressEventHandler)(UILongPressGestureRecognizer *);
@property(nonatomic) void(^rotateEventHandler)(UIRotationGestureRecognizer *);
@property(nonatomic) void(^pinchEventHandler)(UIPinchGestureRecognizer *);

- (instancetype)initWithNibName:(NSString *)nibName;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)setZIndex:(NSInteger)zIndex;
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
- (NSInteger)zIndex;
- (CGPoint)absolutePosition;
- (UIView *)rootView;
- (void)singleTap:(void(^)(UIGestureRecognizer *))callback;
- (void)activateSingleTap;
- (void)deactivateSingleTap;
- (void)activateLongPress;
- (void)deactivateLongPress;
- (void)activateRotate;
- (void)deactivateRotate;
- (void)activatePinch;
- (void)deactivatePinch;
- (void)longPress:(void(^)(UILongPressGestureRecognizer *))callback duration:(CGFloat)duration;
- (void)rotate:(void(^)(UIRotationGestureRecognizer *))callback;
- (void)pinch:(void(^)(UIPinchGestureRecognizer *))callback;

@end
