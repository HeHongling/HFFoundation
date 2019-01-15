//
//  NSObject+HFFoundation.m
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "NSObject+HFFoundation.h"

@implementation NSObject (HFFoundation)

- (BOOL)hf_isNull {
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]] && ([(NSString *)self length] == 0)) {
        return YES;
    }

    return NO;
}

@end
