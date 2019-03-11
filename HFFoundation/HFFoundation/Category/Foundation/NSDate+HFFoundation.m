//
//  NSDate+HFFoundation.m
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "NSDate+HFFoundation.h"
#import <Objc/runtime.h>


@implementation NSDate (HFFoundation_String)

- (NSString *)hf_stringWithFormat:(NSString *)format {
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateFormat = format;
    return [fmt stringFromDate:self];
}

- (NSString *)hf_description {
    NSString *fmt;
    if (self.hf_isToday) {
        fmt = self.hf_thisDayFormat;
    } else if (self.hf_isThisYear) {
        fmt = self.hf_thisYearFormat;
    } else {
        fmt = self.hf_defaultFormat;
    }
    return [self hf_stringWithFormat:fmt];
}

- (NSString *)hf_defaultFormat {
    NSString *format = objc_getAssociatedObject(self, @selector(hf_defaultFormat));
    if (!format.length) {
        format = @"YYYY-MM-dd HH:mm:ss";
        self.hf_defaultFormat = format;
    }
    return format;
}

- (void)setHf_defaultFormat:(NSString *)hf_defaultFormat {
    objc_setAssociatedObject(self, @selector(hf_defaultFormat), hf_defaultFormat, OBJC_ASSOCIATION_COPY);
}

- (NSString *)hf_thisYearFormat {
    NSString *format = objc_getAssociatedObject(self, @selector(hf_thisYearFormat));
    if (!format.length) {
        format = @"MM-dd HH:mm:ss";
        self.hf_defaultFormat = format;
    }
    return format;
}

- (void)setHf_thisYearFormat:(NSString *)hf_thisYearFormat {
    objc_setAssociatedObject(self, @selector(hf_thisYearFormat), hf_thisYearFormat, OBJC_ASSOCIATION_COPY);
}

- (NSString *)hf_thisDayFormat {
    NSString *format = objc_getAssociatedObject(self, @selector(hf_thisDayFormat));
    if (!format.length) {
        format = @"HH:mm:ss.SSS";
        self.hf_defaultFormat = format;
    }
    return format;
}

- (void)setHf_thisDayFormat:(NSString *)hf_thisDayFormat {
    objc_setAssociatedObject(self, @selector(hf_thisDayFormat), hf_thisDayFormat, OBJC_ASSOCIATION_COPY);
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
