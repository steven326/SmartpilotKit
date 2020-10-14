//
//  YJChoicesDialogView.m
//  YangJiang
//
//  Created by 王泽平 on 2019/8/13.
//  Copyright © 2019 smartpilot. All rights reserved.
//

#import "SPChoicesDialogView.h"
#import "SmartpilotKit.h"
#import "Masonry.h"
#import "YYCategories.h"

@implementation SPChoicesDialogView
{
    __weak IBOutlet UIImageView *_iconImgView;
    __weak IBOutlet NSLayoutConstraint *_iconImgViewHeight;
    __weak IBOutlet NSLayoutConstraint *_iconImgViewTop;
    __weak IBOutlet UIButton *_cancelButton;
    __weak IBOutlet UIButton *_confirmButton;
    __weak IBOutlet UIView *_contentView;
    __weak IBOutlet NSLayoutConstraint *_contentViewHeight;
    __weak IBOutlet UIButton *_forceConfirmButton;
    __weak IBOutlet UIButton *_forceCloseButton;
    __weak IBOutlet UIView *_verticalLine;
    __weak IBOutlet UIButton *_knownButton;
    __weak IBOutlet UIButton *_knownCancelButton;
    
    UILabel *_contentLabel;
    NSArray<UIButton *> *_actions;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            self.backgroundColor = SPDarkModeUtil.dialogBackgroundColor;
            _contentLabel.textColor = SPDarkModeUtil.normalTextColor;
            [_actions enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setTitleColor:SPDarkModeUtil.normalTextColor forState:UIControlStateNormal];
                [obj setTitleColor:[SPDarkModeUtil.normalTextColor colorWithAlphaComponent:.7] forState:UIControlStateHighlighted];
            }];
        }
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setWidth:kScreenWidth - 15.f*2];
    
    _actions = @[_cancelButton, _confirmButton, _forceCloseButton, _forceConfirmButton];
    
    @weakify(self);
    
    /// 强制确认
    _forceConfirmButton.hidden = true;
    [_forceConfirmButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        if (self.clickConfirmHandler) {
            self.clickConfirmHandler();
        }
    }];
    
    /// 强制取消
    _forceCloseButton.hidden = true;
    [_forceCloseButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        if (self.clickCancelHandler) {
            self.clickCancelHandler();
        }
    }];
    
    /// 取消
    [_cancelButton setTitleColor:[_cancelButton.currentTitleColor colorWithAlphaComponent:.7] forState:UIControlStateHighlighted];
    [_cancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        if (self.clickCancelHandler) {
            self.clickCancelHandler();
        }
    }];
    
    /// 确认
    [_confirmButton setTitleColor:[_confirmButton.currentTitleColor colorWithAlphaComponent:.7] forState:UIControlStateHighlighted];
    [_confirmButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        if (self.clickConfirmHandler) {
            self.clickConfirmHandler();
        }
    }];
    
    /// 我知道了
//    [_knownButton yj_blue_setTitle:@"我知道了" font:[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold] size:CGSizeZero];
    [_knownButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        if (self.clickConfirmHandler) {
            self.clickConfirmHandler();
        }
    }];
    
    /// 取消
    [_knownCancelButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        if (self.clickCancelHandler) {
            self.clickCancelHandler();
        }
    }];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:16.f];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.backgroundColor = UIColor.clearColor;
    [_contentView addSubview:_contentLabel];
    
    /// 暗黑模式颜色适配
    self.backgroundColor = SPDarkModeUtil.dialogBackgroundColor;
    _contentLabel.textColor = SPDarkModeUtil.normalTextColor;
    [_actions enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:SPDarkModeUtil.normalTextColor forState:UIControlStateNormal];
        [obj setTitleColor:[SPDarkModeUtil.normalTextColor colorWithAlphaComponent:.7] forState:UIControlStateHighlighted];
    }];
}

- (void)setIsForceConfirm:(BOOL)isForceConfirm
{
    _isForceConfirm = isForceConfirm;
    
    if (isForceConfirm) {
        _cancelButton.hidden = true;
        _confirmButton.hidden = true;
        _verticalLine.hidden = true;
        _forceCloseButton.hidden = true;
        _forceConfirmButton.hidden = false;
    }
}

- (void)setIsForceClose:(BOOL)isForceClose
{
    _isForceClose = isForceClose;
    
    if (isForceClose) {
        _cancelButton.hidden = true;
        _confirmButton.hidden = true;
        _verticalLine.hidden = true;
        _forceConfirmButton.hidden = true;
        _forceCloseButton.hidden = false;
    }
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [_iconImgView setImage:[UIImage imageNamed:imageName]];
}

- (void)setContent:(NSString *)content
{
    [self setAttributeContent:[[NSAttributedString alloc] initWithString:content]];
}

- (void)setAttributeContent:(NSAttributedString *)attributeContent
{
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    _attributeContent = attributeContent;
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithAttributedString:attributeContent];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    [attribute addAttribute:NSParagraphStyleAttributeName value:style range:attribute.string.rangeOfAll];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.f weight:UIFontWeightSemibold] range:attribute.string.rangeOfAll];
    _contentLabel.attributedText = attribute;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    
    ///layout
    CGFloat contentHeight = [SPUtils getContentSizeWithText:attributeContent.string
                                                       size:CGSizeMake(kScreenWidth - 15.f*2 - 30.f*2, 0)
                                                   fontSize:16.f
                                                lineSpacing:5].height + 10;
    contentHeight = contentHeight <= 62.f ? 62.f : contentHeight;
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
        make.centerX.mas_equalTo(self);
    }];
    _contentViewHeight.constant = contentHeight;
    
    if (self.type == SPChoicesDialogViewTypeTextOnly) {
        self.height = 160.f - 62.f + contentHeight - 20.f;
    }
    else if (self.type == SPChoicesDialogViewTypeTextKnown) {
        self.height = 300.f - 62.f + contentHeight - 20.f;
    }
    else if (self.type == SPChoicesDialogViewTypeTextKnownCancel) {
        self.height = 340.f - 62.f + contentHeight - 20.f;
    }
    else {
        self.height = 280.f - 62.f + contentHeight;
    }
}

