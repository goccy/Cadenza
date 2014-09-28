//
//  UISlider+Cadenza.m
//  Cadenza
//
//  Created by goccy on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "UISlider+Cadenza.h"
#import <objc/runtime.h>

@implementation UISlider (Cadenza)

@dynamic changedEventHandler;

- (void)changed:(void(^)(UISlider *slider))callback
{
    objc_setAssociatedObject(self, @"changedEventHandler", callback, OBJC_ASSOCIATION_RETAIN);
    [self addTarget:self action:@selector(changedParameter:) forControlEvents:UIControlEventValueChanged];
}

- (void)changedParameter:(UISlider *)slider
{
    void(^callback)(UISlider *) = objc_getAssociatedObject(self, @"changedEventHandler");
    if (callback) callback(slider);
}

@end
