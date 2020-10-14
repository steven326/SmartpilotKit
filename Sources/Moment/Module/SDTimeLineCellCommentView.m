//
//  SDTimeLineCellCommentView.m
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
 * QQ交流群: 459274049
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

#import "SDTimeLineCellCommentView.h"
#import "UIView+SDAutoLayout.h"
#import "MLLinkLabel.h"
#import "SmartpilotKit.h"

#define MLLinkLabelIdentifier_isLike @"MLLinkLabelIdentifier_isLike"
#define MLLinkLabelIdentifier_isComment @"MLLinkLabelIdentifier_isComment"

@interface SDTimeLineCellCommentView () <MLLinkLabelDelegate>

/// 点赞数据源
@property (nonatomic, strong) NSArray<MomentsLikeUsersModel *> *likeItemsArray;

/// 评论数据源
@property (nonatomic, strong) NSArray<MomentsCommentsModel *> *commentItemsArray;

/// 评论区域背景图
@property (nonatomic, strong) UIImageView *bgImageView;

/// 点赞标签
@property (nonatomic, strong) MLLinkLabel *likeLabel;

/// 点赞评论分割线
@property (nonatomic, strong) UIView *likeLableBottomLine;

/// 评论Labels数组
@property (nonatomic, strong) NSMutableArray *commentLabelsArray;

@end

@implementation SDTimeLineCellCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _bgImageView = [UIImageView new];
    UIImage *bgImage = [UIImage imageNamed:@"LikeCmtBg"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 40, 30, 30) resizingMode:UIImageResizingModeStretch];
    _bgImageView.image = bgImage;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    _likeLabel = [MLLinkLabel new];
    _likeLabel.font = [UIFont systemFontOfSize:14];
    _likeLabel.isAttributedContent = YES;
    _likeLabel.delegate = self;
    _likeLabel.accessibilityValue = MLLinkLabelIdentifier_isLike;
    [self addSubview:_likeLabel];
    
    _likeLableBottomLine = [UIView new];
    [self addSubview:_likeLableBottomLine];
    
    [self reloadThemeStyle];
}

- (void)reloadThemeStyle
{
    UIImage *bgImage = [UIImage imageNamed:@"LikeCmtBg"];
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 40, 30, 30) resizingMode:UIImageResizingModeStretch];
    _bgImageView.image = bgImage;
    self.likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : SPDarkModeUtil.momentTitleColor};
    self.likeLableBottomLine.backgroundColor = SPDarkModeUtil.momentSepratorColor;
    
    [self.commentLabelsArray enumerateObjectsUsingBlock:^(MLLinkLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.linkTextAttributes = @{NSForegroundColorAttributeName:SPDarkModeUtil.momentTitleColor};
        obj.activeLinkTextAttributes = @{NSBackgroundColorAttributeName:[UIColor colorWithWhite:0.215 alpha:0.300],
                                         NSForegroundColorAttributeName:SPDarkModeUtil.momentTitleColor};
    }];
    
    self.likeLabel.activeLinkTextAttributes = @{NSBackgroundColorAttributeName:[UIColor colorWithWhite:0.215 alpha:0.300],NSForegroundColorAttributeName:SPDarkModeUtil.normalTextColor};
}

- (void)setCommentItemsArray:(NSArray *)commentItemsArray
{
    _commentItemsArray = commentItemsArray;
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemsArray.count > originalLabelsCount ? (commentItemsArray.count - originalLabelsCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        MLLinkLabel *label = [MLLinkLabel new];
        label.linkTextAttributes = @{NSForegroundColorAttributeName : Color_BlueText};
        label.activeLinkTextAttributes = @{NSBackgroundColorAttributeName : [UIColor colorWithWhite:0.215 alpha:0.300],
                                           NSForegroundColorAttributeName : Color_BlueText};
        label.font = [UIFont systemFontOfSize:14];
        label.delegate = self;
        label.accessibilityValue = MLLinkLabelIdentifier_isComment;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
    }
    
    for (int i = 0; i < commentItemsArray.count; i++) {
        MomentsCommentsModel *model = commentItemsArray[i];
        MLLinkLabel *label = self.commentLabelsArray[i];
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithCommentItemMomentModel:model];
        }
        label.attributedText = model.attributedContent;
        
        MLLink *link = [MLLink linkWithType:MLLinkTypeNone value:@(i).stringValue range:NSMakeRange(model.attributedContent.string.length - model.comment.length, model.comment.length)];
        link.linkTextAttributes = @{NSForegroundColorAttributeName:SPDarkModeUtil.normalTextColor};
        link.activeLinkTextAttributes = @{NSBackgroundColorAttributeName:[UIColor colorWithWhite:0.215 alpha:0.300],
                                          NSForegroundColorAttributeName:SPDarkModeUtil.normalTextColor};
        [label addLink:link];
    }
}

- (void)setLikeItemsArray:(NSArray *)likeItemsArray
{
    _likeItemsArray = likeItemsArray;
    
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    NSAttributedString *placeHolder = [[NSAttributedString alloc] initWithString:@""];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeItemsArray.count ? likeIcon : placeHolder];
    
    for (int i = 0; i < likeItemsArray.count; i++) {
        MomentsLikeUsersModel *model = likeItemsArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithLikeItemMomentModel:model];
        }
        [attributedText appendAttributedString:model.attributedContent];
    }
    
    _likeLabel.attributedText = [attributedText copy];
    _likeLabel.activeLinkTextAttributes = @{NSBackgroundColorAttributeName:[UIColor colorWithWhite:0.215 alpha:0.300],
                                            NSForegroundColorAttributeName:Color_BlueText};
}

- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray
{
    self.likeItemsArray = likeItemsArray;
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            // 重用时先隐藏所以评论label，然后根据评论个数显示label
            label.hidden = YES;
        }];
    }
    
    if (!commentItemsArray.count && !likeItemsArray.count) {
        // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
        self.fixedWidth = @(0);
        // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        self.fixedHeight = @(0);
        return;
    }
    else {
        // 取消固定宽度约束
        self.fixedHeight = nil;
        // 取消固定高度约束
        self.fixedWidth = nil;
    }
    
    CGFloat margin = 5;
    UIView *lastTopView = nil;
    if (likeItemsArray.count) {
        _likeLabel.sd_resetLayout
        .leftSpaceToView(self, margin)
        .rightSpaceToView(self, margin)
        .topSpaceToView(lastTopView, 10)
        .autoHeightRatio(0);
        lastTopView = _likeLabel;
    }
    else {
        _likeLabel.attributedText = nil;
        _likeLabel.sd_resetLayout
        .heightIs(0);
    }
    
    if (self.commentItemsArray.count && self.likeItemsArray.count) {
        _likeLableBottomLine.sd_resetLayout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(1)
        .topSpaceToView(lastTopView, 3);
        lastTopView = _likeLableBottomLine;
    }
    else {
        _likeLableBottomLine.sd_resetLayout.heightIs(0);
    }
    
    for (int i = 0; i < self.commentItemsArray.count; i++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        label.hidden = NO;
        CGFloat topMargin = (i == 0 && likeItemsArray.count == 0) ? 10 : 5;
        label.sd_layout
        .leftSpaceToView(self, 8)
        .rightSpaceToView(self, 5)
        .topSpaceToView(lastTopView, topMargin)
        .autoHeightRatio(0);
        label.isAttributedContent = YES;
        lastTopView = label;
    }
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
    
    /// 刷新主题
    [self reloadThemeStyle];
}

#pragma mark - private actions

/// 生成评论富文本
/// @param model 评论实体
- (NSMutableAttributedString *)generateAttributedStringWithCommentItemMomentModel:(MomentsCommentsModel *)model
{
    NSString *text = model.use_name;
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.comment]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSLinkAttributeName:@([_commentItemsArray indexOfObject:model]).stringValue} range:[text rangeOfString:model.use_name]];
    return attString;
}

/// 生成点赞富文本
/// @param model 点赞实体
- (NSMutableAttributedString *)generateAttributedStringWithLikeItemMomentModel:(MomentsLikeUsersModel *)model
{
    NSString *text = model.use_name;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = Color_BlueText;
    [attString setAttributes:@{NSForegroundColorAttributeName:highLightColor,
                               NSLinkAttributeName:model.user_id}
                       range:[text rangeOfString:model.use_name]];
    return attString;
}

///// 二级回复（暂不用）
///// @param model 评论实体
//- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(SDTimeLineCellCommentItemModel *)model
//{
//    NSString *text = model.firstUserName;
//    if (model.secondUserName.length) {
//        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.secondUserName]];
//    }
//    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.commentString]];
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
//    [attString setAttributes:@{NSLinkAttributeName : model.firstUserId} range:[text rangeOfString:model.firstUserName]];
//    if (model.secondUserName) {
//        [attString setAttributes:@{NSLinkAttributeName : model.secondUserId} range:[text rangeOfString:model.secondUserName]];
//    }
//    return attString;
//}

#pragma mark - MLLinkLabelDelegate
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"didClickLink. linkValue = %@", link.linkValue);
    
    /// 单击点赞用户名
    if ([linkLabel isEqual:self.likeLabel]) {
        if (self.didTapUserNameBlock) {
            self.didTapUserNameBlock(link.linkValue);
        }
    }
    /// 单击评论用户名
    else if ([linkText isEqualToString:self.commentItemsArray[link.linkValue.intValue].use_name] &&
             link.linkRange.location == 0) {
        if (self.didTapUserNameBlock) {
            self.didTapUserNameBlock(self.commentItemsArray[link.linkValue.intValue].user_id);
        }
    }
    /// 单击评论内容
    else if ([linkText isEqualToString:self.commentItemsArray[link.linkValue.intValue].comment]) {
        if (self.didTapCommentContentBlock) {
            self.didTapCommentContentBlock(link.linkValue.integerValue);
        }
    }
}

- (void)didLongPressLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"didLongPressLink. linkValue = %@", link.linkValue);
    
    /// 长按评论内容回调
    if (![linkLabel isEqual:self.likeLabel]
        && [linkText isEqualToString:self.commentItemsArray[link.linkValue.intValue].comment]) {
        if (self.didLongPressCommentContentBlock) {
            CGRect rectInCell = [self convertRect:linkLabel.frame toView:self.superview];
            NSLog(@"rectInCell: %@", NSStringFromCGRect(rectInCell));
            self.didLongPressCommentContentBlock(link.linkValue.integerValue, rectInCell);
        }
    }
}
@end
