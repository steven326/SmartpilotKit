//
//  SPHTTPSessionManager.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/9/30.
//

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPHTTPSessionManager : AFHTTPSessionManager

+ (AFHTTPSessionManager *)sharedManager;

+ (NSString *)baseUrl;
+ (NSString *)baseQiNiuUrl;

@end

NS_ASSUME_NONNULL_END
