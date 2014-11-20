//
//  UIAlertView+Cadenza.h
//  Cadenza
//
//  Created by masaaki goshima on 2014/11/18.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Cadenza)

@property(nonatomic) void(^leftButtonEventHandler)(UIAlertView *);
@property(nonatomic) void(^rightButtonEventHandler)(UIAlertView *);

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle callbackHandler:(void(^)(UIAlertView *))callbackHandler;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
              leftButtonTitle:(NSString *)leftButtonTitle leftButtonCallbackHandler:(void(^)(UIAlertView *))leftButtonCallbackHandler
             rightButtonTitle:(NSString *)rightButtonTitle rightButtonCallbackHandler:(void(^)(UIAlertView *))rightButtonCallbackHandler;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message removeInterval:(CGFloat)interval;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message removeInterval:(CGFloat)interval callbackHandler:(void(^)(void))callbackHandler;

@end
