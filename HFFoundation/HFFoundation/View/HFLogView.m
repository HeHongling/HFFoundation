//
//  HFLogView.m
//  HFFoundation
//
//  Created by HeHongling on 09/08/2017.
//  Copyright © 2017 HeHongling. All rights reserved.
//

#import "HFLogView.h"

@interface HFLogView ()
@property (nonatomic, strong) UITextView *outputTextView; ///< <#desc#>
@property (nonatomic, strong) NSDateFormatter *dateFmt; ///< <#desc#>
@end


@implementation HFLogView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self setupInitialConfig];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self setupInitialConfig];
    return self;
}

- (void)setupInitialConfig {
    _scrollDirection = HFLogViewAutoScrollDirectionUp;
    _dateFormatterString = @"=== HH:mm:ss.SSS ===";
    self.dateFmt.dateFormat = _dateFormatterString;
    _scrollDirection = HFLogViewAutoScrollDirectionUp;
    _showDate = YES;
    _separatorString = @"==========";
    _showSeparator = YES;
    _textColor = [UIColor blackColor];
    _textFont = [UIFont systemFontOfSize:13];
    
    [self addSubview:self.outputTextView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.outputTextView.frame = self.bounds;
}

- (void)addLogString:(NSString *)logStr {
    logStr = [self replaceUnicode:logStr];
    
    NSString *additionStr = [NSString stringWithFormat:@"%@\n\n", logStr];
    if (self.showDate) {
        additionStr = [NSString stringWithFormat:@"%@\n%@", [self.dateFmt stringFromDate:[NSDate date]], additionStr];
    }
    
    if (self.showSeparator) {
        additionStr = [additionStr stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
        additionStr = [NSString stringWithFormat:@"%@%@\n\n", additionStr, self.separatorString];
    }
    
    NSString *preLogString = self.outputTextView.text;
    if (preLogString) {
        if (self.scrollDirection == HFLogViewAutoScrollDirectionDown) {
            [self logString:[additionStr stringByAppendingString:preLogString]];
        } else {
            [self logString:[preLogString stringByAppendingString:additionStr]];
        }
    }else {
        [self logString:additionStr];
    }
}

- (void)logString:(NSString *)logStr {
    [self.outputTextView setText:logStr];
    if (self.scrollDirection == HFLogViewAutoScrollDirectionUp) {
        [self.outputTextView scrollRangeToVisible:NSMakeRange(0, logStr.length)];
    } else {
        [self.outputTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    }
}

- (void)clear {
    self.outputTextView.text = @"";
}

- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
#pragma clang diagnostic pop
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

#pragma mark- setter & getter

- (void)setDateFormatterString:(NSString *)dateFormatterString {
    _dateFormatterString = dateFormatterString;
    self.dateFmt.dateFormat = dateFormatterString;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.outputTextView.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    self.outputTextView.font = textFont;
}

- (UITextView *)outputTextView {
    if (_outputTextView == nil) {
        _outputTextView = [[UITextView alloc] init];
        _outputTextView.showsVerticalScrollIndicator = NO;
        _outputTextView.showsHorizontalScrollIndicator = NO;
        _outputTextView.editable = NO;
        _outputTextView.translatesAutoresizingMaskIntoConstraints = NO;
//        _outputTextView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _outputTextView.layoutManager.allowsNonContiguousLayout = NO;
    }
    return _outputTextView;
}

- (NSDateFormatter *)dateFmt {
    if (_dateFmt == nil) {
        _dateFmt = [[NSDateFormatter alloc] init];
    }
    return _dateFmt;
}

@end
