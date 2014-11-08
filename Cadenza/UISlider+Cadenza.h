//
//  UISlider+Cadenza.h
//  Cadenza
//
//  Created by goccy on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISlider (Cadenza)

@property(nonatomic) void(^changedEventHandler)(UISlider *);

- (void)changed:(void(^)(UISlider *slider))callback;

@end
