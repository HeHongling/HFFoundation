//
//  HFMacro.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#ifndef HFMacro_h
#define HFMacro_h

//------------------------------App信息------------------------------
#define HFApp_Version [[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey] floatValue]
#define HFApp_Build [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] floatValue]

//------------------------------设备信息------------------------------
// 设备版本
#define HFDevice_Version [[[UIDevice currentDevice] systemVersion] floatValue]

// 真机 or 模拟器
#define HFIsSimulator TARGET_IPHONE_SIMULATOR

// 设备型号
#define HFDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define HFDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define HFDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define HFDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//------------------------------调试发布------------------------------
#define HFLog(fmt, ...) do{                                 \
NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];  \
dateFmt.dateFormat = @"hh:mm:ss.SSS";                       \
NSString *dateStr = [dateFmt stringFromDate:[NSDate date]]; \
fprintf(stderr, "%s %s  %s\n", dateStr.UTF8String, __PRETTY_FUNCTION__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);  \
}while(0)

//------------------------------常用尺寸------------------------------
#define HFScreen_Width [UIScreen mainScreen].bounds.size.width
#define HFScreen_Height [UIScreen mainScreen].bounds.size.height
#define HFScreen_Size [UIScreen mainScreen].bounds.size

#define HFPixel_Size_From_iPhone6(x) ((x)*HFScreen_Width/750)
#define HFPoint_Size_From_iPhone6(x) ((x)*HFScreen_Width/375)
#define HFLayout_Margin 8
#define HFStatusBar_Height 20
#define HFNavigationBar_Height 44
#define HFTabBar_Height 49
#define HFNavigagtionIcon_Height 20
#define HFTabBarIcon_Height 30

//------------------------------路径------------------------------
#define HFPath_Temp NSTemporaryDirectory()
#define HFPath_Documents [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define HFPath_In_Documents(fileName) [HFPath_Documents stringByAppendingPathComponent:fileName]

#define HFPath_Caches [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
#define HFPath_In_Caches(fileName) [HFPath_Caches stringByAppendingPathComponent:fileName]

#define HFPath_In_Bundle(fileName) [[NSBundle mainBundle] pathForResource:fileName ofType:nil]

//------------------------------实用功能------------------------------
#define HFWeak(type)  __weak typeof(type) weak##type = type
#define HFStrong(type)  __strong typeof(type) strong##type = weak##type

#define HFAlert_ShowTip(title, tip) do{ \
UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:title message:tip preferredStyle:UIAlertControllerStyleAlert]; \
UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]; \
[alertCtr addAction:action];                    \
[[UIViewController hf_topViewController] presentViewController:alertCtr animated:YES completion:nil]; \
}while(0)

#define HFImage_Local(name, type) [UIImage imageWithContentsOfFile:[[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:name] stringByAppendingPathExtension:type]]

#define HFColor_Random [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define HFColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HFNotificationCenter [NSNotificationCenter defaultCenter]
#define HFUserDefaults [NSUserDefaults standardUserDefaults]
#define HFKeyWindow [[UIApplication sharedApplication] keyWindow]


#endif /* HFMacro_h */
