//
//  SPBaseRequest.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2019/8/5.
//  Copyright © 2019 smartpilot. All rights reserved.
//

#import "SPBaseRequest.h"
#import "UIDevice+IdentifierAddition.h"
#import "AESCipher.h"
#import "SmartpilotKit.h"
#import "YYCategories.h"

@implementation SPBaseRequest

- (void)cancel
{
    if (self.task) {
        [self.task cancel];
    }
}

- (NSURLSessionDataTask *)processServiceRequestPost:(nullable id)dictReqParameters
                                         requestURL:(NSString *)requestURL
                                       successBlock:(void (^)(id responseObject))successBlock
                                       failureBlock:(void (^)(NSError *error))failureBlock
{
    /// 动态添加请求头
    [self appendRequestHeaderWithRequestUrl:requestURL];
    NSURLSessionDataTask *task = [self.manager POST:requestURL parameters:dictReqParameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"AF Net succ block for \n URL: %@ \n Parameters: %@", requestURL, dictReqParameters);
        NSLog(@"Response Dictionary [%@]",responseObject);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 207) {
            NSError *bError = [NSError errorWithDomain:@"businessError" code:207 userInfo:@{}];
            failureBlock(bError);
        }
        else {
            successBlock(responseObject);
            if ([responseObject isKindOfClass:NSDictionary.class]) {
                if (responseObject && responseObject[@"error"] && responseObject[@"error"][@"message"]) {
                    if (![responseObject[@"error"][@"message"] isKindOfClass:NSNull.class]
                        && [responseObject[@"error"][@"message"] isNotBlank]) {
                        [SPUtils showToastWithMessage:responseObject[@"error"][@"message"]];
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"AF Net fail block - error[%@]",[error localizedDescription]);
        NSLog(@"requestURL : %@ \n Parameters: %@", requestURL,dictReqParameters);
        NSDictionary *dict = [self errorMessageDictWithError:error];
        if (dict)
        {
            NSLog(@"AF Error = %@", dict);
            failureBlock(error);
        }
        else
        {
            failureBlock(error);
        }
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode != 404) {
            [SPUtils showToastWithStatusCode:(long)response.statusCode];
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)processServiceRequestGet:(NSDictionary *)dictReqParameters
                                        requestURL:(NSString *)requestURL
                                      successBlock:(void (^)(id responseObject))successBlock
                                      failureBlock:(void (^)(NSError *error))failureBlock
{
    /// 动态添加请求头
    [self appendRequestHeaderWithRequestUrl:requestURL];
    NSURLSessionDataTask *task = [self.manager GET:requestURL
                                        parameters:dictReqParameters
                                           headers:nil
                                          progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"AF Net succ block for \n URL: %@ \n Parameters: %@", requestURL, dictReqParameters);
        NSLog(@"Response Dictionary [%@]",responseObject);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 207) {
            NSError *bError = [NSError errorWithDomain:@"businessError" code:207 userInfo:@{}];
            failureBlock(bError);
        }
        else {
            if ([responseObject isKindOfClass:NSDictionary.class]) {
                if (responseObject && responseObject[@"error"] && responseObject[@"error"][@"message"]) {
                    if (![responseObject[@"error"][@"message"] isKindOfClass:NSNull.class]
                        && [responseObject[@"error"][@"message"] isNotBlank]) {
                        [SPUtils showToastWithMessage:responseObject[@"error"][@"message"]];
                        NSError *bError = [NSError errorWithDomain:@"businessError" code:[responseObject[@"error"][@"code"] intValue] userInfo:@{}];
                        failureBlock(bError);
                        return;
                    }
                }
            }
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"AF Net fail block - error[%@]",[error localizedDescription]);
        NSLog(@"requestURL : %@ \n Parameters: %@", requestURL,dictReqParameters);
        NSDictionary *dict = [self errorMessageDictWithError:error];
        if (dict) {
            NSLog(@"AF Error = %@", dict);
            failureBlock(error);
        }
        else {
            failureBlock(error);
        }
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode != 404) {
            [SPUtils showToastWithStatusCode:(long)response.statusCode];
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)processServiceRequestPut:(nullable id)dictReqParameters
                                        requestURL:(NSString *)requestURL
                                      successBlock:(void (^)(id responseObject))successBlock
                                      failureBlock:(void (^)(NSError *error))failureBlock
{
    /// 动态添加请求头
    [self appendRequestHeaderWithRequestUrl:requestURL];
    NSURLSessionDataTask *task = [self.manager PUT:requestURL
                                        parameters:dictReqParameters
                                           headers:nil
                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"AF Net succ block for \n URL: %@ \n Parameters: %@", requestURL, dictReqParameters);
        NSLog(@"Response Dictionary [%@]",responseObject);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 207) {
            NSError *bError = [NSError errorWithDomain:@"businessError" code:207 userInfo:@{}];
            failureBlock(bError);
        }
        else {
            if (responseObject && responseObject[@"error"] && responseObject[@"error"][@"message"]) {
                if (![responseObject[@"error"][@"message"] isKindOfClass:NSNull.class]
                    && [responseObject[@"error"][@"message"] isNotBlank]) {
                    [SPUtils showToastWithMessage:responseObject[@"error"][@"message"]];
                    NSError *bError = [NSError errorWithDomain:@"businessError" code:[responseObject[@"error"][@"code"] intValue] userInfo:@{}];
                    failureBlock(bError);
                    return;
                }
            }
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"AF Net fail block - error[%@]",[error localizedDescription]);
        NSLog(@"requestURL : %@ \n Parameters: %@", requestURL,dictReqParameters);
        NSDictionary *dict = [self errorMessageDictWithError:error];
        if (dict) {
            NSLog(@"AF Error = %@", dict);
            NSError *bError = [NSError errorWithDomain:@"businessError" code:10000 userInfo:dict];
            failureBlock(bError);
        }
        else {
            failureBlock(error);
        }
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode != 404) {
            [SPUtils showToastWithStatusCode:(long)response.statusCode];
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)processServiceRequestDelete:(nullable id )dictReqParameters
                                           requestURL:(NSString *)requestURL
                                         successBlock:(void (^)(id responseObject))successBlock
                                         failureBlock:(void (^)(NSError *error))failureBlock
{
    /// 动态添加请求头
    [self appendRequestHeaderWithRequestUrl:requestURL];
    NSURLSessionDataTask *task = [self.manager DELETE:requestURL
                                           parameters:dictReqParameters
                                              headers:nil
                                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"AF Net succ block for \n URL: %@ \n Parameters: %@", requestURL, dictReqParameters);
        NSLog(@"Response Dictionary [%@]",responseObject);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 207) {
            NSError *bError = [NSError errorWithDomain:@"businessError" code:207 userInfo:@{}];
            failureBlock(bError);
        }
        else {
            if (responseObject && responseObject[@"error"] && responseObject[@"error"][@"message"]) {
                if (![responseObject[@"error"][@"message"] isKindOfClass:NSNull.class]
                    && [responseObject[@"error"][@"message"] isNotBlank]) {
                    [SPUtils showToastWithMessage:responseObject[@"error"][@"message"]];
                    NSError *bError = [NSError errorWithDomain:@"businessError" code:[responseObject[@"error"][@"code"] intValue] userInfo:@{}];
                    failureBlock(bError);
                    return;
                }
            }
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"AF Net fail block - error[%@]",[error localizedDescription]);
        NSLog(@"requestURL : %@ \n Parameters: %@", requestURL,dictReqParameters);
        NSDictionary *dict = [self errorMessageDictWithError:error];
        if (dict) {
            NSLog(@"AF Error = %@", dict);
            NSError *bError = [NSError errorWithDomain:@"businessError" code:10000 userInfo:dict];
            failureBlock(bError);
        }
        else {
            failureBlock(error);
        }
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode != 404) {
            [SPUtils showToastWithStatusCode:(long)response.statusCode];
        }
    }];
    return task;

}

