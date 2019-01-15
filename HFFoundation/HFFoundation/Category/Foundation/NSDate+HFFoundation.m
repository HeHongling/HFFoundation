//
//  NSDate+HFFoundation.m
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "NSDate+HFFoundation.h"

@implementation NSDate (HFFoundation)

@end


@implementation NSDate (HFFoundation_String)
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format {
    return [date stringWithFormat:format];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = format;
    [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    return [fmt stringFromDate:self];
}

@end


@implementation NSDate (HFFoundation_Delta)
- (NSDateComponents *)hf_deltaWithNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

- (BOOL)hf_isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *nowComponents = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    
    return (
            (nowComponents.year == selfComponents.year) &&
            (nowComponents.month == selfComponents.month) &&
            (nowComponents.day == selfComponents.day) );
    
}

- (BOOL)hf_isYesterday {
    NSDate *nowDate = [[NSDate date] hf_dateWithYMD];
    NSDate *selfDate = [self hf_dateWithYMD];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return components.day == 1;
}

- (BOOL)hf_isThisYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    
    NSDateComponents *nowComponents = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [calendar components:unit fromDate:self];
    
    return nowComponents.year == selfComponents.year;
}

- (NSDate *)hf_dateWithYMD {
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

@end
