//
//  UIBarButtonItem+HFFoundation.m
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "UIBarButtonItem+HFFoundation.h"

@implementation UIBarButtonItem (HFFoundation)

+ (UIBarButtonItem *)hf_barButtonItemWithImage:(UIImage *)image highlightedImage:(UIImage *)hlImage target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    
    if (hlImage) {
        [button setImage:hlImage forState:UIControlStateHighlighted];
    }
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
