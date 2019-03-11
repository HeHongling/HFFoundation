//
//  NSDate+HFFoundation.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (HFFoundation_String)
@property (nonatomic, copy) NSString *hf_defaultFormat;
@property (nonatomic, copy) NSString *hf_thisYearFormat;
@property (nonatomic, copy) NSString *hf_thisDayFormat;

/// 转换成 NSString
- (NSString *)hf_description;

/// 转换成 NSString
- (NSString *)hf_stringWithFormat:(NSString *)format;
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
