//
//  UIView+HFFoundation.m
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "UIView+HFFoundation.h"
#import <objc/runtime.h>
#import "CGGeometry+HFFoundation.h"

@implementation UIView (HFFoundation)

@end

#pragma mark-
@implementation UIView (HFFoundation_Frame)

- (CGPoint)hf_origin {
    return self.hf_topLeftVertex;
}

- (void)setHf_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)hf_centerX {
    return self.center.x;
}

- (void)setHf_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)hf_centerY {
    return self.center.y;
}

- (void)setHf_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)hf_x {
    return self.frame.origin.x;
}

- (void)setHf_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)hf_y {
    return self.frame.origin.y;
}

- (void)setHf_y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGSize)hf_size {
    return self.frame.size;
}

- (void)setHf_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)hf_width {
    return self.frame.size.width;
}

- (void)setHf_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)hf_height {
    return self.frame.size.height;
}

- (void)setHf_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)hf_top {
    return self.frame.origin.y;
}

- (void)setHf_top:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)hf_left {
    return self.frame.origin.x;
}

- (void)setHf_left:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)hf_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setHf_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)hf_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setHf_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGPoint)hf_topLeftVertex {
    CGRect frame = self.hf_frame;
    return hf_CGPointApplyAffineTransform(self.center, frame.origin, self.transform);
}

- (CGPoint)hf_bottomLeftVertex {
    CGRect frame = self.hf_frame;
    CGPoint point = frame.origin;
    
// Attention: 不可使用 center 进行计算, layer.anchor 会改变 center
    point.y += frame.size.height;
    return hf_CGPointApplyAffineTransform(self.center, point, self.transform);
}

- (CGPoint)hf_bottomRightVertex {
    CGRect frame = self.hf_frame;
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    point.y += frame.size.height;
    return hf_CGPointApplyAffineTransform(self.center, point, self.transform);
}

- (CGPoint)hf_topRightVertex {
    CGRect frame = self.hf_frame;
    CGPoint point = frame.origin;
    point.x += frame.size.width;
    return hf_CGPointApplyAffineTransform(self.center, point, self.transform);
}

- (CGRect)hf_frame {
    CGAffineTransform currentTransform = self.transform;
    self.transform = CGAffineTransformIdentity;
    CGRect originalFrame = self.frame;
    self.transform = currentTransform;
    return originalFrame;
}

- (void)hf_setAnchorPoint:(CGPoint)anchorPoint {
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
    
    CGPoint position = self.layer.position;
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.layer.position = position;
    self.layer.anchorPoint = anchorPoint;
}

@end


#pragma mark-
@implementation UIView (HFFoundation_CornerRadius)

- (void)setHf_cornerRadius:(CGFloat)cornerRadius {
    objc_setAssociatedObject(self, @selector(cornerRadius), @(cornerRadius), OBJC_ASSOCIATION_ASSIGN);
    [self hf_addRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
}

- (CGFloat)hf_cornerRadius {
    return [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue];
}

- (void)hf_addRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
