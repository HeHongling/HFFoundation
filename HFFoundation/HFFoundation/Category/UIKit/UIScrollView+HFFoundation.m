//
//  UIScrollView+HFFoundation.m
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "UIScrollView+HFFoundation.h"

@implementation UIScrollView (HFFoundation)

- (void)hf_scrollToTop {
    [self hf_scrollToTopAnimated:YES];
}

- (void)hf_scrollToBottom {
    [self hf_scrollToBottomAnimated:YES];
}

- (void)hf_scrollToLeft {
    [self hf_scrollToLeftAnimated:YES];
}

- (void)hf_scrollToRight {
    [self hf_scrollToRightAnimated:YES];
}

- (void)hf_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)hf_scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)hf_scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)hf_scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}

@end
