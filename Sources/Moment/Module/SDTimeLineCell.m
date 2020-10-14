//
//  SDTimeLineCell.m
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

#import "SDTimeLineCell.h"
#import "UIView+SDAutoLayout.h"
#import "SDTimeLineCellCommentView.h"
#import "SDTimeLineCellOperationMenu.h"
#import "UIImageView+WebCache.h"
#import "YYText.h"
#import "SPMomentListViewController.h"
#import "SmartpilotKit.h"
#import "YYCategories.h"

const CGFloat contentLabelFontSize = 16;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";

@implementation SDTimeLineCell
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_subTitleLabel;
    YYLabel *_contentLabel;
    UILabel *_timeLabel;
    YYLabel *_locationLabel;
    UIButton *_moreButton;
    UIButton *_deleteButton;
    UIButton *_operationButton;
    UIButton *_reportButton;
    UIView *_lineView;
    SDWeiXinPhotoContainerView *_picContainerView;
    SDTimeLineCellCommentView *_commentView;
    SDTimeLineCellOperationMenu *_operationMenu;
}

+ (NSString *)cellId
{
    return NSStringFromClass(self.class);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initUI];
        [self _layoutUI];
        [self _bindEvent];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)_initUI
{
    _iconView = [UIImageView new];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.userInteractionEnabled = true;
    _iconView.layer.cornerRadius = 42.f / 2.f;
    _iconView.layer.masksToBounds = YES;
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:18];
    _nameLable.textColor = [UIColor colorWithRed:(1 / 255.0) green:(38 / 255.0) blue:(90 / 255.0) alpha:1];
    
    _subTitleLabel = [UILabel new];
    _subTitleLabel.font = [UIFont systemFontOfSize:14];
    _subTitleLabel.textColor = [UIColor colorWithRed:(169 / 255.0) green:(181 / 255.0) blue:(195 / 255.0) alpha:1];
    
    _deleteButton = [UIButton new];
    [_deleteButton setImage:[UIImage imageNamed:@"icon_trash"] forState:UIControlStateNormal];
    
    _contentLabel = [YYLabel new];
    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(54 / 255.0) blue:(54 / 255.0) alpha:1];
    _contentLabel.numberOfLines = 0;
    _contentLabel.userInteractionEnabled = YES;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3 + 6;
    }
    
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:Color_BlueText forState:UIControlStateNormal];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor colorWithRed:(169 / 255.0) green:(181 / 255.0) blue:(195 / 255.0) alpha:1];
    
    _reportButton = [UIButton new];
    [_reportButton setTitle:@"投诉" forState:UIControlStateNormal];
    [_reportButton setTitleColor:Color_BlueText forState:UIControlStateNormal];
    _reportButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    _locationLabel = [YYLabel new];
    _locationLabel.font = [UIFont systemFontOfSize:12];
    _locationLabel.textColor = [UIColor colorWithRed:(11 / 255.0) green:(20 / 255.0) blue:(61 / 255.0) alpha:1];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithRed:(239 / 255.0) green:(239 / 255.0) blue:(239 / 255.0) alpha:1];
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    _commentView = [SDTimeLineCellCommentView new];
    _operationMenu = [SDTimeLineCellOperationMenu new];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
    
    NSArray *views = @[_iconView, _nameLable, _subTitleLabel, _deleteButton, _contentLabel, _moreButton, _picContainerView, _locationLabel, _timeLabel, _reportButton, _operationButton, _operationMenu, _commentView, _lineView];
    [self.contentView sd_addSubviews:views];
    
    /// 主题颜色
    [self reloadThemeStyle];
}

