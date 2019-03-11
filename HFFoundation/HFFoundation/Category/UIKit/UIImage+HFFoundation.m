//
//  UIImage+HFFoundation.m
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "UIImage+HFFoundation.h"
@class AppDelegate;

@implementation UIImage (HFFoundation)

#pragma mark- RenderMode

+ (instancetype)hf_imageWithOriginalModeNamed:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark- Scale

- (UIImage *)hf_scaleToSize:(CGSize)size {
    return [self hf_scaleToFillSize:size];
}

- (UIImage *)hf_scaleToFillSize:(CGSize)size {
    CGFloat destWidth = size.width ;
    CGFloat destHeight = size.height ;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(destWidth, destHeight), NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, destWidth, destHeight)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

#pragma mark- Create with color

+ (UIImage *)hf_imageWithColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat)alpha {
    if (!color || size.width <= 0 || size.height <= 0) {
        return nil;
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetAlpha(ctx, alpha);
    CGContextFillRect(ctx, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)hf_imageNamed:(NSString *)name bundleNamed:(NSString *)bundle {
    if (!name) {
        return nil;
    }
    NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HFFoundation")];
    NSURL *bundleURL = [mainBundle URLForResource:bundle withExtension:@"bundle"];
    NSBundle *targetBundle = [NSBundle bundleWithURL:bundleURL];
    NSString *imagePath = [[[targetBundle resourcePath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}
@end
