//
//  HFSystemLog.m
//  HFFoundation
//
//  Created by HeHongling on 11/14/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import "HFSystemLog.h"
#import "NSDate+HFFoundation.h"

@implementation HFSystemLog

//static int originH1;
//+ (void)initialize {
//    if (self == [HFSystemLog self]) {
//        originH1 = dup(STDERR_FILENO);
//    }
//}
//
//+ (void)restore {
//    dup2(originH1, STDERR_FILENO);
//}


+ (void)redirectLogToFile {
    if(isatty(STDOUT_FILENO)) { // 已经连接 Xcode 调试
        return;
    }
    
    NSString *logDirectory = [self directoryInDocumentWithName:@"Log"];
    NSString *dateStr = [[NSDate date] hf_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *logFile = [logDirectory stringByAppendingFormat:@"/%@.log", dateStr];

    // 输出到文件
    freopen([logFile cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFile cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

+ (NSString *)directoryInDocumentWithName:(NSString *)directoryName {
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = [[searchPath objectAtIndex:0] stringByAppendingPathComponent:directoryName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:directoryPath];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:directoryPath  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directoryPath;
}


@end
