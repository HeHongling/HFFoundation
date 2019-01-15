//
//  NSArray+HFFoundation.m
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "NSArray+HFFoundation.h"

@implementation NSArray (HFFoundation)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"(\n"];
    
    for (id obj in self) {
        [strM appendFormat:@"\t%@,\n", obj];
    }
    [strM appendString:@")"];
    
    return strM;
}

@end


@implementation NSMutableArray (HFFoundation)

@end


@implementation NSMutableArray (HFFoundation_Sort)
- (void)hf_moveObjectAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex {
    if (sourceIndex == destinationIndex) {
        return;
    }
    
    id obj = [self objectAtIndex:sourceIndex];
    [self removeObject:obj];
    [self insertObject:obj atIndex:destinationIndex];
}

@end