- (void)setCustomView:(UIView *)customView
{
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    _customView = customView;
    [_contentView addSubview:customView];
    _contentViewHeight.constant = customView.height;
    self.width = customView.width >= (kScreenWidth - 15.f*2) ? (kScreenWidth - 15.f*2) : customView.width;
    self.height = (self.type == SPChoicesDialogViewTypeCustomViewKnown ? 100.f : 78.f) + _contentViewHeight.constant;
}

- (void)setAttributeContent:(NSAttributedString *)attribute customView:(UIView *)customView
{
    [self setAttributeContent:attribute];
    _customView = customView;
    CGFloat textHeight = _contentViewHeight.constant;
    [_contentView addSubview:customView];
    _contentViewHeight.constant = customView.height + textHeight;
    customView.top = textHeight;
    self.height = 280.f - 62.f + _contentViewHeight.constant;
}

- (void)setType:(SPChoicesDialogViewType)type
{
    _type = type;
    switch (type) {
        case SPChoicesDialogViewTypeText:
        case SPChoicesDialogViewTypeTextKnown:
        case SPChoicesDialogViewTypeTextKnownCancel:
        {
            _iconImgViewHeight.constant = 100;
            _iconImgViewTop.constant = 30;
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self->_contentView);
                make.left.equalTo(self->_contentView).offset(30);
                make.right.equalTo(self->_contentView).offset(-30);
            }];
            switch (type) {
                case SPChoicesDialogViewTypeTextKnown:
                {
                    _cancelButton.hidden = true;
                    _confirmButton.hidden = true;
                    _verticalLine.hidden = true;
                    _knownButton.hidden = false;
                    _knownCancelButton.hidden = true;
                }
                    break;
                case SPChoicesDialogViewTypeTextKnownCancel:
                {
                    _cancelButton.hidden = true;
                    _confirmButton.hidden = true;
                    _verticalLine.hidden = true;
                    _knownButton.hidden = false;
                    _knownCancelButton.hidden = false;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case SPChoicesDialogViewTypeCustomView:
        {
            _iconImgViewHeight.constant = 0;
            _iconImgViewTop.constant = 0;
        }
            break;
        case SPChoicesDialogViewTypeCustomViewKnown:
        {
            _iconImgViewHeight.constant = 0;
            _iconImgViewTop.constant = 0;
            _cancelButton.hidden = true;
            _confirmButton.hidden = true;
            _verticalLine.hidden = true;
            _knownButton.hidden = false;
            _knownCancelButton.hidden = true;
        }
            break;
        case SPChoicesDialogViewTypeTextOnly:
        {
            _iconImgViewHeight.constant = 0;
            _iconImgViewTop.constant = 0;
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self->_contentView);
                make.left.equalTo(self->_contentView).offset(30);
                make.right.equalTo(self->_contentView).offset(-30);
            }];
        }
            break;
        case SPChoicesDialogViewTypeTextAndCustomView:
        {
            _iconImgViewHeight.constant = 100;
            _iconImgViewTop.constant = 30;
            [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self->_contentView);
                make.left.equalTo(self->_contentView).offset(30);
                make.right.equalTo(self->_contentView).offset(-30);
            }];
            [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        }
            break;
        default:
            break;
    }
}

- (void)setConfirmText:(NSString *)confirmText
{
    _confirmText = confirmText;
    [_confirmButton setTitle:confirmText forState:UIControlStateNormal];
    [_forceConfirmButton setTitle:confirmText forState:UIControlStateNormal];
    [_knownButton setTitle:confirmText forState:UIControlStateNormal];
}

- (void)setCancelText:(NSString *)cancelText
{
    _cancelText = cancelText;
    [_cancelButton setTitle:cancelText forState:UIControlStateNormal];
    [_forceCloseButton setTitle:cancelText forState:UIControlStateNormal];
    [_knownCancelButton setTitle:cancelText forState:UIControlStateNormal];
}

- (void)setContentAlignment:(NSTextAlignment)contentAlignment
{
    _contentAlignment = contentAlignment;
    _contentLabel.textAlignment = contentAlignment;
}

- (void)setConfirmTextColor:(UIColor *)confirmTextColor
{
    _confirmTextColor = confirmTextColor;
    [_confirmButton setTitleColor:confirmTextColor forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[confirmTextColor colorWithAlphaComponent:.7] forState:UIControlStateHighlighted];
}

- (void)setCancelTextColor:(UIColor *)cancelTextColor
{
    _cancelTextColor = cancelTextColor;
    [_cancelButton setTitleColor:cancelTextColor forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[cancelTextColor colorWithAlphaComponent:.7] forState:UIControlStateHighlighted];
    [_knownCancelButton setTitleColor:cancelTextColor forState:UIControlStateNormal];
    [_knownCancelButton setTitleColor:[cancelTextColor colorWithAlphaComponent:.7] forState:UIControlStateHighlighted];
}

@end
