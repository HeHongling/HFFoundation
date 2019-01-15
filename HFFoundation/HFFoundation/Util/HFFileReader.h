//
//  HFFileReader.h
//  HFFoundation
//
//  Created by HeHongling on 25/12/2017.
//  Copyright © 2017 HeHongling. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ComponentHandle) (NSUInteger idx, NSString *content);
typedef void(^CompletionBlock) (NSUInteger numberOfLines);

@interface HFFileReader : NSObject

/**
 Initializer

 @param path File path to read
 @return instance
 */
- (instancetype)initWithFileAtPath:(NSString *)path;


/**
 遍历文件的每一行

 @param separator 分隔符
 @param componentHandle 每一行回调
 @param completionBlock 完成回调
 */
- (void)enumerateComponentSeparatedByString:(NSString *)separator
                                 usingBlock:(ComponentHandle)componentHandle
                                 completion:(CompletionBlock)completionBlock;
@end
