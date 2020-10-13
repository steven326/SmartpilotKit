//
//  SPMomentRequest.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/9.
//

#import "SPMomentRequest.h"

@implementation SPMomentRequest

- (void)requestInternetDateWithSuccessBlock:(void(^)(NSTimeInterval timeInterval))success
                               failureBlock:(void(^)(NSError *error))failure;
{
    //1.创建URL
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //2.创建request请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:5];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    //3.创建URLSession对象
    NSURLSession *session = [NSURLSession sharedSession];
    //4.设置数据返回回调的block
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil && response != nil) {
            //这么做的原因是简体中文下的手机不能识别“MMM”，只能识别“MM”
            NSArray *monthEnglishArray = @[@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sept",@"Sep",@"Oct",@"Nov",@"Dec"];
            NSArray *monthNumArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"09",@"10",@"11",@"12"];
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *allHeaderFields = [httpResponse allHeaderFields];
            NSString *dateStr = [allHeaderFields objectForKey:@"Date"];
            dateStr = [dateStr substringFromIndex:5];
            dateStr = [dateStr substringToIndex:[dateStr length]-4];
            dateStr = [dateStr stringByAppendingString:@" +0000"];
            //当前语言是中文的话，识别不了英文缩写
            for (NSInteger i = 0 ; i < monthEnglishArray.count ; i++) {
                NSString *monthEngStr = monthEnglishArray[i];
                NSString *monthNumStr = monthNumArray[i];
                dateStr = [dateStr stringByReplacingOccurrencesOfString:monthEngStr withString:monthNumStr];
            }
            NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
            [dMatter setDateFormat:@"dd MM yyyy HH:mm:ss Z"];
            NSDate *netDate = [dMatter dateFromString:dateStr];
            NSTimeInterval timeInterval = [netDate timeIntervalSince1970];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(timeInterval);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }
    }];
    //5、执行网络请求
    [task resume];
}

- (void)requestMomentsListWithQ:(NSString *)q
                     pageNumber:(int)pageNumber
                       pageSize:(int)pageSize
                       complete:(void (^)(BOOL succeed,NSArray<MomentsListModel *> *models, NSError *error))complete
{
    NSString *urlStr = [[NSString stringWithFormat:@"%@%@?q=%@&pageNumber=%d&pageSize=%d",SPHTTPSessionManager.baseUrl,@"moment/moments",q,pageNumber,pageSize] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    self.task = [self processServiceRequestGet:nil
                                    requestURL:urlStr
                                  successBlock:^(id  _Nonnull responseObject)
                 {
                     NSArray<MomentsListModel *> *models = [NSArray yy_modelArrayWithClass:MomentsListModel.class json:responseObject[@"list"]];
                     if (complete) {
                         complete(YES, models, nil);
                     }
                 } failureBlock:^(NSError * _Nonnull error) {
                     if (complete) {
                         complete(NO, nil, error);
                     }
                 }];
}

- (void)requestMomentsLikeWithMomentId:(NSString *)momentId
                              complete:(void (^)(BOOL succeed, NSArray<MomentsLikeUsersModel *> *models, NSError *error))complete
{
    NSString *urlStr = [NSString stringWithFormat:@"%@moment/moments/%@/like",SPHTTPSessionManager.baseUrl,momentId];
    self.task = [self processServiceRequestPost:@{}
                                     requestURL:urlStr
                                   successBlock:^(id  _Nonnull responseObject)
                 {
                     NSArray<MomentsLikeUsersModel *> *models = [NSArray yy_modelArrayWithClass:MomentsLikeUsersModel.class json:responseObject[@"result"][@"likes"]];
                     if (complete) {
                         complete(YES, models, nil);
                     }
                 } failureBlock:^(NSError * _Nonnull error) {
                     if (complete) {
                         complete(NO, nil, error);
                     }
                 }];
}

- (void)requestDeleteMomentWithMomentId:(NSString *)momentId
                               complete:(void (^)(BOOL succeed, NSError *error))complete
{
    NSString *urlStr = [NSString stringWithFormat:@"%@moment/moments/%@",SPHTTPSessionManager.baseUrl,momentId];
    self.task = [self processServiceRequestDelete:nil
                                       requestURL:urlStr
                                     successBlock:^(id  _Nonnull responseObject)
                 {
                     if (complete) {
                         complete(YES, nil);
                     }
                 } failureBlock:^(NSError * _Nonnull error) {
                     if (complete) {
                         complete(NO, error);
                     }
                 }];
}

- (void)requestMomentsCommontsWithMomentId:(NSString *)momentId
                                   content:(NSString *)content
                                  complete:(void (^)(BOOL succeed, NSArray<MomentsCommentsModel *> *models, NSError *error))complete
{
    NSString *urlStr = [NSString stringWithFormat:@"%@moment/moments/%@/comments",SPHTTPSessionManager.baseUrl,momentId];
    self.task = [self processServiceRequestPost:@{@"content":content}
                                     requestURL:urlStr
                                   successBlock:^(id  _Nonnull responseObject)
                 {
                     NSArray<MomentsCommentsModel *> *models = [NSArray yy_modelArrayWithClass:MomentsCommentsModel.class json:responseObject[@"list"]];
                     if (complete) {
                         complete(YES, models, nil);
                     }
                 } failureBlock:^(NSError * _Nonnull error) {
                     if (complete) {
                         complete(NO, nil, error);
                     }
                 }];
}

- (void)requestPublishMomentsWithModel:(MomentsPublishModel *)model complete:(void (^)(BOOL succeed, NSError *error))complete
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",SPHTTPSessionManager.baseUrl,@"moment/moments"];
    self.task = [self processServiceRequestPost:model.yy_modelToJSONObject
                                     requestURL:urlStr
                                   successBlock:^(id  _Nonnull responseObject)
                 {
                     if (responseObject && [responseObject[@"result"] intValue] == 1) {
                         if (complete) {
                             complete(YES, nil);
                         }
                     }
                     else {
                         if (complete) {
                             complete(NO, nil);
                         }
                     }
                 } failureBlock:^(NSError * _Nonnull error) {
                     if (complete) {
                         complete(NO, error);
                     }
                 }];
}

- (void)requestDeleteMomentsCommontWithMomentId:(NSString *)momentId
                                      commentId:(NSString *)commentId
                                       complete:(void (^)(BOOL succeed, NSError *error))complete
{
    NSString *urlStr = [NSString stringWithFormat:@"%@moment/moments/%@/comments/%@",SPHTTPSessionManager.baseUrl,momentId,commentId];
    self.task = [self processServiceRequestDelete:nil
                                       requestURL:urlStr
                                     successBlock:^(id  _Nonnull responseObject)
                 {
                     if (complete) {
                         complete(YES, nil);
                     }
                 } failureBlock:^(NSError * _Nonnull error) {
                     if (complete) {
                         complete(NO, error);
                     }
                 }];
}

@end
