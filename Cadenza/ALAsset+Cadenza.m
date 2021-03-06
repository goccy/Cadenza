//
//  ALAsset+Cadenza.m
//  Cadenza
//
//  Created by masaaki goshima on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "ALAsset+Cadenza.h"
#import "NSString+Cadenza.h"
#import "UIImage+Cadenza.h"

@implementation ALAsset (Cadenza)

- (UIImage *)thumbnailImage
{
    /* [self thumbnail] is JPEG only */
    CGSize thumbnailSize = [UIImage imageWithCGImage:[self thumbnail]].size;
    return [[self fullResolutionImage] resizeImageAspectFit:thumbnailSize];
}

- (UIImage *)fullScreenImage
{
    return [UIImage imageWithCGImage:[[self defaultRepresentation] fullScreenImage]];
}

- (UIImage *)fullResolutionImage
{
    ALAssetRepresentation *rep = [self defaultRepresentation];
    return [UIImage imageWithCGImage:[rep fullResolutionImage] scale:rep.scale orientation:(UIImageOrientation)rep.orientation];
}

- (NSString *)imageBasePath
{
    ALAssetRepresentation *rep = [self defaultRepresentation];
    return [[[rep url] absoluteString] md5];
}

- (NSString *)thumbnailImageSavePath
{
    return [NSString stringWithFormat:@"%@/thumbnail-%@.png", [NSString applicationSupportDirectory], [self imageBasePath]];
}

+ (NSString *)thumbnailImageSavePathWithDirectoryPath:(NSString *)directoryPath withBasePath:(NSString *)imageBasePath
{
    return [NSString stringWithFormat:@"%@/thumbnail-%@.png", directoryPath, imageBasePath];
}

+ (NSString *)thumbnailImageSavePathWithBasePath:(NSString *)imageBasePath
{
    return [NSString stringWithFormat:@"%@/thumbnail-%@.png", [NSString applicationSupportDirectory], imageBasePath];
}

- (NSString *)fullScreenImageSavePath
{
    return [NSString stringWithFormat:@"%@/fullScreen-%@.png", [NSString applicationSupportDirectory], [self imageBasePath]];
}

+ (NSString *)fullScreenImageSavePathWithDirectoryPath:(NSString *)directoryPath withBasePath:(NSString *)imageBasePath
{
    return [NSString stringWithFormat:@"%@/fullScreen-%@.png", directoryPath, imageBasePath];
}

+ (NSString *)fullScreenImageSavePathWithBasePath:(NSString *)imageBasePath
{
    return [NSString stringWithFormat:@"%@/fullScreen-%@.png", [NSString applicationSupportDirectory], imageBasePath];
}

- (NSString *)fullResolutionImageSavePath
{
    return [NSString stringWithFormat:@"%@/fullResolution-%@.png", [NSString applicationSupportDirectory], [self imageBasePath]];
}

+ (NSString *)fullResolutionImageSavePathWithDirectoryPath:(NSString *)directoryPath withBasePath:(NSString *)imageBasePath
{
    return [NSString stringWithFormat:@"%@/fullResolution-%@.png", directoryPath, imageBasePath];
}

+ (NSString *)fullResolutionImageSavePathWithBasePath:(NSString *)imageBasePath
{
    return [NSString stringWithFormat:@"%@/fullResolution-%@.png", [NSString applicationSupportDirectory], imageBasePath];
}

- (BOOL)saveThumbnailImage
{
    BOOL isSuccess = NO;
    @autoreleasepool {
        NSData *thumbnailData = UIImagePNGRepresentation([self thumbnailImage]);
        isSuccess = [thumbnailData writeToFile:[self thumbnailImageSavePath] atomically:YES];
    }
    return isSuccess;
}

- (BOOL)saveFullScreenImage
{
    BOOL isSuccess = NO;
    @autoreleasepool {
        NSData *fullScreenData = UIImagePNGRepresentation([self fullScreenImage]);
        isSuccess = [fullScreenData writeToFile:[self fullScreenImageSavePath] atomically:NO];
    }
    return isSuccess;
}

- (BOOL)saveFullResolutionImage
{
    BOOL isSuccess = NO;
    @autoreleasepool {
        UIImage *fullResolutionImage = [self fullResolutionImage];
        fullResolutionImage          = [fullResolutionImage fixOrientation];
        NSData *fullResolutionData = UIImagePNGRepresentation(fullResolutionImage);
        isSuccess = [fullResolutionData writeToFile:[self fullResolutionImageSavePath] atomically:NO];
    }
    return isSuccess;
}

- (BOOL)saveAllImage
{
    NSString *saveDirectoryPath = [NSString applicationSupportDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:saveDirectoryPath]) {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:saveDirectoryPath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error]) {
            NSLog(@"[ERROR] Cannot create directory : %@", error);
            return NO;
        }
    }
    dispatch_queue_t saveImageQueue = dispatch_queue_create("saveImageQueue", NULL);
    dispatch_async(saveImageQueue, ^{
        if (![self saveThumbnailImage]) {
            NSLog(@"[ERROR] Cannot save thumbnailImage. path = [%@]", [self thumbnailImageSavePath]);
        }
        if (![self saveFullScreenImage]) {
            NSLog(@"[ERROR] Cannot save fullScreenImage. path = [%@]", [self fullScreenImageSavePath]);
        }
        if (![self saveFullResolutionImage]) {
            NSLog(@"[ERROR] Cannot save fullResolutionImage. path = [%@]", [self fullResolutionImageSavePath]);
        }
    });
    return YES;
}

@end
