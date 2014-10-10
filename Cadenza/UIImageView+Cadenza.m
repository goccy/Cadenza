//
//  UIImageView+Cadenza.m
//  Cadenza
//
//  Created by masaaki goshima on 2014/10/10.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import "UIImageView+Cadenza.h"

@implementation UIImageView (Cadenza)

+ (instancetype)imageNamed:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *image  = [UIImage imageNamed:imageName];
    imageView.image = image;
    return imageView;
}

- (instancetype)initWithFrame:(CGRect)frame withName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    self.image  = [UIImage imageNamed:imageName];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withName:(NSString *)imageName withContentMode:(UIViewContentMode)contentMode
{
    self = [super initWithFrame:frame];
    self.image  = [UIImage imageNamed:imageName];
    self.contentMode = contentMode;
    return self;
}

- (void)clear
{
    @autoreleasepool {
        self.image = nil;
        self.layer.sublayers = nil;
        [self removeFromSuperview];
    }
}

@end
