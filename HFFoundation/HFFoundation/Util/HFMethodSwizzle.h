//
//  HFMethodSwizzle.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void hf_methodSwizzle(Class cls, SEL originalSelector, SEL swizzledSelector);