- (NSURLSessionDataTask *)processServiceRequestUpload:(nullable NSDictionary *)dictReqParameters
                                           requestURL:(NSString *)requestURL
                                             fileName:(NSString *)fileName
                                             mimeType:(SPFileMimeType)mimeType
                                                 data:(NSData *)data
                                         successBlock:(void (^)(id responseObject))successBlock
                                         failureBlock:(void (^)(NSError *error))failureBlock
{
    NSURLSessionDataTask *task = [self.manager POST:requestURL parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *mimeTypeStr = @"image/png";
        if (mimeType == SPFileMimeTypePDF) {
            mimeTypeStr = @"application/pdf";
        }
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeTypeStr];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度 %f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) { 
        NSLog(@"上传成功 %@", responseObject);
        NSLog(@"AF Net succ block for \n URL: %@ \n Parameters: %@", requestURL, dictReqParameters);
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@", error);
        NSLog(@"AF Net fail block - error[%@]",[error localizedDescription]);
        failureBlock(error);
    }];
    return task;
}

- (NSURLSessionDownloadTask *)processServiceRequestDownload:(NSString *)downloadURL
                                              progressBlock:(void (^)(float downloadProgress))progressBlock
                                               successBlock:(void (^)(NSURL *targetPath))successBlock
                                               failureBlock:(void (^)(NSError *error))failureBlock
{
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadURL]];
    NSURLSessionDownloadTask *downloadTask = [manage downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度 %f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        if (downloadProgress) {
            progressBlock(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *legalFilename = [SPUtils legalFileNameWithName:response.suggestedFilename path:PATH_CACHE];
        NSString *fullpath = [PATH_CACHE stringByAppendingPathComponent:legalFilename];
        NSURL *filePathUrl = [NSURL fileURLWithPath:fullpath];
        return filePathUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        if (error) {
            failureBlock(error);
            NSLog(@"下载失败 AF Net Fail Block - error[%@]",[error localizedDescription]);
        }
        if (filePath) {
            successBlock(filePath);
            NSLog(@"下载成功 AF Net Succ Block：%@", filePath);
        }
    }];
    [downloadTask resume];
    return downloadTask;
}

