//
//  UIAlertView+Cadenza.m
//  Cadenza
//
//  Created by masaaki goshima on 2014/11/18.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import "UIAlertView+Cadenza.h"
#import <objc/runtime.h>

@implementation UIAlertView (Cadenza)

static const char *leftButtonEventHandlerKey  = "leftButtonEventHandler";
static const char *rightButtonEventHandlerKey = "rightButtonEventHandler";

@dynamic leftButtonEventHandler;
@dynamic rightButtonEventHandler;

- (void)removeHandler:(NSTimer *)timer
{
    NSDictionary *userInfo = [timer userInfo];
    void(^handler)(void)   = userInfo[@"handler"];
    UIAlertView *alertView = userInfo[@"view"];
    [alertView dismissWithClickedButtonIndex:0 animated:NO];
    if (handler) handler();
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message removeInterval:(CGFloat)interval
{
    return [self initWithTitle:title message:message removeInterval:interval callbackHandler:^{}];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message removeInterval:(CGFloat)interval callbackHandler:(void(^)(void))callbackHandler
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    NSDictionary *userInfo = @{ @"handler" : (callbackHandler) ? callbackHandler : ^{}, @"view" : alertView };
    [alertView show];
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(removeHandler:) userInfo:userInfo repeats:NO];
    return alertView;
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            void(^callback)(UIAlertView *) = objc_getAssociatedObject(alertView, leftButtonEventHandlerKey);
            if (callback) callback(alertView);
            break;
        }
        case 1: {
            void(^callback)(UIAlertView *) = objc_getAssociatedObject(alertView, rightButtonEventHandlerKey);
            if (callback) callback(alertView);
            break;
        }
        default:
            break;
    }
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle callbackHandler:(void(^)(UIAlertView *))callbackHandler
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                      message:message
                                     delegate:nil
                            cancelButtonTitle:buttonTitle
                            otherButtonTitles:nil];
    alertView.delegate = alertView;
    objc_setAssociatedObject(alertView, leftButtonEventHandlerKey, callbackHandler, OBJC_ASSOCIATION_RETAIN);
    return alertView;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
              leftButtonTitle:(NSString *)leftButtonTitle leftButtonCallbackHandler:(void(^)(UIAlertView *))leftButtonCallbackHandler
              rightButtonTitle:(NSString *)rightButtonTitle rightButtonCallbackHandler:(void(^)(UIAlertView *))rightButtonCallbackHandler

{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:leftButtonTitle
                                              otherButtonTitles:rightButtonTitle, nil];
    alertView.delegate = alertView;
    objc_setAssociatedObject(alertView, leftButtonEventHandlerKey,  leftButtonCallbackHandler,  OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(alertView, rightButtonEventHandlerKey, rightButtonCallbackHandler, OBJC_ASSOCIATION_RETAIN);
    return alertView;
}

@end