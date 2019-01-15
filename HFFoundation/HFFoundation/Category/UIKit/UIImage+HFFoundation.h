//
//  UIImage+HFFoundation.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HFFoundation)

// 不进行渲染的图片
+ (instancetype)hf_imageWithOriginalModeNamed:(NSString *)imageName;

- (UIImage *)hf_scaleToSize:(CGSize)size;
- (UIImage *)hf_scaleToFillSize:(CGSize)size;

+ (UIImage *)hf_imageWithColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat)alpha;

@end
