//
//  NSDate+HFFoundation.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HFFoundation)

@end


@interface NSDate (HFFoundation_String)
/// 转换成 NSString
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;

/// 转换成 NSString
- (NSString *)stringWithFormat:(NSString *)format;
@end


@interface NSDate (HFFoundation_Delta)
/// 距离现在时分秒
- (NSDateComponents *)hf_deltaWithNow;

/// 是否为今天
- (BOOL)hf_isToday;

/// 是否为昨天
- (BOOL)hf_isYesterday;

/// 是否为今年
- (BOOL)hf_isThisYear;
@end
