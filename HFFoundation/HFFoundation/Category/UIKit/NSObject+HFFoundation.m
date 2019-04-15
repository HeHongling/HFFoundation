//
//  NSObject+HFFoundation.m
//  HFFoundation
//
//  Created by HeHongling on 2019/4/15.
//  Copyright © 2019 HeHongling. All rights reserved.
//

#import "NSObject+HFFoundation.h"

NSString *hf_callStackString(void) {
    NSArray *callStack = [NSThread callStackSymbols];
    if(callStack.count < 2) {
        return nil;
    }
    
    NSDictionary *(^extractStackInfo)(NSString *) = ^NSDictionary *(NSString *stackSource) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        NSString *frameworkPattern = @"[_a-zA-Z][_a-zA-Z0-9]*(?=\\s*0x[\\da-f]+)";
        NSRange frameworkRange = [stackSource rangeOfString:frameworkPattern options:NSRegularExpressionSearch];
        if (frameworkRange.location != NSNotFound) {
            [dict setValue:[stackSource substringWithRange:frameworkRange] forKey:@"framework"];
        }
        
        NSString *addressPattern = @"0x[\\da-f]+\\s";
        NSRange addressRange = [stackSource rangeOfString:addressPattern options:NSRegularExpressionSearch];
        if (addressRange.location != NSNotFound) {
            NSString *tmpStr = [stackSource substringFromIndex:addressRange.location + addressRange.length];
            NSString *functionPattern = @".*(?=\\s\\+\\s\\d+)";
            NSRange functionRange = [tmpStr rangeOfString:functionPattern options:NSRegularExpressionSearch];
            if (functionRange.location != NSNotFound) {
                [dict setValue:[tmpStr substringWithRange:functionRange] forKey:@"function"];
            }
            
        }
        return [dict copy];
    };
    
    NSDictionary *firstStackInfo = extractStackInfo(callStack[1]);
    NSString *firstFramework = firstStackInfo[@"framework"];
    
    NSMutableString *stackString = [@"\n" mutableCopy];
    int spaceCount = 0;
    BOOL isFirstCustomStack = YES;
    for (long i = callStack.count-2; i >0; i--) {
        NSDictionary *curStackInfo = extractStackInfo(callStack[i]);
        if (![curStackInfo[@"framework"] isEqualToString:firstFramework] ||
            [curStackInfo[@"function"] isEqualToString:@"main"]) {
            continue;
        }
        NSString *spaceStr = [@"" stringByPaddingToLength:spaceCount++ withString:@" " startingAtIndex:0];
        NSString *flagStr = isFirstCustomStack? @"From:": @"    └";
        [stackString appendFormat:@"|%@ %@ %@\n", spaceStr, flagStr, curStackInfo[@"function"]];
        if (isFirstCustomStack) {
            isFirstCustomStack = NO;
        }
    }
    return [stackString copy];
}

@implementation NSObject (HFFoundation)

@end
