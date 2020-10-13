//
//  SPMomentRequest.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/9.
//

#import "SPBaseRequest.h"
#import "MomentsListModel.h"
#import "MomentsPublishModel.h"
#import "SnapshotsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPMomentRequest : SPBaseRequest

/// 获取服务器时间戳
/// @param success 成功回调
/// @param failure 失败回调
- (void)requestInternetDateWithSuccessBlock:(void(^)(NSTimeInterval timeInterval))success
                               failureBlock:(void(^)(NSError *error))failure;

/// 港航圈列表
/// @param q 港航圈分类，all：所有，my：我的,其它为城市名
/// @param pageNumber 页数，默认1表示第一页
/// @param pageSize 每页个数，默认10
/// @param complete 回调
- (void)requestMomentsListWithQ:(NSString *)q
                     pageNumber:(int)pageNumber
                       pageSize:(int)pageSize
                       complete:(void (^)(BOOL succeed,NSArray<MomentsListModel *> *models, NSError *error))complete;

/// 港航圈点赞
/// @param momentId 港航圈ID
/// @param complete 回调
- (void)requestMomentsLikeWithMomentId:(NSString *)momentId
                              complete:(void (^)(BOOL succeed, NSArray<MomentsLikeUsersModel *> *models, NSError *error))complete;

/// 删除港航圈
/// @param momentId 港航圈ID
/// @param complete 回调
- (void)requestDeleteMomentWithMomentId:(NSString *)momentId
                               complete:(void (^)(BOOL succeed, NSError *error))complete;

/// 港航圈评论
/// @param momentId 港航圈ID
/// @param content 评论内容
/// @param complete 回调
- (void)requestMomentsCommontsWithMomentId:(NSString *)momentId
                                   content:(NSString *)content
                                  complete:(void (^)(BOOL succeed, NSArray<MomentsCommentsModel *> *models, NSError *error))complete;

/// 发布港航圈
/// @param model 发布模型
/// @param complete 回调
- (void)requestPublishMomentsWithModel:(MomentsPublishModel *)model
                              complete:(void (^)(BOOL succeed, NSError *error))complete;

/// 删除港航圈评论
/// @param momentId 港航圈id
/// @param commentId 评论id
/// @param complete 回调
- (void)requestDeleteMomentsCommontWithMomentId:(NSString *)momentId
                                      commentId:(NSString *)commentId
                                       complete:(void (^)(BOOL succeed, NSError *error))complete;

@end

NS_ASSUME_NONNULL_END
