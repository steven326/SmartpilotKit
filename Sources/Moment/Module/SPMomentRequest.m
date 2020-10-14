//
//  SPMomentRequest.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/9.
//

#import "SPMomentRequest.h"
#import "YYModel.h"

@implementation SPMomentRequest

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