- (void)_layoutUI
{
    UIView *contentView = self.contentView;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, 30)
    .topSpaceToView(contentView, 20)
    .widthIs(42)
    .heightIs(42);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, 15)
    .topEqualToView(_iconView)
    .heightIs(25);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _subTitleLabel.sd_layout
    .leftEqualToView(_nameLable)
    .rightSpaceToView(contentView, 30)
    .heightIs(20)
    .topSpaceToView(_nameLable, 0);
    
    _deleteButton.sd_layout
    .widthIs(18)
    .heightIs(18)
    .rightSpaceToView(contentView, 30)
    .topSpaceToView(contentView, 23);
    
    _contentLabel.sd_layout
    .leftEqualToView(_iconView)
    .topSpaceToView(_iconView, 10)
    .rightSpaceToView(contentView, 25)
    .heightIs(maxContentLabelHeight);
    
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(30);
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel);
    
    _locationLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(_picContainerView, 10)
    .heightIs(20);
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_locationLabel, 7)
    .heightIs(20);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
    
    _reportButton.sd_layout
    .leftSpaceToView(_timeLabel, 10)
    .topEqualToView(_timeLabel)
    .heightIs(20)
    .widthIs(30);
    
    _operationButton.sd_layout
    .rightSpaceToView(contentView, 15)
    .centerYEqualToView(_timeLabel)
    .heightIs(25)
    .widthIs(25);
    
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(contentView, 15)
    .topSpaceToView(_timeLabel, 10);
    
    _operationMenu.sd_layout
    .rightSpaceToView(_operationButton, 0)
    .heightIs(36)
    .centerYEqualToView(_operationButton)
    .widthIs(0);
    
    _lineView.sd_layout
    .rightEqualToView(contentView)
    .leftEqualToView(contentView)
    .heightIs(1)
    .bottomEqualToView(contentView);
}

- (void)_bindEvent
{
    @weakify(self);
    
    /// 点击头像
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(didClickPortraitInCell:)]) {
            [self.delegate didClickPortraitInCell:self];
        }
    }];
    [_iconView addGestureRecognizer:tap];
    
    /// 收起展开
    [_moreButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        if (self.moreButtonClickedBlock) {
            self.moreButtonClickedBlock(self.indexPath);
        }
        if ([self.delegate respondsToSelector:@selector(didClickMoreButtonInCell:)]) {
            [self.delegate didClickMoreButtonInCell:self];
        }
    }];
    
    /// 点赞评论
    [_operationButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self postOperationButtonClickedNotification];
        self->_operationMenu.show = !self->_operationMenu.isShowing;
    }];
    
    /// 点赞
    [_operationMenu setLikeButtonClickedOperation:^(BOOL isLike) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(didClickLikeButtonInCell: isLike:)]) {
            [self.delegate didClickLikeButtonInCell:self isLike:isLike];
        }
    }];
    
    /// 评论
    [_operationMenu setCommentButtonClickedOperation:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(didClickCommentButtonInCell:)]) {
            [self.delegate didClickCommentButtonInCell:self];
        }
    }];
    
    /// 删除
    [_deleteButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        if (self.deleteButtonClickedBlock) {
            self.deleteButtonClickedBlock(self.indexPath);
        }
        if ([self.delegate respondsToSelector:@selector(didClickDeleteButtonInCell:)]) {
            [self.delegate didClickDeleteButtonInCell:self];
        }
    }];
    
    /// 举报
    [_reportButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(didClickReportButtonInCell:)]) {
            [self.delegate didClickReportButtonInCell:self];
        }
    }];
    
    /// 点击评论区域人名回调
    [_commentView setDidTapUserNameBlock:^(NSString *userId) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(didClickCommentUserInCell: userId:)]) {
            [self.delegate didClickCommentUserInCell:self userId:userId];
        }
    }];
    
    /// 长按评论
    [_commentView setDidLongPressCommentContentBlock:^(NSInteger index, CGRect rectInCell) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(didLongPressCommentContentInCell:cmt_index:rectInCell:)]) {
            [self.delegate didLongPressCommentContentInCell:self cmt_index:index rectInCell:rectInCell];
        }
    }];
    
    /// 点按评论
    [_commentView setDidTapCommentContentBlock:^(NSInteger index) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(didClickCommentInCell:cmt_index:)]) {
            [self.delegate didClickCommentInCell:self cmt_index:index];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];
}

