//
//  SPBaseTableVIew.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPBaseTableView : UITableView

/// 构造函数
/// @param frame frame
/// @param emptyImage 无数据时的占位图
- (instancetype)initWithFrame:(CGRect)frame
                   emptyImage:(nullable UIImage *)emptyImage;

/// 构造函数
/// @param frame frame
/// @param emptyImage 无数据时的占位图
/// @param emptyText 无数据时的文字
- (instancetype)initWithFrame:(CGRect)frame
                   emptyImage:(nullable UIImage *)emptyImage
                    emptyText:(NSString *)emptyText;

/// 当前页
@property (nonatomic, assign) int currentPageNo;

/// 是否是无数据状态
@property (nonatomic, assign) BOOL isNoData;

/// 空白占位图偏移量
@property (nonatomic, assign) CGPoint emptyImageOffset;

/// 是否启用头部下拉刷新
@property (nonatomic, assign) BOOL enableRefreshHeader;

/// 是否启用底部上拉加载
@property (nonatomic, assign) BOOL enableRefreshFooter;

/// 头部下拉刷新回调
@property (nonatomic, copy) void(^headerWithRefreshingBlock)(void);

/// 底部上拉加载回调
@property (nonatomic, copy) void(^footerWithRefreshingBlock)(void);

/// 滚动到最上方
- (void)scrollToTableViewTop;

@end

NS_ASSUME_NONNULL_END
