//
//  CGGeometry+HFFoundation.m
//  HFFoundation
//
//  Created by HeHongling on 31/05/2017.
//  Copyright © 2017 HeHongling. All rights reserved.
//

#import "CGGeometry+HFFoundation.h"
#import <math.h>

CGPoint hf_CGPointRotateAboutPoint(CGPoint point, CGPoint center, float angle) {
    CGPoint newPoint;
    newPoint.x = (point.x - center.x) * cosf(angle) - (point.y - center.y) * sinf(angle) + center.x;
    newPoint.y = (point.x - center.x) * sinf(angle) + (point.y - center.y) * cosf(angle) + center.y;
    return newPoint;
}

CGPoint hf_CGPointApplyAffineTransform(CGPoint origin, CGPoint point, CGAffineTransform t) {
    CGPoint relativeP;
    relativeP.x = point.x - origin.x;
    relativeP.y = point.y - origin.y;
    CGPoint relativeResult = CGPointApplyAffineTransform(relativeP, t);
    
    CGPoint p;
    p.x = relativeResult.x + origin.x;
    p.y = relativeResult.y + origin.y;
    return p;
}

CGPoint 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(CGPoint origin, CGPoint point, CGAffineTransform t) {
    CGPoint relativeP;
    relativeP.x = point.x - origin.x;
    relativeP.y = point.y - origin.y;
    CGPoint relativeResult = CGPointApplyAffineTransform(relativeP, CGAffineTransformInvert(t));
    
    CGPoint p;
    p.x = relativeResult.x + origin.x;
    p.y = relativeResult.y + origin.y;
    return p;
}

CGRect hf_CGRectReverseApplyAffineTransform(CGPoint origin, CGRect rect, CGAffineTransform t) {
    CGPoint offset = CGPointMake(-origin.x, -origin.y);
    CGRect relativeRect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeTranslation(offset.x, offset.y));
    CGRect relativeResult = CGRectApplyAffineTransform(relativeRect, CGAffineTransformInvert(t));
    CGRect resultRect = CGRectApplyAffineTransform(relativeResult, CGAffineTransformMakeTranslation(-offset.x, -offset.y));
    return resultRect;
}
