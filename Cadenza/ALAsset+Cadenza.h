//
//  ALAsset+Cadenza.h
//  Cadenza
//
//  Created by masaaki goshima on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

@interface ALAsset (Cadenza)

- (NSString *)imageBasePath;

- (UIImage *)thumbnailImage;
- (UIImage *)fullScreenImage;
- (UIImage *)fullResolutionImage;

/* for Writing to Disk */
- (NSString *)thumbnailImageSavePath;
- (NSString *)fullScreenImageSavePath;
- (NSString *)fullResolutionImageSavePath;

/* for Loading from Disk */
/* the following three methods are searching from applicationSupportDirectory */
+ (NSString *)thumbnailImageSavePathWithBasePath:(NSString *)imageBasePath;
+ (NSString *)fullScreenImageSavePathWithBasePath:(NSString *)imageBasePath;
+ (NSString *)fullResolutionImageSavePathWithBasePath:(NSString *)imageBasePath;

+ (NSString *)thumbnailImageSavePathWithDirectoryPath:(NSString *)directoryPath withBasePath:(NSString *)imageBasePath;
+ (NSString *)fullScreenImageSavePathWithDirectoryPath:(NSString *)directoryPath withBasePath:(NSString *)imageBasePath;
+ (NSString *)fullResolutionImageSavePathWithDirectoryPath:(NSString *)directoryPath withBasePath:(NSString *)imageBasePath;



- (BOOL)saveThumbnailImage;
- (BOOL)saveFullScreenImage;
- (BOOL)saveFullResolutionImage;
- (BOOL)saveAllImage;

@end
