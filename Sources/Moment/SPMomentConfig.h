//
//  SPMomentConfig.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/10.
//

#import <Foundation/Foundation.h>

@class SPMomentListViewController;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SPMomentOperateType) {
    ///点击用户
    SPMomentOperateTypeTapUser = 1,
    ///评论
    SPMomentOperateTypeComment,
    ///点赞
    SPMomentOperateTypeLike,
    ///举报
    SPMomentOperateTypeFeedback
};

@protocol SPMomentDataSource <NSObject>

- (BOOL)operationIsValidatedWithType:(SPMomentOperateType)type viewController:(SPMomentListViewController *)viewController;

@end

@protocol SPMomentDelegate <NSObject>

/// 点击用户详情回调
/// @param userId 用户id
/// @param viewController 当前控制器
- (void)didClickUser:(NSString *)userId inViewController:(SPMomentListViewController *)viewController;

/// 点击举报按钮回调
/// @param momentId 圈子id
/// @param viewController 当前控制器
- (void)didClickFeedbackOfMoment:(NSString *)momentId inViewController:(SPMomentListViewController *)viewController;

@end


@interface SPMomentConfig : NSObject

+ (instancetype)shared;

/// 当前登录用户id
@property (nonatomic, strong) NSString *userId;
/// 当前登录用户真实姓名
@property (nonatomic, strong) NSString *realName;
/// 接口请求参数
@property (nonatomic, strong) NSString *q;
/// 是否开启下拉刷新
@property (nonatomic, assign) BOOL enableRefreshHeader;
/// 删除每条圈子权限
@property (nonatomic, assign) BOOL hasDeletePostPrivilage;

@end

NS_ASSUME_NONNULL_END
