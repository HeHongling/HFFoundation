//
//  UIBarButtonItem+HFFoundation.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HFFoundation)

#pragma mark- CustomView

+ (UIBarButtonItem *)hf_barButtonItemWithImage:(UIImage *)image
                              highlightedImage:(UIImage *)hlImage
                                        target:(id)target
                                        action:(SEL)action;

@end
