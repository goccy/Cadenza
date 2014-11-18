//
//  UIAlertView+Cadenza.m
//  Cadenza
//
//  Created by masaaki goshima on 2014/11/18.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import "UIAlertView+Cadenza.h"

@implementation UIAlertView (Cadenza)

- (void)removeHandler:(NSTimer *)timer
{
    NSDictionary *userInfo = [timer userInfo];
    void(^handler)(void)   = userInfo[@"handler"];
    UIAlertView *alertView = userInfo[@"view"];
    [alertView dismissWithClickedButtonIndex:0 animated:NO];
    if (handler) handler();
}

- (void)initWithTitle:(NSString *)title message:(NSString *)message removeInterval:(CGFloat)interval
{
    [self initWithTitle:title message:message removeInterval:interval callbackHandler:^{}];
}

- (void)initWithTitle:(NSString *)title message:(NSString *)message removeInterval:(CGFloat)interval callbackHandler:(void(^)(void))callbackHandler
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    NSDictionary *userInfo = @{ @"handler" : (callbackHandler) ? callbackHandler : ^{}, @"view" : alertView };
    [alertView show];
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(removeHandler:) userInfo:userInfo repeats:NO];
}

@end
