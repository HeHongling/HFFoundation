//
//  HFPlaceHolder.m
//  HFFoundation
//
//  Created by HeHongling on 4/7/17.
//  Copyright © 2017 HeHongling. All rights reserved.
//

#import "HFPlaceHolder.h"
#import <objc/runtime.h>
@import QuartzCore;

@interface  HFPlaceHolderConfig()

@property (nonatomic, strong) NSArray *defaultMemberOfClasses;

@end

@implementation HFPlaceHolderConfig


- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.lineColor = [UIColor whiteColor];
        self.backColor = [UIColor clearColor];
        self.arrowSize = 3;
        self.lineWidth = 1;
        self.frameWidth = 0;
        self.frameColor = [UIColor redColor];
        
        self.showArrow = YES;
        self.showText = YES;
        
        self.visible = YES;
        self.autoDisplay = NO;
        self.visibleKindOfClasses = @[];
        self.visibleMemberOfClasses = @[];
        self.defaultMemberOfClasses = @[UIImageView.class,
                                        UIButton.class,
                                        UILabel.class,
                                        UITextField.class,
                                        UITextView.class,
                                        UISwitch.class,
                                        UISlider.class,
                                        UIPageControl.class];
    }
    
    return self;
}


- (void)setVisible:(BOOL)visible
{
    _visible = visible;
    
    UIResponder<UIApplicationDelegate> *delegate = (UIResponder<UIApplicationDelegate> *)[[UIApplication sharedApplication] delegate];
    
    if ( !visible )
    {
        [delegate.window hf_hidePlaceHolderWithAllSubviews];
    }
    else
    {
        [delegate.window hf_showPlaceHolderWithAllSubviews];
    }
}

+ (HFPlaceHolderConfig *)defaultConfig
{
    static dispatch_once_t  onceQueue;
    static HFPlaceHolderConfig *appInstance;
    
    dispatch_once(&onceQueue, ^{
        appInstance = [[HFPlaceHolderConfig alloc] init];
    });
    return appInstance;
}

@end

@interface HFPlaceHolder()


@end

