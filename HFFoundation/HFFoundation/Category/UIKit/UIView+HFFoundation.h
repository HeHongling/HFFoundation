//
//  UIView+HFFoundation.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (HFFoundation)

@end


@interface UIView (HFFoundation_Frame)
@property (nonatomic, assign) CGPoint hf_origin;
@property (nonatomic, assign) CGFloat hf_centerX;
@property (nonatomic, assign) CGFloat hf_centerY;
@property (nonatomic, assign) CGFloat hf_x;
@property (nonatomic, assign) CGFloat hf_y;
@property (nonatomic, assign) CGSize  hf_size;
@property (nonatomic, assign) CGFloat hf_width;
@property (nonatomic, assign) CGFloat hf_height;
@property (nonatomic, assign) CGFloat hf_top;
@property (nonatomic, assign) CGFloat hf_left;
@property (nonatomic, assign) CGFloat hf_bottom;
@property (nonatomic, assign) CGFloat hf_right;
@property (nonatomic, assign, readonly) CGRect hf_frame;
@property (nonatomic, assign, readonly) CGPoint hf_topLeftVertex;
@property (nonatomic, assign, readonly) CGPoint hf_bottomLeftVertex;
@property (nonatomic, assign, readonly) CGPoint hf_bottomRightVertex;
@property (nonatomic, assign, readonly) CGPoint hf_topRightVertex;

- (void)hf_setAnchorPoint:(CGPoint)anchorPoint;
@end


@interface UIView (HFFoundation_CornerRadius)
@property (nonatomic, assign) CGFloat hf_cornerRadius;
- (void)hf_addRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
@end
