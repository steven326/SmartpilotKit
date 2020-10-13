//
//  SPCacheUtil.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/9.
//

#import "SPCacheUtil.h"
#import "SPMomentRequest.h"
@interface SPCacheUtil ()

@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation SPCacheUtil

+ (instancetype)shared
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileManager = NSFileManager.defaultManager;
        
        @weakify(self);
        
        /// 获取服务器时间
        [SPMomentRequest.new requestInternetDateWithSuccessBlock:^(NSTimeInterval timeInterval) {
            @strongify(self);
            self.serverTimeInterval = timeInterval*1000 - NSDate.date.timeIntervalSince1970*1000;
        } failureBlock:^(NSError * _Nonnull error) {
            
        }];
    }
    return self;
}

@end