@implementation HFPlaceHolder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        self.userInteractionEnabled = NO;
        
        self.lineColor  = [HFPlaceHolderConfig defaultConfig].lineColor;
        self.backColor  = [HFPlaceHolderConfig defaultConfig].backColor;
        self.arrowSize  = [HFPlaceHolderConfig defaultConfig].arrowSize;
        self.lineWidth  = [HFPlaceHolderConfig defaultConfig].lineWidth;
        self.frameColor = [HFPlaceHolderConfig defaultConfig].frameColor;
        self.frameWidth = [HFPlaceHolderConfig defaultConfig].frameWidth;
        
        self.showArrow = [HFPlaceHolderConfig defaultConfig].showArrow;
        self.showText = [HFPlaceHolderConfig defaultConfig].showText;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat fontSize = 4 + (MIN(width,height))/10;
    CGFloat arrowSize = self.arrowSize;
    CGFloat lineWidth = self.lineWidth;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    //fill the back
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, self.backColor.CGColor);
    CGContextSetLineJoin(ctx, kCGLineJoinMiter);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextFillRect(ctx, rect);
    
    // strike frame
    if ( self.frameWidth > 0 )
    {
        CGFloat radius = self.frameWidth/2;
        
        CGContextSetLineWidth(ctx, self.frameWidth);
        CGContextSetStrokeColorWithColor(ctx, self.frameColor.CGColor);
        
        CGContextMoveToPoint(ctx, radius, radius);
        CGContextAddLineToPoint(ctx, radius, height - radius);
        CGContextAddLineToPoint(ctx, width - radius, height - radius);
        CGContextAddLineToPoint(ctx, width - radius, radius);
        CGContextAddLineToPoint(ctx, radius, radius);
        CGContextClosePath(ctx);
        
        CGContextStrokePath(ctx);
    }
    
    if ( self.showArrow )
    {
        //strike lines & arrows
        CGFloat radius = self.frameWidth/2*3;
        
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
        
        CGContextMoveToPoint(ctx, width/2, radius);
        CGContextAddLineToPoint(ctx, width/2, height-radius);
        CGContextMoveToPoint(ctx, width/2, radius);
        CGContextAddLineToPoint(ctx, width/2 - arrowSize, arrowSize + radius);
        CGContextMoveToPoint(ctx, width/2, radius);
        CGContextAddLineToPoint(ctx, width/2 + arrowSize, arrowSize + radius);
        CGContextMoveToPoint(ctx, width/2, height-radius);
        CGContextAddLineToPoint(ctx, width/2 - arrowSize, height - arrowSize - radius);
        CGContextMoveToPoint(ctx, width/2, height-radius);
        CGContextAddLineToPoint(ctx, width/2 + arrowSize, height - arrowSize - radius);
        
        CGContextMoveToPoint(ctx, radius, height/2);
        CGContextAddLineToPoint(ctx, width - radius, height/2);
        CGContextMoveToPoint(ctx, radius, height/2);
        CGContextAddLineToPoint(ctx, arrowSize + radius, height/2 - arrowSize);
        CGContextMoveToPoint(ctx, radius, height/2);
        CGContextAddLineToPoint(ctx, arrowSize + radius, height/2 + arrowSize);
        CGContextMoveToPoint(ctx, width - radius, height/2);
        CGContextAddLineToPoint(ctx, width - arrowSize - radius, height/2 - arrowSize);
        CGContextMoveToPoint(ctx, width - radius, height/2);
        CGContextAddLineToPoint(ctx, width - arrowSize - radius, height/2 + arrowSize);
        
        CGContextStrokePath(ctx);
    }
    
    if ( self.showText )
    {
        //calculate the text area
        NSString *text = [NSString stringWithFormat:@"%.0f X %.0f",width, height];
        
        NSDictionary *textFontAttributes = @{
                                             NSFontAttributeName: font,
                                             NSForegroundColorAttributeName: self.lineColor
                                             };
        
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:textFontAttributes context:nil].size;
        
        CGFloat rectWidth = ceilf(textSize.width)+4;
        CGFloat rectHeight = ceilf(textSize.height)+4;
        
        //clear the area behind the textz
        CGRect textRect = CGRectMake(width/2-rectWidth/2, height/2-rectHeight/2, rectWidth, rectHeight);
        CGContextClearRect(ctx, textRect);
        CGContextSetFillColorWithColor(ctx, self.backColor.CGColor);
        CGContextFillRect(ctx, textRect);
        
        //draw text
        CGContextSetFillColorWithColor(ctx, self.lineColor.CGColor);
        [text drawInRect:CGRectInset(textRect, 0, 2) withAttributes:textFontAttributes];
    }
}


@end


@implementation UIView(HFPlaceHolder)

- (void)didMoveToSuperview
{
    [self checkAutoDisplay];
}

- (void)checkAutoDisplay
{
    if ( self.class != [HFPlaceHolder class] )
    {
        if ( [HFPlaceHolderConfig defaultConfig].autoDisplay )
        {
            //means self is a system bundle view
            if ( [NSBundle bundleForClass:[UIView class]] == [NSBundle bundleForClass:[self class]] )
            {
                if ( ![HFPlaceHolderConfig defaultConfig].autoDisplaySystemView ) {
                    
                    //skip if self is not in the white list
                    if ( ![[HFPlaceHolderConfig defaultConfig].defaultMemberOfClasses containsObject:self.class] )
                    {
                        return;
                    }
                }
            }
            
            if ([HFPlaceHolderConfig defaultConfig].visibleMemberOfClasses.count>0)
            {
                for ( Class cls in [HFPlaceHolderConfig defaultConfig].visibleMemberOfClasses )
                {
                    if ( [self isMemberOfClass:cls] )
                    {
                        [self hf_showPlaceHolder];
                        
                        return;
                    }
                }
            }
            else if ([HFPlaceHolderConfig defaultConfig].visibleKindOfClasses.count>0)
            {
                for ( Class cls in [HFPlaceHolderConfig defaultConfig].visibleKindOfClasses )
                {
                    if ( [self isKindOfClass:cls] )
                    {
                        [self hf_showPlaceHolder];
                        
                        return;
                    }
                }
            }
            else
            {
                [self hf_showPlaceHolder];
                
            }
        }
    }
}


- (void)hf_showPlaceHolder
{
    [self hf_showPlaceHolderWithLineColor:[HFPlaceHolderConfig defaultConfig].lineColor];
}

