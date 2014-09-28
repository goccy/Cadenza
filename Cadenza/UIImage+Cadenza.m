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

- (UIImage *)resizeImageAspectFit:(CGSize)requiredSize
{
    UIGraphicsBeginImageContext(requiredSize);
    CGRect rect = AVMakeRectWithAspectRatioInsideRect(self.size, CGRectMake(0, 0, requiredSize.width, requiredSize.height));
    [self drawInRect:rect];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

- (UIImage *)rotateImage:(CGFloat)angle
{
    CGFloat width     = self.size.width;
    CGFloat height    = self.size.height;
    CGFloat radian    = angle / 180.0f * M_PI;
    CGFloat newWidth  = fabs(width * cos(radian)) + fabs(height * sin(radian));
    CGFloat newHeight = fabs(width * sin(radian)) + fabs(height * cos(radian));
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, newWidth / 2.0, newHeight / 2.0);
    CGContextRotateCTM(context, radian);
    CGContextTranslateCTM(context, -newWidth / 2.0, -newHeight / 2.0);
    
    [self drawInRect:CGRectMake((newWidth - width) / 2.0f, (newHeight - height) / 2.0f, width, height)];
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
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