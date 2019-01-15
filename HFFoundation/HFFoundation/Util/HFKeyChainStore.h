//
//  HFKeyChainStore.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <Foundation/Foundation.h>

//------------------------------
// Target - Capabilities - Keychain Sharing -> ON
// 打开之后左侧的文件目录自动生成Entitlements文件
//------------------------------

@interface HFKeyChainStore : NSObject
/**
 *  存储数据
 *
 *  @param service key
 *  @param data    value
 */
+ (void)hf_save:(NSString *)service data:(id)data;

/**
 *  读取数据
 *
 *  @param service key
 *
 *  @return value
 */
+ (id)hf_load:(NSString *)service;

/**
 *  删除数据
 *
 *  @param service key
 */
+ (void)hf_deleteKeyData:(NSString *)service;

@end