- (void)setMomentsListModel:(MomentsListModel *)momentsListModel
{
    _momentsListModel = momentsListModel;
    
    @weakify(self);
    
    /// 点赞/评论
    [_commentView setupWithLikeItemsArray:momentsListModel.like_users commentItemsArray:momentsListModel.comments];
    
    /// 基础赋值
    [_iconView sd_setImageWithURL:[NSURL URLWithString:momentsListModel.user_photo] placeholderImage:[UIImage imageNamed:@"icon_male"]];
    _nameLable.text = momentsListModel.user_name;
    _subTitleLabel.text = [NSString stringWithFormat:@"%@",momentsListModel.user_role];
    _picContainerView.pictures = momentsListModel.pictures;
    _timeLabel.text = momentsListModel.format_time ?: @" ";
    _operationMenu.is_like = momentsListModel.is_like;
    
    /// 判断用户是否有权限删除港航圈
    if ([momentsListModel.user_id isEqualToString:SPMomentConfig.shared.userId]
        || SPMomentConfig.shared.hasDeletePostPrivilage) {
        _deleteButton.hidden = NO;
    }
    else {
        _deleteButton.hidden = YES;
    }
    
    NSRange locationAttrRange = momentsListModel.address.rangeOfAll;
    NSMutableAttributedString *attr_location = [[NSMutableAttributedString alloc] initWithString:momentsListModel.address?:@""];
    [attr_location addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:locationAttrRange];
    [attr_location yy_setAlignment:NSTextAlignmentJustified range:locationAttrRange];
    [attr_location yy_setTextHighlightRange:locationAttrRange color:Color_BlueText backgroundColor:Color_BackGroundGray tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(didClickLocationInCell:)]) {
            [self.delegate didClickLocationInCell:self];
        }
    }];
    _locationLabel.attributedText = attr_location;
    _locationLabel.sd_layout.heightIs(momentsListModel.address.isNotBlank ? 20 : 0);
    
    /// 文本内容 /  长按事件
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:momentsListModel.content];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:contentLabelFontSize] range:NSMakeRange(0, attribute.length)];
    [attribute yy_setLineSpacing:2 range:NSMakeRange(0, attribute.length)];
    [attribute yy_setAlignment:NSTextAlignmentJustified range:NSMakeRange(0, attribute.length)];
    [attribute yy_setTextHighlightRange:NSMakeRange(0, attribute.length)
                                  color:SPDarkModeUtil.normalTextColor
                        backgroundColor:SPDarkModeUtil.normalTextHighlightColor
                               userInfo:nil
                              tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"tapAction");
    } longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(didLongPressContentInCell:)]) {
            [self.delegate didLongPressContentInCell:self];
        }
    }];
    _contentLabel.attributedText = attribute;
    
    /// 更多/收起 按钮 以及 文本区域高度适配
    CGFloat height_act = [self getContentHeight:attribute label:_contentLabel isExpand:momentsListModel.isOpening];
    if (momentsListModel.shouldShowMoreButton) {
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (momentsListModel.isOpening) {
            _contentLabel.sd_layout.heightIs(height_act);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.heightIs(height_act <= maxContentLabelHeight ? height_act : maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    }
    else {
        _contentLabel.sd_layout.heightIs(height_act);
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    /// 图片展示区域
    _picContainerView.sd_layout.topSpaceToView(_moreButton, momentsListModel.pictures.count ? 10 : 0);
    
    /// 确定底部视图，交给SDLayout计算行高
    UIView *bottomView = (!momentsListModel.comments.count && !momentsListModel.like_users.count) ? _timeLabel : _commentView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:20];
    
    /// 主题颜色
    [self reloadThemeStyle];
}

- (void)setSnapshotsListModel:(SnapshotsListModel *)snapshotsListModel
{
    _snapshotsListModel = snapshotsListModel;
    
    /// 点赞/评论
    [_commentView setupWithLikeItemsArray:@[] commentItemsArray:@[]];
    
    /// 基础赋值
    [_iconView sd_setImageWithURL:[NSURL URLWithString:snapshotsListModel.user_photo] placeholderImage:[UIImage imageNamed:@"icon_male"]];
    _nameLable.text = snapshotsListModel.user_name;
    _subTitleLabel.text = [NSString stringWithFormat:@"%@",snapshotsListModel.user_role];
    _picContainerView.pictures = snapshotsListModel.pictures;
    _locationLabel.text = snapshotsListModel.address;
    _timeLabel.text = snapshotsListModel.format_time ?: @" ";
    _operationButton.hidden = YES;
    
    /// 判断用户是否有权限删除港航圈
    if ([snapshotsListModel.user_id isEqualToString:SPMomentConfig.shared.userId]
        || SPMomentConfig.shared.hasDeletePostPrivilage) {
        _deleteButton.hidden = NO;
    }
    else {
        _deleteButton.hidden = YES;
    }
    
    /// 文本内容 /  长按事件
    @weakify(self);
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:snapshotsListModel.content];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:contentLabelFontSize] range:NSMakeRange(0, attribute.length)];
    [attribute yy_setLineSpacing:2 range:NSMakeRange(0, attribute.length)];
    [attribute yy_setAlignment:NSTextAlignmentJustified range:NSMakeRange(0, attribute.length)];
    [attribute yy_setTextHighlightRange:NSMakeRange(0, attribute.length)
                                  color:SPDarkModeUtil.normalTextColor
                        backgroundColor:SPDarkModeUtil.normalTextHighlightColor
                               userInfo:nil
                              tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"tapAction");
    } longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(didLongPressContentInCell:)]) {
            [self.delegate didLongPressContentInCell:self];
        }
    }];
    _contentLabel.attributedText = attribute;
    
    /// 更多/收起 按钮 以及 文本区域高度适配
    CGFloat height_act = [self getContentHeight:attribute label:_contentLabel isExpand:snapshotsListModel.isOpening];
    if (snapshotsListModel.shouldShowMoreButton) {
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (snapshotsListModel.isOpening) {
            _contentLabel.sd_layout.heightIs(height_act);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.heightIs(height_act <= maxContentLabelHeight ? height_act : maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    }
    else {
        _contentLabel.sd_layout.heightIs(height_act);
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    /// 图片展示区域
    _picContainerView.sd_layout.topSpaceToView(_moreButton, snapshotsListModel.pictures.count ? 10 : 0);
    
    /// 确定底部视图，交给SDLayout计算行高
    [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:20];
    
    /// 主题颜色
    [self reloadThemeStyle];
}

- (void)reloadThemeStyle
{
    _nameLable.textColor = SPDarkModeUtil.momentTitleColor;
    _subTitleLabel.textColor = SPDarkModeUtil.momentSubTitleColor;
    _contentLabel.textColor = SPDarkModeUtil.normalTextColor;
    _locationLabel.textColor = SPDarkModeUtil.momentTitleColor;
    [_reportButton setTitleColor:SPDarkModeUtil.momentTitleColor forState:UIControlStateNormal];
    [_moreButton setTitleColor:SPDarkModeUtil.blueDarkmodeColor forState:UIControlStateNormal];
    _lineView.backgroundColor = SPDarkModeUtil.momentSepratorColor;
    self.contentView.backgroundColor = SPDarkModeUtil.momentCellBackgroundColor;
}

- (CGFloat)getContentHeight:(NSAttributedString *)attributeContent
                      label:(YYLabel *)label
                   isExpand:(BOOL)isExpand
{
    YYTextContainer *container = [YYTextContainer new];
    container.maximumNumberOfRows = isExpand ? 0 : 3;
    container.truncationType = YYTextTruncationTypeEnd;
    container.size = CGSizeMake(kScreenWidth-55, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributeContent];
    label.textLayout = layout;
    if (self.momentsListModel) {
        CGRect frame = self.momentsListModel.contentLabelFrame;
        frame.size = layout.textBoundingSize;
        self.momentsListModel.contentLabelFrame = frame;
    }
    return layout.textBoundingSize.height;
}

#pragma mark - private actions

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _operationButton && _operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self postOperationButtonClickedNotification];
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController.isMenuVisible) {
        [menuController setMenuVisible:NO animated:YES];
    }
}

- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNotification object:_operationButton];
}

#pragma mark - MenuController
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)) return YES;
    return NO;
}

- (void)copy:(UIMenuController *)menu
{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = menu.accessibilityValue ?: @"";
}
@end

