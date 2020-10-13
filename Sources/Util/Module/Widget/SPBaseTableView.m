//
//  SPBaseTableVIew.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/10.
//

#import "SPBaseTableView.h"

#define NODATA_IMAGE_TAG 9999
#define NODATA_LABEL_TAG 9998

@implementation SPBaseTableView
{
    UIImage *_emptyDataImage;
    NSString *_emptyDataText;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            ((UILabel *)[self viewWithTag:NODATA_LABEL_TAG]).textColor = SPDarkModeUtil.holderTextColor;
        }
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _configureUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        [self _configureUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _configureUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                   emptyImage:(UIImage *)emptyImage
{
    _emptyDataImage = emptyImage;
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        [self _configureUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                   emptyImage:(UIImage *)emptyImage
                    emptyText:(NSString *)emptyText
{
    _emptyDataImage = emptyImage;
    _emptyDataText = emptyText;
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        [self _configureUI];
    }
    return self;
}

- (void)_configureUI
{
    self.backgroundColor = UIColor.clearColor;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    /// 没有数据时的占位图
    UIImageView *emptyImageView = [[UIImageView alloc] initWithImage: _emptyDataImage ?: [UIImage imageNamed:@"icon_nodata"]];
    emptyImageView.frame = self.bounds;
    emptyImageView.contentMode = UIViewContentModeCenter;
    emptyImageView.hidden = true;
    emptyImageView.tag = NODATA_IMAGE_TAG;
    [self addSubview:emptyImageView];
    
    /// 没有数据时的占位文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height - emptyImageView.image.size.height)/2.f + emptyImageView.image.size.height + 15, kScreenWidth, 20)];
    label.text = _emptyDataText ?: @"暂无数据";
    label.font = [UIFont systemFontOfSize:16.f];
    label.textColor = Color_GrayMessageText;
    label.textAlignment = NSTextAlignmentCenter;
    label.hidden = true;
    label.numberOfLines = 0;
    label.tag = NODATA_LABEL_TAG;
    [self addSubview:label];
    
    /// 头部下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.headerWithRefreshingBlock) {
            self.headerWithRefreshingBlock();
        }
    }];
    header.automaticallyChangeAlpha = YES;
    self.mj_header = header;
    self.mj_header.hidden = YES;
//    self.mj_header.ignoredScrollViewContentInsetTop = kIsIPhoneXSeries ? -24 : 0;
//    self.mj_header.mj_h += kIsIPhoneXSeries ? 20:0;
    
    /// 底部上拉加载
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.footerWithRefreshingBlock) {
            self.footerWithRefreshingBlock();
        }
    }];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
//    footer.stateLabel.font = [UIFont systemFontOfSize:16.f];
    self.mj_footer = footer;
    self.mj_footer.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImageView *emptyImageView = [self viewWithTag:NODATA_IMAGE_TAG];
    if (CGPointEqualToPoint(self.emptyImageOffset, CGPointZero)) {
        [emptyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    else {
        [emptyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.emptyImageOffset.x);
            make.centerY.mas_equalTo(self.emptyImageOffset.y);
        }];
    }
    
    UILabel *emptyLabel = [self viewWithTag:NODATA_LABEL_TAG];
    [emptyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emptyImageView.mas_bottom).offset(15);
        make.centerX.equalTo(emptyImageView);
    }];
}

- (void)setIsNoData:(BOOL)isNoData
{
    _isNoData = isNoData;
    UIImageView *emptyImageView = [self viewWithTag:NODATA_IMAGE_TAG];
    emptyImageView.hidden = !isNoData;
    UILabel *emptyLabel = [self viewWithTag:NODATA_LABEL_TAG];
    emptyLabel.hidden = !isNoData;
    self.enableRefreshFooter = !isNoData;
}

- (void)setEnableRefreshHeader:(BOOL)enableRefreshHeader
{
    _enableRefreshHeader = enableRefreshHeader;
    self.mj_header.hidden = !enableRefreshHeader;
}

- (void)setEnableRefreshFooter:(BOOL)enableRefreshFooter
{
    _enableRefreshFooter = enableRefreshFooter;
    self.mj_footer.hidden = !enableRefreshFooter;
}

- (void)scrollToTableViewTop
{
    if (self.indexPathsForVisibleRows.count) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

@end
