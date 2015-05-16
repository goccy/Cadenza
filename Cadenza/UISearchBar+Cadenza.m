//
//  UISearchBar+Cadenza.m
//  Pods
//
//  Created by goccy on 2015/05/16.
//
//

#import "UISearchBar+Cadenza.h"

@implementation UISearchBar (Cadenza)

- (UITextField *)searchTextField
{
    return [self findTextField:self];
}

- (UITextField *)findTextField:(UIView *)baseView
{
    if ([baseView isKindOfClass:[UITextField class]]) return (UITextField *)baseView;
    for (UIView *subview in [baseView subviews]) {
        UITextField *foundView = [self findTextField:subview];
        if (foundView) return foundView;
    }
    return nil;
}

@end
