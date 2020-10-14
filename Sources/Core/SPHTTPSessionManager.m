//
//  SPHTTPSessionManager.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/9/30.
//

#import "SPHTTPSessionManager.h"
#import "UIDevice+IdentifierAddition.h"
#import "SPCacheUtil.h"
@implementation SPHTTPSessionManager

+ (AFHTTPSessionManager *)sharedManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        manager = [AFHTTPSessionManager manager];
        
        // 上传JSON格式
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        [manager.requestSerializer setValue:[YJUserInstance shareInstance].userToken forHTTPHeaderField:@"x-token"];
        [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"x-channel"];
        [manager.requestSerializer setValue:NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] forHTTPHeaderField:@"x-version"];
        NSString *uniqueDeviceIdentifier = UIDevice.currentDevice.uniqueDeviceIdentifier;
        if (uniqueDeviceIdentifier.length > 15) {
            uniqueDeviceIdentifier = [uniqueDeviceIdentifier substringToIndex:15];
        }
        [manager.requestSerializer setValue:uniqueDeviceIdentifier forHTTPHeaderField:@"x-imei"];
        
        // 声明获取到的数据格式
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html,text/plain", nil];
        
        /*
        // HTTPS私人创建证书
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
         */
    });
    return manager;
}

+ (NSString *)baseUrl
{
    switch (SPCacheUtil.shared.enviroment) {
        case YJEnviromentDevelopment:
        {
            return @"http://dev.apitest.smartpilot.cn/app/";
        }
            break;
        case YJEnviromentTest:
        {
            return @"http://yangjiang.apitest.smartpilot.cn/app/";
        }
            break;
        case YJEnviromentRelease:
        {
            return @"http://yangjiang.api.smartpilot.cn/app/";
        }
            break;
        default:
        {
            return @"http://yangjiang.apitest.smartpilot.cn/app/";
        }
            break;
    }
}

+ (NSString *)baseQiNiuUrl
{
    return @"http://qiniu.smartpilot.cn/";
}
@end
