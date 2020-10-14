//
//  MomentsPublishModel.h
//  YangJiang
//
//  Created by 王泽平 on 2019/9/5.
//  Copyright © 2019 smartpilot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MomentsPublishPhotoModel : NSObject

///发布的图片文件
@property (nonatomic, strong) NSString *file;
///发布的图片缩略图
@property (nonatomic, strong) NSString *thumb;
///发布的图片文件类型 资源类型：1，图片；2，视频MP4
@property (nonatomic, assign) int type;
///资源文件宽度
@property (nonatomic, assign) int width;
///资源文件高度
@property (nonatomic, assign) int height;
///图片对象
@property (nonatomic, strong) UIImage *image;
///发布文字
@property (nonatomic, strong) NSString *content;

@end


@interface MomentsPublishModel : NSObject

///发布时手机点位地名
@property (nonatomic, strong) NSString *address;
///是否匿名发布
@property (nonatomic, assign) BOOL anonymous;
///发布时手机点位城市
@property (nonatomic, strong) NSString *area;
///港航圈文字内容
@property (nonatomic, strong) NSString *content;
///发布时手机点位纬度
@property (nonatomic, assign) double latitude;
///发布时手机点位经度
@property (nonatomic, assign) double longitude;
///发布的图片文件列表
@property (nonatomic, strong) NSArray<MomentsPublishPhotoModel *> *photos;
///发布的视频地址
@property (nonatomic, strong) NSString *vedio;

@end

NS_ASSUME_NONNULL_END
