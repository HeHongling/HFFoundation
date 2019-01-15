//
//  NSString+HFFoundation.h
//  HFFoundation
//
//  Created by HeHongling on 10/9/16.
//  Copyright © 2016 HeHongling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HFFoundation)

@end


@interface NSString (HFFoundation_Regular)
- (BOOL)hf_isMobileNumber;
- (BOOL)hf_isEmail;
@end


@interface NSString (HFFoundation_PinYin)
- (instancetype)hf_pinyin;
- (instancetype)hf_initialLetter;
@end


@interface NSString (HFFoundation_MD5)
+ (NSString *)hf_MD5OfFile:(NSString *)path chunkSize:(size_t)chunk;
@end

@interface NSString (HFFoundation_Time)
+ (instancetype)hf_timeStringWithSeconds:(NSUInteger)seconds;
@end
