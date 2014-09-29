//
//  ALAsset+Cadenza.h
//  Cadenza
//
//  Created by masaaki goshima on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAsset (Cadenza)

- (NSString *)imageBasePath;
- (UIImage *)thumbnailImage;
- (UIImage *)fullScreenImage;
- (UIImage *)fullResolutionImage;
- (NSString *)thumbnailImageSavePath;
- (NSString *)fullScreenImageSavePath;
- (NSString *)fullResolutionImageSavePath;
- (BOOL)saveThumbnailImage;
- (BOOL)saveFullScreenImage;
- (BOOL)saveFullResolutionImage;
- (BOOL)saveAllImage;

@end
