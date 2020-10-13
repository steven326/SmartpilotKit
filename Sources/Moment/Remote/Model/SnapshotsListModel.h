//
//  SnapshotsListModel.h
//  YangJiang
//
//  Created by 王泽平 on 2019/9/27.
//  Copyright © 2019 smartpilot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MomentsListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SnapshotsListModel : NSObject

///港航圈发布时定位地点
@property (nonatomic, strong) NSString *address;
///随手拍发布时定位城市
@property (nonatomic, strong) NSString *area;
///港航圈文字内容
@property (nonatomic, strong) NSString *content;
///随手拍发布时定位纬度
@property (nonatomic, assign) int latitude;
///随手拍发布时定位经度
@property (nonatomic, assign) int longitude;
///随手拍ID，唯一键
@property (nonatomic, strong) NSString *snapshot_id;
///港航圈图片内容，最多9张图片。图片链接地址，上传到七牛
@property (nonatomic, strong) NSArray<MomentsPicturesModel *> *pictures;
///港航圈发布时间
@property (nonatomic, strong) NSString *time;
///发布用户ID
@property (nonatomic, strong) NSString *user_id;
///发布用户名称
@property (nonatomic, strong) NSString *user_name;
///发布用户头像
@property (nonatomic, strong) NSString *user_photo;
///发布用户角色
@property (nonatomic, strong) NSString *user_role;
///发布用户所在地区
@property (nonatomic, strong) NSString *user_site;
///视频
@property (nonatomic, strong) NSString *vedio;
/// 格式化后的时间
@property (nonatomic, strong) NSString *format_time;

@property (nonatomic, assign) BOOL isOpening;
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;

@end

NS_ASSUME_NONNULL_END
