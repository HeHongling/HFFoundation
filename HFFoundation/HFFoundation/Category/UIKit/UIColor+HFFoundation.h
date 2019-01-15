//
//  UIColor+HFFoundation.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HFFoundation)

+ (UIColor *)hf_randomColor;
+ (nullable UIColor *)hf_colorWithHexString:(NSString *)hexStr;
+ (nullable UIColor *)hf_colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
+ (UIColor *)hf_colorWithRGB:(uint32_t)rgbValue;
+ (UIColor *)hf_colorWithRGBA:(uint32_t)rgbaValue;
+ (UIColor *)hf_colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

@end
NS_ASSUME_NONNULL_END
