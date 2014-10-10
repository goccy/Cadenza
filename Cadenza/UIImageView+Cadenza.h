//
//  UIImageView+Cadenza.h
//  Cadenza
//
//  Created by masaaki goshima on 2014/10/10.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Cadenza)

+ (instancetype)imageNamed:(NSString *)imageName;
- (instancetype)initWithFrame:(CGRect)frame withName:(NSString *)imageName;
- (instancetype)initWithFrame:(CGRect)frame withName:(NSString *)imageName withContentMode:(UIViewContentMode)contentMode;
- (void)clear;

@end
