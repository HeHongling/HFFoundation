//
//  HFPlaceHolder.h
//  HFFoundation
//
//  Created by HeHongling on 4/7/17.
//  Copyright © 2017 HeHongling. All rights reserved.
//

/**
 原作者：https://github.com/adad184/MMPlaceHolder
 */

#import <UIKit/UIKit.h>

@interface HFPlaceHolderConfig : NSObject
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) CGFloat arrowSize;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *frameColor;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) BOOL showArrow;
@property (nonatomic, assign) BOOL showText;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL autoDisplay;
@property (nonatomic, assign) BOOL autoDisplaySystemView;
@property (nonatomic, strong) NSArray *visibleMemberOfClasses;
@property (nonatomic, strong) NSArray *visibleKindOfClasses;
+ (HFPlaceHolderConfig*) defaultConfig;
@end


@interface HFPlaceHolder : UIView
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) CGFloat arrowSize;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *frameColor;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) BOOL showArrow;
@property (nonatomic, assign) BOOL showText;
@end


@interface UIView(HFPlaceHolder)
- (void)hf_showPlaceHolder;
- (void)hf_showPlaceHolderWithAllSubviews;
- (void)hf_showPlaceHolderWithAllSubviews:(NSInteger)maxDepth;
- (void)hf_showPlaceHolderWithLineColor:(UIColor*)lineColor;
- (void)hf_showPlaceHolderWithLineColor:(UIColor*)lineColor backColor:(UIColor*)backColor;
- (void)hf_showPlaceHolderWithLineColor:(UIColor*)lineColor backColor:(UIColor*)backColor arrowSize:(CGFloat)arrowSize;
- (void)hf_showPlaceHolderWithLineColor:(UIColor*)lineColor backColor:(UIColor*)backColor arrowSize:(CGFloat)arrowSize lineWidth:(CGFloat)lineWidth;
- (void)hf_showPlaceHolderWithLineColor:(UIColor*)lineColor backColor:(UIColor*)backColor arrowSize:(CGFloat)arrowSize lineWidth:(CGFloat)lineWidth frameWidth:(CGFloat)frameWidth frameColor:(UIColor*)frameColor;
- (void)hf_hidePlaceHolder;
- (void)hf_hidePlaceHolderWithAllSubviews;
- (void)hf_removePlaceHolder;
- (void)hf_removePlaceHolderWithAllSubviews;
- (HFPlaceHolder *)hf_getPlaceHolder;
@end
