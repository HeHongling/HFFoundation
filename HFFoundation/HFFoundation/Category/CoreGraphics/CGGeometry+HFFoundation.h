//
//  CGGeometry+HFFoundation.h
//  HFFoundation
//
//  Created by HeHongling on 31/05/2017.
//  Copyright © 2017 HeHongling. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

/// Point 旋转(自定义 center)
CG_EXTERN CGPoint hf_CGPointRotateAboutPoint(CGPoint point, CGPoint center, float angle);

/// Point 仿射变换(自定义 center)
CG_EXTERN CGPoint hf_CGPointApplyAffineTransform(CGPoint origin, CGPoint point, CGAffineTransform t);

/// Point 逆仿射变换(自定义 center)
CG_EXTERN CGPoint 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(CGPoint origin, CGPoint point, CGAffineTransform t);

/// Rect 逆仿射变换(自定义 center), 注意旋转后 view.frame 不准确
CG_EXTERN CGRect hf_CGRectReverseApplyAffineTransform(CGPoint origin, CGRect rect, CGAffineTransform t);
