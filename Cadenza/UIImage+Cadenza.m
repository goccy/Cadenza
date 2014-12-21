//
//  UIImage+Cadenza.m
//  Cadenza
//
//  Created by goccy on 2014/09/17.
//  Copyright (c) 2014年 goccy. All rights reserved.
//

#import "UIImage+Cadenza.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Cadenza)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    return [UIImage imageWithColor:color withRect:rect];
}

+ (UIImage *)imageWithColor:(UIColor *)color withRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    CGContextFillRect(contextRef, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)renderImageWithBlock:(CGSize)size block:(void(^)(void))renderBlock withScale:(CGFloat)scale
{
    UIImage *renderedImage;
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        renderBlock();
        renderedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return renderedImage;
}

+ (UIImage *)renderHighQualityImageWithBlock:(CGSize)size block:(void(^)(void))renderBlock
{
    return [UIImage renderImageWithBlock:size block:renderBlock withScale:0.0];
}

+ (UIImage *)renderImageWithBlock:(CGSize)size block:(void(^)(void))renderBlock
{
    return [UIImage renderImageWithBlock:size block:renderBlock withScale:1.0];
}

+ (UIImage *)renderRetinaImageWithBlock:(CGSize)size block:(void(^)(void))renderBlock
{
    return [UIImage renderImageWithBlock:size block:renderBlock withScale:2.0];
}

+ (UIImage *)imageNamed:(NSString *)name useCache:(BOOL)useCache
{
    if (useCache) return [UIImage imageNamed:name];
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *normalPath = [NSString stringWithFormat:@"%@/%@", bundlePath, name];
    BOOL isRetina        = ((int)[UIScreen mainScreen].scale == 2) ? YES : NO;
    UIImage *ret = nil;
    if (isRetina) {
        NSString *baseName   = [name stringByDeletingPathExtension];
        NSString *retinaPath = [NSString stringWithFormat:@"%@/%@@2x.png", bundlePath, baseName];
        ret = [UIImage imageWithContentsOfFile:retinaPath];
        if (ret) return ret;
        return [UIImage imageWithContentsOfFile:normalPath];
    }
    return [UIImage imageWithContentsOfFile:normalPath];
}

- (UIImage *)cropWithRect:(CGRect)rect
{
    UIImage *cropedImage = nil;
    @autoreleasepool {
        CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
        cropedImage         = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    return cropedImage;
}

- (UIImage *)resizeImageAspectFit:(CGSize)requiredSize
{
    UIGraphicsBeginImageContext(requiredSize);
    CGRect rect = AVMakeRectWithAspectRatioInsideRect(self.size, CGRectMake(0, 0, requiredSize.width, requiredSize.height));
    [self drawInRect:rect];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (UIImage *)resizeImageWithSize:(CGSize)requiredSize
{
    UIImage *resizedImage;
    @autoreleasepool {
        UIGraphicsBeginImageContext(requiredSize);
        CGRect rect = CGRectMake(0, 0, requiredSize.width, requiredSize.height);
        [self drawInRect:rect];
        resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return resizedImage;
}

- (UIImage *)rotateImage:(CGFloat)angle
{
    CGFloat width     = self.size.width;
    CGFloat height    = self.size.height;
    CGFloat radian    = angle / 180.0f * M_PI;
    CGFloat newWidth  = fabs(width * cos(radian)) + fabs(height * sin(radian));
    CGFloat newHeight = fabs(width * sin(radian)) + fabs(height * cos(radian));
    
    UIImage *rotatedImage;
    @autoreleasepool {
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        CGContextRef context = UIGraphicsGetCurrentContext();
    
        CGContextTranslateCTM(context, newWidth / 2.0, newHeight / 2.0);
        CGContextRotateCTM(context, radian);
        CGContextTranslateCTM(context, -newWidth / 2.0, -newHeight / 2.0);
        
        [self drawInRect:CGRectMake((newWidth - width) / 2.0f, (newHeight - height) / 2.0f, width, height)];
        rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return rotatedImage;
}

- (UIImage *)fixOrientation
{
    UIImage *rotatedImage;
    @autoreleasepool {
        UIImageOrientation orientation   = self.imageOrientation;
        if (orientation == UIImageOrientationUp) return self;
        UIImage *removedOrientationImage = [UIImage imageWithCGImage:self.CGImage scale:1.0f orientation:UIImageOrientationUp];
        rotatedImage = [removedOrientationImage rotateImageWithOrientation:orientation];
    }
    return rotatedImage;
}

- (UIImage *)rotateImageWithOrientation:(UIImageOrientation)orientation
{
    UIImage *rotatedImage;
    switch (orientation) {
        case UIImageOrientationUp:
            rotatedImage = self;
            break;
        case UIImageOrientationDown:
            rotatedImage = [self rotateImage:180];
            break;
        case UIImageOrientationLeft:
            rotatedImage = [self rotateImage:270];
            break;
        case UIImageOrientationRight:
            rotatedImage = [self rotateImage:90];
            break;
        default:
            rotatedImage = self;
            break;
    }
    return rotatedImage;
}

- (UIImage *)maskImage:(UIImage *)maskImage maskPoint:(CGPoint)maskPoint
{
    static const int bitsPerComponent = 8;
    static const int bytesPerRow      = 0;
    
    CGFloat width  = self.size.width;
    CGFloat height = self.size.height;
    CGFloat maskWidth  = maskImage.size.width;
    CGFloat maskHeight = maskImage.size.height;
        
    CGRect rect = CGRectMake(maskPoint.x, maskPoint.y, width, height);
    CGRect maskRect = CGRectMake(0, 0, maskWidth, maskHeight);
    CGContextRef maskContext = CGBitmapContextCreate(NULL, maskWidth, maskHeight,
                                                     bitsPerComponent,
                                                     bytesPerRow, NULL, (CGBitmapInfo)kCGImageAlphaOnly);
    CGContextDrawImage(maskContext, maskRect, maskImage.CGImage);
    CGImageRef mask = CGBitmapContextCreateImage(maskContext);
    CGContextRelease(maskContext);
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef newImageContext = CGBitmapContextCreate(NULL, maskWidth, maskHeight,
                                                         bitsPerComponent,
                                                         bytesPerRow,
                                                         genericColorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(genericColorSpace);
    CGContextClipToMask(newImageContext, maskRect, mask);
    CGContextDrawImage(newImageContext, rect, self.CGImage);
    CGImageRelease(mask);
    
    CGImageRef maskedImage = CGBitmapContextCreateImage(newImageContext);
    CGContextRelease(newImageContext);
    UIImage *newImage = [UIImage imageWithCGImage:maskedImage];
    CGImageRelease(maskedImage);
    return newImage;
}

- (BOOL)writeImageToDisk:(NSString *)name
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), name];
    NSData *imageData  = UIImagePNGRepresentation(self);
    return ([imageData writeToFile:filePath atomically:YES]);
}

- (BOOL)writeImageToDisk:(NSString *)name withPath:(NSString *)path
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, name];
    NSData *imageData  = UIImagePNGRepresentation(self);
    return ([imageData writeToFile:filePath atomically:YES]);
}


@end
