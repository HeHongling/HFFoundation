//
//  HFLogView.h
//  HFFoundation
//
//  Created by HeHongling on 09/08/2017.
//  Copyright © 2017 HeHongling. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HFLogViewAutoScrollDirection) {
    HFLogViewAutoScrollDirectionDown = 0, // 默认向下滚动，即最新内容在最上方
    HFLogViewAutoScrollDirectionUp   = 1,
};


@interface HFLogView : UIView
@property (nonatomic, assign) HFLogViewAutoScrollDirection scrollDirection; ///< 滚动方向

@property (nonatomic, copy) NSString *dateFormatterString; ///< 日期时间格式，默认 @"HH:mm:ss.SSS"
@property (nonatomic, assign) BOOL showDate; ///< 是否显示时间

@property (nonatomic, copy) NSString *separatorString; ///< 分割线字符串，默认 @"----------"
@property (nonatomic, assign) BOOL showSeparator; ///< 显示分隔符

@property (nonatomic, strong) IBInspectable UIColor *textColor; ///< 默认 blackColor
@property (nonatomic, strong) IBInspectable UIFont *textFont; ///< 默认 13 号系统字体


/// 打印字符串
- (void)logString:(NSString *)logStr;

/// 添加打印内容
- (void)addLogString:(NSString *)logStr;

/// 清除
- (void)clear;
@end
