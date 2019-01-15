//
//  HFFileReader.m
//  HFFoundation
//
//  Created by HeHongling on 25/12/2017.
//  Copyright © 2017 HeHongling. All rights reserved.
//

#import "HFFileReader.h"

@interface NSData(Separate)
- (NSArray<NSData *> *)componentsSeparatedByData:(NSData *)separator;
-(void)enumerateComponentSeparatedByData:(NSData *)separator usingBlock:(void(NS_NOESCAPE ^)(NSData *component, BOOL isLast))block;
@end

@implementation NSData(Separate)

- (NSArray<NSData *> *)componentsSeparatedByData:(NSData *)separator {
    NSMutableArray *result = [NSMutableArray array];
    [self enumerateComponentSeparatedByData:separator
                                 usingBlock:^(NSData *component, BOOL isLast) {
                                     [result addObject:component];
                                 }];
    return [result copy];
}

- (void)enumerateComponentSeparatedByData:(NSData *)separator usingBlock:(void (^)(NSData *, BOOL))block {
    
    NSRange rangeOfSeparator = [self rangeOfData:separator options:0 range:NSMakeRange(0, self.length)];
    // whether receiver contains separator
    if (rangeOfSeparator.location == NSNotFound) {
        block(self, YES); // callBack with entire data
        return;
    }
    
    NSData *firstComponent = [self subdataWithRange:NSMakeRange(0, rangeOfSeparator.location)];
    block(firstComponent, NO);
    
    NSUInteger location = NSMaxRange(rangeOfSeparator);
    while (YES) {
        rangeOfSeparator = [self rangeOfData:separator options:0 range:NSMakeRange(location, self.length- location)];
        if (rangeOfSeparator.location == NSNotFound) {
            break;
        }
        NSData *nextComponent = [self subdataWithRange:NSMakeRange(location, rangeOfSeparator.location - location)];
        block(nextComponent, NO);
        location = NSMaxRange(rangeOfSeparator);
    }
    
    NSData *lastComponent = [self subdataWithRange:NSMakeRange(location, self.length- location)];
    block(lastComponent, YES);
}

@end


@interface HFFileReader()<NSStreamDelegate>
@property (nonatomic, strong) NSInputStream *inputStream; ///< <#desc#>
@property (nonatomic, strong) NSOperationQueue *queue; ///< <#desc#>
@property (nonatomic, strong) NSString *filePath; ///< <#desc#>
@property (nonatomic, copy) NSData *separator; ///< <#desc#>
@property (nonatomic, strong) NSMutableData *remainder; ///< <#desc#>
@property (nonatomic, assign) NSUInteger componentIndex; ///< <#desc#>
@property (nonatomic, copy) ComponentHandle componentHandle; ///< <#desc#>
@property (nonatomic, copy) CompletionBlock completionBlock; ///< <#desc#>
@property (nonatomic, assign) NSUInteger chunkSize; ///< <#desc#>
@end

@implementation HFFileReader

#pragma mark- public M

- (instancetype)init {
    NSAssert(NO, @"Use -initWithFilePath: instead!");
    return nil;
}

- (instancetype)initWithFileAtPath:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _filePath = path;
    return self;
}

- (void)enumerateComponentSeparatedByString:(NSString *)separator
                                 usingBlock:(ComponentHandle)componentHandle
                                 completion:(CompletionBlock)completionBlock {
    
    if ([separator isEqualToString:@""] || separator.length == 0) {
        self.separator = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
    } else {
        self.separator = [separator dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    self.componentHandle = componentHandle;
    self.completionBlock = completionBlock;
    
    NSData *entireData = [NSData dataWithContentsOfFile:self.filePath options:NSDataReadingMappedIfSafe error:NULL];
    /**
     注意：chunk size 不能小于当前文件 length，否则会提前退出导致异常
     */
    self.chunkSize = MIN(entireData.length, 4 * 1024);
    
    self.inputStream = [NSInputStream inputStreamWithFileAtPath:self.filePath];
    self.inputStream.delegate = self;
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
    
}

#pragma mark- NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            break;
        }
            
        case NSStreamEventErrorOccurred: {
            NSLog(@"NSStreamEventErrorOccurred");
            break;
        }
            
        case NSStreamEventHasBytesAvailable: {
            NSMutableData *buffer = [[NSMutableData alloc] initWithLength:self.chunkSize];
            NSUInteger length = (NSUInteger)[self.inputStream read:[buffer mutableBytes] maxLength:[buffer length]];
            if (length > 0) {
                [buffer setLength:length];
                __weak typeof(self) weakSelf = self;
                [self.queue addOperationWithBlock:^{
                    [weakSelf processDataChunk:buffer];
                }];
            }
            break;
        }
            
        case NSStreamEventEndEncountered: {
            self.remainder = nil;
            
            [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            [self.inputStream close];
            self.inputStream = nil;
            
            if (self.completionBlock) {
                __weak typeof (self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    strongSelf.completionBlock(self.componentIndex + 1);
                });
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark- private

- (void)processDataChunk:(NSMutableData *)buffer {
    if (self.remainder == nil) {
        self.remainder = buffer;
    } else {
        [self.remainder appendData:buffer];
    }
    
    [self.remainder enumerateComponentSeparatedByData:self.separator usingBlock:^(NSData *component, BOOL isLast) {
        if (!isLast) {
            [self processLineData:component];
        } else {
            self.remainder = [component mutableCopy];
        }
    }];
}

- (void)processLineData:(NSData *)lineData {
    if (self.componentHandle) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.componentHandle(self.componentIndex, [[NSString alloc] initWithData:lineData encoding:NSUTF8StringEncoding]);
            strongSelf.componentIndex++;
        });
    }
}

- (NSOperationQueue *)queue {
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}
@end
