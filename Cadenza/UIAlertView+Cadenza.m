//
//  UIAlertView+Cadenza.m
//  Cadenza
//
//  Created by masaaki goshima on 2014/11/18.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import "UIAlertView+Cadenza.h"
#import <objc/runtime.h>

@interface UIAlertViewInternal : NSObject<UIAlertViewDelegate>

@property(nonatomic, strong) void(^leftButtonEventHandler)(UIAlertView *);
@property(nonatomic, strong) void(^rightButtonEventHandler)(UIAlertView *);

@end

@implementation UIAlertViewInternal

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            void(^callback)(UIAlertView *) = self.leftButtonEventHandler;
            if (callback) callback(alertView);
            break;
        }
        case 1: {
            void(^callback)(UIAlertView *) = self.rightButtonEventHandler;
            if (callback) callback(alertView);
            break;
        }
        default:
            break;
    }
}

@end

@implementation UIAlertView (Cadenza)

@dynamic internalDelegate;

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

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle callbackHandler:(void(^)(UIAlertView *))callbackHandler
{
    UIAlertViewInternal *internal    = [[UIAlertViewInternal alloc] init];
    internal.leftButtonEventHandler  = callbackHandler;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                      message:message
                                                     delegate:internal
                                            cancelButtonTitle:buttonTitle
                                            otherButtonTitles:nil];
    objc_setAssociatedObject(alertView, @"internalDelegate", internal, OBJC_ASSOCIATION_RETAIN);
    return alertView;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
              leftButtonTitle:(NSString *)leftButtonTitle leftButtonCallbackHandler:(void(^)(UIAlertView *))leftButtonCallbackHandler
              rightButtonTitle:(NSString *)rightButtonTitle rightButtonCallbackHandler:(void(^)(UIAlertView *))rightButtonCallbackHandler

{
    UIAlertViewInternal *internal    = [[UIAlertViewInternal alloc] init];
    internal.leftButtonEventHandler  = leftButtonCallbackHandler;
    internal.rightButtonEventHandler = rightButtonCallbackHandler;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                      message:message
                                     delegate:internal
                            cancelButtonTitle:leftButtonTitle
                            otherButtonTitles:rightButtonTitle, nil];
    objc_setAssociatedObject(alertView, @"internalDelegate", internal, OBJC_ASSOCIATION_RETAIN);
    return alertView;
}

@end