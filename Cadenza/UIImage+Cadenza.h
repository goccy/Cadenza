//
//  UIImage+Cadenza.h
//  Cadenza
//
//  Created by goccy on 2014/09/17.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Cadenza)

+ (UIImage *)imageNamed:(NSString *)name useCache:(BOOL)useCache;
+ (UIImage *)renderHighQualityImageWithBlock:(CGSize)size block:(void(^)(void))renderBlock;
+ (UIImage *)renderImageWithBlock:(CGSize)size block:(void(^)(void))renderBlock;
+ (UIImage *)renderRetinaImageWithBlock:(CGSize)size block:(void(^)(void))renderBlock;

- (UIImage*)cropWithRect:(CGRect)rect;
- (UIImage *)resizeImageWithSize:(CGSize)requiredSize;
- (UIImage *)resizeImageAspectFit:(CGSize)requiredSize;
- (UIImage *)fixOrientation;
- (UIImage *)rotateImage:(CGFloat)angle;
- (UIImage *)rotateImageWithOrientation:(UIImageOrientation)orientation;
- (UIImage *)maskImage:(UIImage *)maskImage maskPoint:(CGPoint)maskPoint;
- (BOOL)writeImageToDisk:(NSString *)name;
- (BOOL)writeImageToDisk:(NSString *)name withPath:(NSString *)path;

@end
