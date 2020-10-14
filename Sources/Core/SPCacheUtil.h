//
//  SPCacheUtil.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/9.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YJEnviromentType) {
    ///生产环境
    YJEnviromentRelease = 0,
    ///测试环境
    YJEnviromentTest = 1,
    ///开发环境
    YJEnviromentDevelopment = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface SPCacheUtil : NSObject

+ (instancetype)shared;

/// 环境
@property (nonatomic, assign) YJEnviromentType enviroment;

/// 服务器时间和手机本地时间的差值（毫秒）
@property (nonatomic, assign) long serverTimeInterval;

@end

NS_ASSUME_NONNULL_END
