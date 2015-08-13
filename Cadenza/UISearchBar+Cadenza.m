//
//  UISearchBar+Cadenza.m
//  Pods
//
//  Created by goccy on 2015/05/16.
//
//

#import "UISearchBar+Cadenza.h"
#import "UIView+Cadenza.h"

@implementation UISearchBar (Cadenza)

- (UITextField *)searchTextField
{
    return [self findTextField:self];
}

- (UIImageView *)searchIcon
{
    return [self findImageView:[self searchTextField]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    return YES;
}

- (UIImageView *)findImageView:(UIView *)baseView
{
    if ([baseView isKindOfClass:[UIImageView class]] && baseView.width < 20 && baseView.height < 20) return (UIImageView *)baseView;
    for (UIView *subview in [baseView subviews]) {
        UIImageView *foundView = [self findImageView:subview];
        if (foundView) return foundView;
    }
    return nil;
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
