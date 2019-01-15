//
//  HFSystemLog.h
//  HFFoundation
//
//  Created by HeHongling on 11/14/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 日志文件存放在沙盒 Document 目录下
 Info.plist文件中添加UIFileSharingEnabled键，并将键值设置为YES，可以通过 iTunes 访问此目录
 */
@interface HFSystemLog : NSObject

/**
 Redirect stderr & stdout to file Sanbox/Document/Log/yyyy-MM-dd-HHmmss.log
 */
+ (void)redirectLogToFile;

@end
