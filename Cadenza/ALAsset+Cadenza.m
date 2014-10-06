//
//  ALAsset+Cadenza.m
//  Cadenza
//
//  Created by masaaki goshima on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "ALAsset+Cadenza.h"
#import "NSString+Cadenza.h"

@implementation ALAsset (Cadenza)

- (UIImage *)thumbnailImage
{
    return [UIImage imageWithCGImage:[self thumbnail]];
}

- (UIImage *)fullScreenImage
{
    return [UIImage imageWithCGImage:[[self defaultRepresentation] fullScreenImage]];
}

- (UIImage *)fullResolutionImage
{
    ALAssetRepresentation *rep = [self defaultRepresentation];
    return [UIImage imageWithCGImage:[rep fullResolutionImage] scale:rep.scale orientation:rep.orientation];
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

+ (NSString *)thumbnailImageSavePathWithBasePath:(NSString *)imageBasePath
{
    return [NSString stringWithFormat:@"%@/thumbnail-%@.png", [NSString applicationSupportDirectory], imageBasePath];
}

- (NSString *)fullScreenImageSavePath
{
    return [NSString stringWithFormat:@"%@/fullScreen-%@.png", [NSString applicationSupportDirectory], [self imageBasePath]];
}

+ (NSString *)fullScreenImageSavePathWithBasePath:(NSString *)imageBasePath
{
    return [NSString stringWithFormat:@"%@/fullScreen-%@.png", [NSString applicationSupportDirectory], imageBasePath];
}

- (NSString *)fullResolutionImageSavePath
{
    return [NSString stringWithFormat:@"%@/fullResolution-%@.png", [NSString applicationSupportDirectory], [self imageBasePath]];
}

+ (NSString *)fullResolutionImageSavePathWithBasePath:(NSString *)imageBasePath
{
    return [NSString stringWithFormat:@"%@/fullResolution-%@.png", [NSString applicationSupportDirectory], imageBasePath];
}

- (BOOL)saveThumbnailImage
{
    NSData *thumbnailData = UIImagePNGRepresentation([self thumbnailImage]);
    return [thumbnailData writeToFile:[self thumbnailImageSavePath] atomically:YES];
}

- (BOOL)saveFullScreenImage
{
    NSData *fullScreenData = UIImagePNGRepresentation([self fullScreenImage]);
    return [fullScreenData writeToFile:[self fullScreenImageSavePath] atomically:NO];
}

- (BOOL)saveFullResolutionImage
{
    NSData *fullResolutionData = UIImagePNGRepresentation([self fullResolutionImage]);
    return [fullResolutionData writeToFile:[self fullResolutionImageSavePath] atomically:NO];
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
