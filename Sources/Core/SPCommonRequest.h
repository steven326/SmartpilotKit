//
//  SPCommonRequest.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/14.
//

#import "SPBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPCommonRequest : SPBaseRequest

/// 获取服务器时间戳
/// @param success 成功回调
/// @param failure 失败回调
- (void)requestInternetDateWithSuccessBlock:(void(^)(NSTimeInterval timeInterval))success
                               failureBlock:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
