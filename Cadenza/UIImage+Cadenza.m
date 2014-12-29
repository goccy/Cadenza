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

- (UIImage *)invertedAlpha
{
    BOOL hasAlpha = [self hasAlphaChannel];
    if (!hasAlpha) return nil;
    
    CGColorSpaceRef colorSpace     = CGImageGetColorSpace(self.CGImage);
    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
    
    BOOL isGrayScale = (colorSpace == grayColorSpace) ? YES : NO;
    
    CGColorSpaceRelease(colorSpace);
    CGColorSpaceRelease(grayColorSpace);
    
    if (isGrayScale) {
        return [self convertGrayScalePixels:^(UInt8 *buf, UInt8 gray, UInt8 alpha, int x, int y) {
            *(buf + 0) = 0;
            *(buf + 1) = 255 - alpha;
        }];
    } else {
        return [self convertRGBAPixels:^(UInt8 *buf, UInt8 r, UInt8 g, UInt8 b, UInt8 a, int x, int y) {
            *(buf + 0) = 0;
            *(buf + 1) = 0;
            *(buf + 2) = 0;
            *(buf + 3) = 255 - a;
        }];
    }
}

- (BOOL)hasAlphaChannel
{
    CGImageRef cgImageRef = self.CGImage;
    CGImageAlphaInfo info = CGImageGetAlphaInfo(cgImageRef);
    return (info == kCGImageAlphaPremultipliedLast  ||
            info == kCGImageAlphaPremultipliedFirst ||
            info == kCGImageAlphaLast               ||
            info == kCGImageAlphaFirst) ? YES : NO;
}

- (UIImage *)convertRGBAPixels:(void(^)(UInt8 *buf, UInt8 r, UInt8 g, UInt8 b, UInt8 a, int x, int y))convertBlock
{
    return [self convertPixelsBase:^(UInt8 *pixels, size_t bytesPerRow, int x, int y) {
            UInt8 *buf = pixels + y * bytesPerRow + x * 4;
            UInt8 r    = *(buf + 0);
            UInt8 g    = *(buf + 1);
            UInt8 b    = *(buf + 2);
            UInt8 a    = *(buf + 3);
            convertBlock(buf, r, g, b, a, x, y);
    }];
}

- (UIImage *)convertGrayScalePixels:(void(^)(UInt8 *buf, UInt8 gray, UInt8 alpha, int x, int y))convertBlock
{
    return [self convertPixelsBase:^(UInt8 *pixels, size_t bytesPerRow, int x, int y) {
        UInt8 *buf  = pixels + y * bytesPerRow + x * 2;
        UInt8 gray  = *(buf + 0);
        UInt8 alpha = *(buf + 1);
        convertBlock(buf, gray, alpha, x, y);
    }];
}

- (UIImage *)convertPixelsBase:(void(^)(UInt8 *pixels, size_t bytesPerRow, int x, int y))convertProcess
{
    UIImage *image                 = self;
    CGImageRef cgImage             = [image CGImage];
    size_t bytesPerRow             = CGImageGetBytesPerRow(cgImage);
    CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
    CFDataRef data                 = CGDataProviderCopyData(dataProvider);
    CFMutableDataRef inputData     = CFDataCreateMutableCopy(0, 0, data);
    UInt8 *pixels                  = (UInt8 *)CFDataGetMutableBytePtr(inputData);
    
    for (int y = 0 ; y < image.size.height; y++){
        for (int x = 0; x < image.size.width; x++){
            convertProcess(pixels, bytesPerRow, x, y);
        }
    }
    
    CFDataRef resultData                 = CFDataCreate(NULL, pixels, CFDataGetLength(data));
    CGDataProviderRef resultDataProvider = CGDataProviderCreateWithCFData(resultData);
    CGImageRef resultCgImage             = CGImageCreate(CGImageGetWidth(cgImage),
                                                         CGImageGetHeight(cgImage),
                                                         CGImageGetBitsPerComponent(cgImage),
                                                         CGImageGetBitsPerPixel(cgImage),
                                                         bytesPerRow,
                                                         CGImageGetColorSpace(cgImage),
                                                         CGImageGetBitmapInfo(cgImage),
                                                         resultDataProvider,
                                                         NULL,
                                                         CGImageGetShouldInterpolate(cgImage),
                                                         CGImageGetRenderingIntent(cgImage));
    UIImage *result = [[UIImage alloc] initWithCGImage:resultCgImage];
    
    CGImageRelease(resultCgImage);
    CFRelease(resultDataProvider);
    CFRelease(resultData);
    CFRelease(data);
    free(pixels);
    return result;
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
