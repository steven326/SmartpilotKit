//
//  SPBaseRequest.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2019/8/5.
//  Copyright © 2019 smartpilot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "SPHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SPFileMimeType) {
    ///PDF类型
    SPFileMimeTypePDF = 1,
    ///PNG类型
    SPFileMimeTypePNG,
};

@interface SPBaseRequest : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSURLSessionDataTask *task;

- (void)cancel;

/// 发起POST请求
/// @param dictReqParameters 请求参数
/// @param requestURL 请求URL
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (NSURLSessionDataTask *)processServiceRequestPost:(nullable id)dictReqParameters
                                         requestURL:(NSString *)requestURL
                                       successBlock:(void (^)(id responseObject))successBlock
                                       failureBlock:(void (^)(NSError *error))failureBlock;

/// 发起GET请求
/// @param dictReqParameters 请求参数
/// @param requestURL 请求URL
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (NSURLSessionDataTask *)processServiceRequestGet:(nullable NSDictionary *)dictReqParameters
                                        requestURL:(NSString *)requestURL
                                      successBlock:(void (^)(id responseObject))successBlock
                                      failureBlock:(void (^)(NSError *error))failureBlock;

/// 发起PUT请求
/// @param dictReqParameters 请求参数
/// @param requestURL 请求URL
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (NSURLSessionDataTask *)processServiceRequestPut:(nullable id )dictReqParameters
                                        requestURL:(NSString *)requestURL
                                      successBlock:(void (^)(id responseObject))successBlock
                                      failureBlock:(void (^)(NSError *error))failureBlock;

/// 发起DELETE请求
/// @param dictReqParameters 请求参数
/// @param requestURL 请求URL
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (NSURLSessionDataTask *)processServiceRequestDelete:(nullable id)dictReqParameters
                                           requestURL:(NSString *)requestURL
                                         successBlock:(void (^)(id responseObject))successBlock
                                         failureBlock:(void (^)(NSError *error))failureBlock;

/// 上传文件
/// @param dictReqParameters 请求参数
/// @param requestURL 请求URL
/// @param fileName 文件名
/// @param mimeType 文件类型
/// @param data 需要上传的二进制文件
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (NSURLSessionDataTask *)processServiceRequestUpload:(nullable NSDictionary *)dictReqParameters
                                           requestURL:(NSString *)requestURL
                                             fileName:(NSString *)fileName
                                             mimeType:(SPFileMimeType)mimeType
                                                 data:(NSData *)data
                                         successBlock:(void (^)(id responseObject))successBlock
                                         failureBlock:(void (^)(NSError *error))failureBlock;

/// 下载文件
/// @param downloadURL 文件服务器地址
/// @param progressBlock 下载进度回调
/// @param successBlock 文件存储地址
/// @param failureBlock 失败回调
- (NSURLSessionDownloadTask *)processServiceRequestDownload:(NSString *)downloadURL
                                              progressBlock:(void (^)(float downloadProgress))progressBlock
                                               successBlock:(void (^)(NSURL *targetPath))successBlock
                                               failureBlock:(void (^)(NSError *error))failureBlock;

/// 根据url获取文件大小
/// @param fileURL 文件地址
/// @param finishBlock 完成回调
- (void)processServiceRequestFileSizeWithFileUrl:(NSString *)fileURL
                                     finishBlock:(void(^)(NSString *size))finishBlock;

@end

NS_ASSUME_NONNULL_END
