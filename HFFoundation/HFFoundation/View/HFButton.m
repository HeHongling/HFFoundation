//
//  HFButton.m
//  HFFoundation
//
//  Created by HeHongling on 11/15/16.
//
//

#import "HFButton.h"
#import <objc/runtime.h>
#import "HFMethodSwizzle.h"

@implementation HFButton

@end


@implementation HFButton (StateBackgroundColor)

+ (void)initialize {
    if (self == [UIButton self]) {
        hf_methodSwizzle([self class], @selector(setHighlighted:), @selector(hf_setHighlighted:));
        hf_methodSwizzle([self class], @selector(setSelected:), @selector(hf_setSelected:));
        hf_methodSwizzle([self class], @selector(setBackgroundColor:), @selector(hf_setBackgroundColor:));
    }
}

- (void)hf_setBackgroundColor:(UIColor *)backgroundColor {
    [self hf_setBackgroundColor:backgroundColor forState:UIControlStateNormal];
}

- (void)hf_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    if (state == UIControlStateNormal) {
        [super setBackgroundColor:backgroundColor];
    }
    // textField clearButton 会设置 color = nil
    [self.colors setObject:backgroundColor?: [UIColor clearColor] forKey:[self keyForState:state]];
}

- (UIColor *)hf_backgroundColorForState:(UIControlState)state {
    return (UIColor *)[self.colors objectForKey:[self keyForState:state]];
}

- (void)hf_setHighlighted:(BOOL)highlighted {
    [self hf_setHighlighted:highlighted];
    UIColor *highlightedColor = [self hf_backgroundColorForState:UIControlStateHighlighted];
    if (highlighted && highlightedColor) {
        [self hf_setBackgroundColor:highlightedColor];
    } else {
        // selected 之后会再调用一次 highlighted ，所以需要判断
        if ([self isSelected]) {
            UIColor *selectedColor = [self hf_backgroundColorForState:UIControlStateSelected];
            [self hf_setBackgroundColor:selectedColor];
        } else {
            UIColor *normalColor = [self hf_backgroundColorForState:UIControlStateNormal]?: self.backgroundColor;
            [self hf_setBackgroundColor:normalColor];
        }
    }
}

- (void)hf_setSelected:(BOOL)selected {
    [self hf_setSelected:selected];
    UIColor *selectedColor = [self hf_backgroundColorForState:UIControlStateSelected];
    if (selected && selectedColor) {
        [self hf_setBackgroundColor:selectedColor];
    } else {
        UIColor *normalColor = [self hf_backgroundColorForState:UIControlStateNormal]?: self.backgroundColor;
        [self hf_setBackgroundColor:normalColor];
    }
}

- (NSString *)keyForState:(UIControlState)state {
    return [NSString stringWithFormat:@"state_%lu", state];
}

- (NSMutableDictionary *)colors {
    NSMutableDictionary *_colors = objc_getAssociatedObject(self, @selector(colors));
    if (_colors) {
        return _colors;
    }
    
    _colors = [NSMutableDictionary dictionary];
    [self setColors:_colors];
    return _colors;
}

- (void)setColors:(NSMutableDictionary *)colors {
    objc_setAssociatedObject(self, @selector(colors), colors, OBJC_ASSOCIATION_RETAIN);
}


@end
