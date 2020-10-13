//
//  SPDialogUtil.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPDialogUtil : NSObject

/// 弹出视图
/// @param view 自定义视图
+ (void)showDialogWithView:(UIView *)view;

/// 弹出视图
/// @param view 自定义视图
/// @param clickBackgroundClose 是否点击背景关闭
+ (void)showDialogWithView:(UIView *)view clickBackgroundClose:(BOOL)clickBackgroundClose;

/// 弹出视图
/// @param view 自定义视图
/// @param identifier 标记
/// @param queue 是否队里
/// @param clickBackgroundClose 是否点击背景关闭
+ (void)showDialogWithView:(UIView *)view
                identifier:(NSString *)identifier
                     queue:(BOOL)queue
      clickBackgroundClose:(BOOL)clickBackgroundClose;

/// 弹出带有选项的弹框
/// @param content 文本
/// @param imageName 图片名称
/// @param view 自定义视图
/// @param type 弹窗类型
/// @param confirmText 确认按钮文字
/// @param cancelText 取消按钮文字
/// @param confirmTextColor 确认按钮文字颜色
/// @param cancelTextColor 取消按钮文字颜色
/// @param confirmBlock 点击确认回调
/// @param cancelBlock 点击取消回调
+ (void)showChoicesDialogWithContent:(nullable NSAttributedString *)content
                           imageName:(nullable NSString *)imageName
                                view:(nullable UIView *)view
                                type:(SPChoicesDialogViewType)type
                         confirmText:(nullable NSString *)confirmText
                          cancelText:(nullable NSString *)cancelText
                    confirmTextColor:(nullable UIColor *)confirmTextColor
                     cancelTextColor:(nullable UIColor *)cancelTextColor
                        confirmBlock:(nullable void(^)(void))confirmBlock
                         cancelBlock:(nullable void(^)(void))cancelBlock;

/// 弹出带有选项的弹框（全属性）
/// @param content 文本
/// @param imageName 图片名称
/// @param view 自定义视图
/// @param type 弹窗类型
/// @param identifier 弹窗的id
/// @param queue 是否队列显示 默认YES
/// @param autoClose 是否自动关闭弹窗 默认YES
/// @param confirmText 确认按钮文字
/// @param cancelText 取消按钮文字
/// @param confirmTextColor 确认按钮文字颜色
/// @param cancelTextColor 取消按钮文字颜色
/// @param isForceConfirm 强制确认
/// @param isForceCancel 强制取消
/// @param confirmBlock 点击确认回调
/// @param cancelBlock 点击取消回调
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
                         cancelBlock:(nullable void(^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
