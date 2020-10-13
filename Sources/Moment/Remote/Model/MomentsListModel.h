//
//  MomentsListModel.h
//  YangJiang
//
//  Created by 王泽平 on 2019/9/5.
//  Copyright © 2019 smartpilot. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MomentsPicturesModel : NSObject

///图片高度
@property (nonatomic, assign) double height;
///资源url
@property (nonatomic, strong) NSString *photo;
///资源缩略图
@property (nonatomic, strong) NSString *thumb;
///资源类型：1，图片；2，视频MP4
@property (nonatomic, assign) int type;
///图片宽度
@property (nonatomic, assign) double width;

@end


@interface MomentsLikeUsersModel : NSObject

///点赞时间
@property (nonatomic, strong) NSString *time;
///点赞用户名称
@property (nonatomic, strong) NSString *use_name;
///点赞用户头像
@property (nonatomic, strong) NSString *use_photo;
///点赞用户ID
@property (nonatomic, strong) NSString *user_id;
///点赞富文本内容
@property (nonatomic, strong) NSAttributedString *attributedContent;

@end


@interface MomentsCommentsModel : NSObject

///评论内容
@property (nonatomic, strong) NSString *comment;
///评论ID，唯一键
@property (nonatomic, strong) NSString *comment_id;
///评论时间
@property (nonatomic, strong) NSString *time;
///评论用户名称
@property (nonatomic, strong) NSString *use_name;
///评论用户头像
@property (nonatomic, strong) NSString *use_photo;
///评论用户ID
@property (nonatomic, strong) NSString *user_id;
///评论富文本内容
@property (nonatomic, strong) NSAttributedString *attributedContent;

@end


@interface MomentsListModel : NSObject

///港航圈发布时定位地点
@property (nonatomic, strong) NSString *address;
///港航圈评论列表
@property (nonatomic, strong) NSArray<MomentsCommentsModel *> *comments;
///港航圈文字内容
@property (nonatomic, strong) NSString *content;
///港航圈点赞数量
@property (nonatomic, assign) int follows;
///当前用户是否点赞：true，已点赞
@property (nonatomic, assign) int is_like;
///随手拍发布时定位纬度
@property (nonatomic, assign) double latitude;
///港航圈点赞列表
@property (nonatomic, strong) NSArray<MomentsLikeUsersModel *> *like_users;
///港航圈点赞数量
@property (nonatomic, assign) int likes;
///随手拍发布时定位经度
@property (nonatomic, assign) double longitude;
///港航圈ID，唯一键
@property (nonatomic, strong) NSString *moment_id;
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
///格式化的时间
@property (nonatomic, strong) NSString *format_time;
///是否展示全文
@property (nonatomic, assign) BOOL isOpening;
///是否展示‘收起展开’按钮
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
///内容标签frame
@property (nonatomic, assign) CGRect contentLabelFrame;
///草稿
@property (nonatomic, strong) NSString *draft;

@end

NS_ASSUME_NONNULL_END
