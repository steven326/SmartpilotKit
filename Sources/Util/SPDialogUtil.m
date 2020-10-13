//
//  SPDialogUtil.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/13.
//

#import "SPDialogUtil.h"
#import "LeeAlert.h"
#import "SPChoicesDialogView.h"

@implementation SPDialogUtil

+ (void)showDialogWithView:(UIView *)view
{
    [self showDialogWithView:view identifier:@"" queue:YES clickBackgroundClose:NO];
}

+ (void)showDialogWithView:(UIView *)view clickBackgroundClose:(BOOL)clickBackgroundClose
{
    [self showDialogWithView:view identifier:@"" queue:YES clickBackgroundClose:clickBackgroundClose];
}

+ (void)showDialogWithView:(UIView *)view
                identifier:(NSString *)identifier
                     queue:(BOOL)queue
      clickBackgroundClose:(BOOL)clickBackgroundClose
{
    CGFloat maxWidth = (kScreenWidth - 15.f*2);
    CGFloat width = view.width >= maxWidth ? maxWidth : view.width;
    [LEEAlert alert].config
    .LeeMaxWidth(width)
    .LeeCustomView(view)
    .LeeHeaderColor(SPDarkModeUtil.dialogBackgroundColor)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeCornerRadius(5.f)
    .LeeIdentifier(identifier)
    .LeeQueue(queue)
    .LeeShouldAutorotate(NO)
    .LeeSupportedInterfaceOrientations(UIInterfaceOrientationMaskPortrait)
    .LeeClickBackgroundClose(clickBackgroundClose)
    .LeeShow();
}

+ (void)showChoicesDialogWithContent:(nullable NSAttributedString *)content
                           imageName:(nullable NSString *)imageName
                                view:(nullable UIView *)view
                                type:(SPChoicesDialogViewType)type
                         confirmText:(nullable NSString *)confirmText
                          cancelText:(nullable NSString *)cancelText
                    confirmTextColor:(nullable UIColor *)confirmTextColor
                     cancelTextColor:(nullable UIColor *)cancelTextColor
                        confirmBlock:(nullable void(^)(void))confirmBlock
                         cancelBlock:(nullable void(^)(void))cancelBlock
{
    [self showChoicesDialogWithContent:content imageName:imageName view:view type:type identifier:@"" queue:YES autoClose:YES confirmText:confirmText cancelText:cancelText confirmTextColor:confirmTextColor cancelTextColor:cancelTextColor isForceConfirm:NO isForceCancel:NO confirmBlock:confirmBlock cancelBlock:cancelBlock];
}

+ (void)showChoicesDialogWithContent:(nullable NSAttributedString *)content
                           imageName:(nullable NSString *)imageName
                                view:(nullable UIView *)view
                                type:(SPChoicesDialogViewType)type
                          identifier:(nullable NSString *)identifier
                               queue:(BOOL)queue
                           autoClose:(BOOL)autoClose
                         confirmText:(nullable NSString *)confirmText
                          cancelText:(nullable NSString *)cancelText
                    confirmTextColor:(nullable UIColor *)confirmTextColor
                     cancelTextColor:(nullable UIColor *)cancelTextColor
                      isForceConfirm:(BOOL)isForceConfirm
                       isForceCancel:(BOOL)isForceCancel
                        confirmBlock:(nullable void(^)(void))confirmBlock
                         cancelBlock:(nullable void(^)(void))cancelBlock
{
    SPChoicesDialogView *choicesDialogView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(SPChoicesDialogView.class) owner:self options:nil].lastObject;
    choicesDialogView.type = type;
    choicesDialogView.imageName = imageName ?: @"icon_dialog_confirm";
    choicesDialogView.confirmText = confirmText ?: @"确定";
    choicesDialogView.cancelText = cancelText ?: @"取消";
    choicesDialogView.isForceConfirm = isForceConfirm;
    choicesDialogView.isForceClose = isForceCancel;
    if (confirmTextColor) {
        choicesDialogView.confirmTextColor = confirmTextColor;
    }
    if (cancelTextColor) {
        choicesDialogView.cancelTextColor = cancelTextColor;
    }
    /// 文案 + 自定义视图
    if (content.string.isNotBlank && view) {
        [choicesDialogView setAttributeContent:content customView:view];
    }
    /// 文案
    else if (content.string.isNotBlank) {
        choicesDialogView.attributeContent = content;
    }
    /// 自定义视图
    else if (view) {
        choicesDialogView.customView = view;
    }
    /// 点击确认回调
    [choicesDialogView setClickConfirmHandler:^{
        if (autoClose) {
            [LEEAlert closeWithCompletionBlock:^{
                if (confirmBlock) confirmBlock();
            }];
        }
        else {
            if (confirmBlock) confirmBlock();
        }
    }];
    /// 点击取消回调
    [choicesDialogView setClickCancelHandler:^{
        [LEEAlert closeWithCompletionBlock:^{
            if (cancelBlock) cancelBlock();
        }];
    }];
    [self showDialogWithView:choicesDialogView identifier:identifier ?: @"" queue:queue clickBackgroundClose:NO];
}

@end
