//
//  UIImage+Cadenza.h
//  Cadenza
//
//  Created by goccy on 2014/09/17.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Cadenza)

+ (UIImage *)renderHighQualityImageWithBlock:(CGSize)size block:(void(^)(void))renderBlock;
+ (UIImage *)renderImageWithBlock:(CGSize)size block:(void(^)(void))renderBlock;
+ (UIImage *)renderRetinaImageWithBlock:(CGSize)size block:(void(^)(void))renderBlock;

- (UIImage *)resizeImageAspectFit:(CGSize)requiredSize;
- (UIImage *)rotateImage:(CGFloat)angle;
- (UIImage *)maskImage:(UIImage *)maskImage maskPoint:(CGPoint)maskPoint;
- (BOOL)writeImageToDisk:(NSString *)name;
- (BOOL)writeImageToDisk:(NSString *)name withPath:(NSString *)path;


@end