- (void)hf_showPlaceHolderWithAllSubviews
{
    [self hf_showPlaceHolderWithAllSubviews:NSIntegerMax];
}

- (void)hf_showPlaceHolderWithAllSubviews:(NSInteger)maxDepth
{
    if ( maxDepth > 0 )
    {
        for ( UIView *v in self.subviews )
        {
            [v hf_showPlaceHolderWithAllSubviews:maxDepth-1];
        }
    }
    
    [self hf_showPlaceHolder];
}

- (void)hf_showPlaceHolderWithLineColor:(UIColor *)lineColor
{
    [self hf_showPlaceHolderWithLineColor:lineColor backColor:[HFPlaceHolderConfig defaultConfig].backColor];
}

- (void)hf_showPlaceHolderWithLineColor:(UIColor *)lineColor backColor:(UIColor *)backColor
{
    [self hf_showPlaceHolderWithLineColor:lineColor backColor:backColor arrowSize:[HFPlaceHolderConfig defaultConfig].arrowSize];
}


- (void)hf_showPlaceHolderWithLineColor:(UIColor *)lineColor backColor:(UIColor *)backColor arrowSize:(CGFloat)arrowSize
{
    [self hf_showPlaceHolderWithLineColor:lineColor backColor:backColor arrowSize:arrowSize lineWidth:[HFPlaceHolderConfig defaultConfig].lineWidth];
}


- (void)hf_showPlaceHolderWithLineColor:(UIColor *)lineColor backColor:(UIColor *)backColor arrowSize:(CGFloat)arrowSize lineWidth:(CGFloat)lineWidth
{
    
    [self hf_showPlaceHolderWithLineColor:lineColor backColor:backColor arrowSize:arrowSize lineWidth:[HFPlaceHolderConfig defaultConfig].lineWidth frameWidth:[HFPlaceHolderConfig defaultConfig].frameWidth frameColor:[HFPlaceHolderConfig defaultConfig].frameColor];
}

- (void)hf_showPlaceHolderWithLineColor:(UIColor *)lineColor backColor:(UIColor *)backColor arrowSize:(CGFloat)arrowSize lineWidth:(CGFloat)lineWidth frameWidth:(CGFloat)frameWidth frameColor:(UIColor *)frameColor
{
    NSLog(@"%@",NSStringFromClass(self.class));
#if RELEASE
    
#else
    
    HFPlaceHolder *placeHolder = [self hf_getPlaceHolder];
    
    if ( !placeHolder )
    {
        placeHolder = [[HFPlaceHolder alloc] initWithFrame:self.bounds];
        
        placeHolder.tag = [NSStringFromClass([HFPlaceHolder class]) hash]+(NSInteger)self;
        
        [self addSubview:placeHolder];
    }
    
    placeHolder.lineColor  = lineColor;
    placeHolder.backColor  = backColor;
    placeHolder.arrowSize  = arrowSize;
    placeHolder.lineWidth  = lineWidth;
    placeHolder.frameColor = frameColor;
    placeHolder.frameWidth = frameWidth;
    placeHolder.hidden = ![HFPlaceHolderConfig defaultConfig].visible;
    
    
#endif
}

- (void)hf_hidePlaceHolder
{
    HFPlaceHolder *placeHolder = [self hf_getPlaceHolder];
    
    if ( placeHolder )
    {
        placeHolder.hidden = YES;
    }
}

- (void)hf_hidePlaceHolderWithAllSubviews
{
    for ( UIView *v in self.subviews )
    {
        [v hf_hidePlaceHolderWithAllSubviews];
    }
    
    [self hf_hidePlaceHolder];
}

- (void)hf_removePlaceHolder
{
    HFPlaceHolder *placeHolder = [self hf_getPlaceHolder];
    
    if ( placeHolder )
    {
        [placeHolder removeFromSuperview];
    }
}

- (void)hf_removePlaceHolderWithAllSubviews
{
    for ( UIView *v in self.subviews )
    {
        [v hf_removePlaceHolderWithAllSubviews];
    }
    
    [self hf_removePlaceHolder];
}


- (HFPlaceHolder *)hf_getPlaceHolder
{
    return (HFPlaceHolder*)[self viewWithTag:[NSStringFromClass([HFPlaceHolder class]) hash]+(NSInteger)self];
}

@end
