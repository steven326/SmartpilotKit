//
//  SPMomentConfig.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/10.
//

#import "SPMomentConfig.h"

@implementation SPMomentConfig

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
        
    }
    return self;
}

- (NSString *)q
{
    if (!_q) {
        _q = @"all";
    }
    return _q;
}

@end
