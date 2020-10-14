//
//  YJChoicesDialogView.h
//  YangJiang
//
//  Created by 王泽平 on 2019/8/13.
//  Copyright © 2019 smartpilot. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SPChoicesDialogViewType) {
    ///图片+文字
    SPChoicesDialogViewTypeText = 1,
    ///自定义视图
    SPChoicesDialogViewTypeCustomView,
    ///纯文字
    SPChoicesDialogViewTypeTextOnly,
    ///自定义视图+知道了
    SPChoicesDialogViewTypeCustomViewKnown,
    ///图片+文字+知道了
    SPChoicesDialogViewTypeTextKnown,
    ///图片+文字+知道了+取消
    SPChoicesDialogViewTypeTextKnownCancel,
    ///文字+自定义视图
    SPChoicesDialogViewTypeTextAndCustomView,
};

@interface SPChoicesDialogView : UIView

/// 取消按钮回调
@property (nonatomic, copy) void(^clickCancelHandler)(void);
/// 确认按钮回调
@property (nonatomic, copy) void(^clickConfirmHandler)(void);

/// 类型
@property (nonatomic, assign) SPChoicesDialogViewType type;
/// 文字对齐方式
@property (nonatomic, assign) NSTextAlignment contentAlignment;
/// 只有确定
@property (nonatomic, assign) BOOL isForceConfirm;
/// 只有关闭
@property (nonatomic, assign) BOOL isForceClose;
/// 自定义视图
@property (nonatomic, strong) UIView *customView;
/// 图片
@property (nonatomic, copy) NSString *imageName;
/// 内容
@property (nonatomic, copy) NSString *content;
/// 富文本内容
@property (nonatomic, copy) NSAttributedString *attributeContent;
/// 确定按钮文字
@property (nonatomic, copy) NSString *confirmText;
/// 取消按钮文字
@property (nonatomic, copy) NSString *cancelText;
/// 确定按钮文字
@property (nonatomic, strong) UIColor *confirmTextColor;
/// 取消按钮文字
@property (nonatomic, strong) UIColor *cancelTextColor;

/**
 文字 + 自定义视图

 @param attribute 文本
 @param customView 自定义视图
 */
- (void)setAttributeContent:(NSAttributedString *)attribute customView:(UIView *)customView;

@end

NS_ASSUME_NONNULL_END
