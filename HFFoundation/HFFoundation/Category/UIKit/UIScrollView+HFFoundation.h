//
//  UIScrollView+HFFoundation.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HFFoundation)

- (void)hf_scrollToTop;
- (void)hf_scrollToBottom;
- (void)hf_scrollToLeft;
- (void)hf_scrollToRight;
- (void)hf_scrollToTopAnimated:(BOOL)animated;
- (void)hf_scrollToBottomAnimated:(BOOL)animated;
- (void)hf_scrollToLeftAnimated:(BOOL)animated;
- (void)hf_scrollToRightAnimated:(BOOL)animated;

@end