- (void)processServiceRequestFileSizeWithFileUrl:(NSString *)fileURL
                                     finishBlock:(void(^)(NSString *size))finishBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:fileURL parameters:@{} headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CGFloat length = [[[(NSHTTPURLResponse *)task.response allHeaderFields] objectForKey:@"Content-Length"] floatValue];
        NSString *size;
        if (length >= 1048576) {
            size = [NSString stringWithFormat:@"%.2fM",length/1024/1024];
        }
        else {
            size = [NSString stringWithFormat:@"%.1fKB",length/1024];
        }
        finishBlock(size);
    }];
}

- (void)appendRequestHeaderWithRequestUrl:(NSString *)requestUrl
{
    /// AES加密时间戳
    NSString *aes_timestamp = aesEncryptString(@((long)(NSDate.date.timeIntervalSince1970*1000+SPCacheUtil.shared.serverTimeInterval)).stringValue, AES_KEY);
    [self.manager.requestSerializer setValue:aes_timestamp forHTTPHeaderField:@"x-timestamp"];
    /// 请求id ( {请求url}_{设备唯一标识}_{当前时间秒} )
    NSMutableString *requestId = @"".mutableCopy;
    [requestId appendString:requestUrl];
    [requestId appendString:@"_"];
    [requestId appendString:UIDevice.currentDevice.uniqueDeviceIdentifier];
    [requestId appendString:@"_"];
    [requestId appendString:@((long)(NSDate.date.timeIntervalSince1970)).stringValue];
    [self.manager.requestSerializer setValue:requestId forHTTPHeaderField:@"x-request-id"];
}

- (NSDictionary *)errorMessageDictWithError:(NSError *)error
{
    NSDictionary *dict = nil;
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (errorData) {
        dict = [NSJSONSerialization JSONObjectWithData:errorData options:0 error:nil];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            dict = nil;
        }
    }
    return dict;
}

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [SPHTTPSessionManager sharedManager];
    }
    return _manager;
}

@end
