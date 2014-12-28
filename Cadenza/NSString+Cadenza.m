//
//  NSString+Cadenza.m
//  Cadenza
//
//  Created by masaaki goshima on 2014/09/29.
//  Copyright (c) 2014年 masaaki goshima. All rights reserved.
//

#import "NSString+Cadenza.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Cadenza)

- (NSInteger)numberOfLines
{
    NSInteger newLineCharCount = [self length] - [[self stringByReplacingOccurrencesOfString:@"\n" withString:@""] length];
    newLineCharCount /= [@"\n" length];
    return newLineCharCount + 1;
}

- (CGRect)contentFrame:(UIFont *)font
{
    if (!self.length) return CGRectZero;
    return [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{ NSFontAttributeName : font }
                              context:nil];
}

- (id)loadFromJSONFile
{
    NSError *error = nil;
    NSString *json = [[NSString alloc] initWithContentsOfFile:self encoding:NSUTF8StringEncoding error: &error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    return [json jsonToObject];
}

- (id)jsonToObject
{
    NSData *jsonData = [self dataUsingEncoding:NSUnicodeStringEncoding];
    NSError *error   = nil;
    id jsonObject    = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingAllowFragments
                                                         error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    return jsonObject;
}

- (NSString *)md5
{
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)applicationSupportDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@end
