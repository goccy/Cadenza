//
//  UIAlertView+Cadenza.h
//  Cadenza
//
//  Created by masaaki goshima on 2014/11/18.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Cadenza)

- (void)initWithTitle:(NSString *)title message:(NSString *)message removeInterval:(CGFloat)interval;
- (void)initWithTitle:(NSString *)title message:(NSString *)message removeInterval:(CGFloat)interval callbackHandler:(void(^)(void))callbackHandler;

@end
