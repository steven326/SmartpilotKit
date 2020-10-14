//
//  SDTimeLineCell.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import <UIKit/UIKit.h>
#import "SDWeiXinPhotoContainerView.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"

@protocol SDTimeLineCellDelegate <NSObject>

@optional

/// 点击点赞回调
/// @param cell 当前Cell对象
- (void)didClickLikeButtonInCell:(UITableViewCell *)cell isLike:(BOOL)isLike;

/// 点击评论回调
/// @param cell 当前Cell对象
- (void)didClickCommentButtonInCell:(UITableViewCell *)cell;

/// 点击头像回调
/// @param cell 当前Cell对象
- (void)didClickPortraitInCell:(UITableViewCell *)cell;

/// 点击展开/收起回调
/// @param cell 当前Cell对象
- (void)didClickMoreButtonInCell:(UITableViewCell *)cell;

/// 点击评论区域用户名回调
/// @param cell 当前Cell对象
/// @param userId 用户id
- (void)didClickCommentUserInCell:(UITableViewCell *)cell userId:(NSString *)userId;

/// 点击评论回调
/// @param cell 当前Cell对象
/// @param index 评论内容的下标
- (void)didClickCommentInCell:(UITableViewCell *)cell cmt_index:(NSInteger)index;

/// 点击删除回调
/// @param cell 当前Cell对象
- (void)didClickDeleteButtonInCell:(UITableViewCell *)cell;

/// 点击举报回调
/// @param cell 当前Cell对象
- (void)didClickReportButtonInCell:(UITableViewCell *)cell;

/// 点击地址回调
/// @param cell 当前Cell对象
- (void)didClickLocationInCell:(UITableViewCell *)cell;

/// 长按复制内容回调
/// @param cell 当前Cell对象
- (void)didLongPressContentInCell:(UITableViewCell *)cell;

/// 长按评论内容回调
/// @param cell 当前Cell对象
/// @param index 评论内容的下标
/// @param rectInCell 相对于cell的frame
- (void)didLongPressCommentContentInCell:(UITableViewCell *)cell cmt_index:(NSInteger)index rectInCell:(CGRect)rectInCell;

@end

@class SDTimeLineCellModel;

@interface SDTimeLineCell : UITableViewCell

+ (NSString *)cellId;

/// 代理
@property (nonatomic, weak) id<SDTimeLineCellDelegate> delegate;

/// 港航圈实体
@property (nonatomic, strong) MomentsListModel *momentsListModel;

/// 随手拍实体
@property (nonatomic, strong) SnapshotsListModel *snapshotsListModel;

/// 列表下标
@property (nonatomic, strong) NSIndexPath *indexPath;

/// 展示更多，收起更多
@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

/// 删除
@property (nonatomic, copy) void (^deleteButtonClickedBlock)(NSIndexPath *indexPath);

@end
