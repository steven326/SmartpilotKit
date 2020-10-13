//
//  SPUtils.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/9/30.
//

#import <Foundation/Foundation.h>
#import <YBImageBrowser/YBImageBrowser.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPUtils : NSObject

#pragma mark -
#pragma mark - Toast

/// 弹出提示框
/// @param message 消息提示
+ (void)showToastWithMessage:(NSString *)message;

/// 弹出提示框
/// @param message 消息提示
/// @param view 视图层
+ (void)showToastWithMessage:(NSString *)message view:(UIView *)view;

/// 弹出提示框
/// @param message 消息提示
/// @param duration 延迟多少秒关闭
/// @param view 视图层
+ (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration view:(UIView *)view;

/// 根据网络状态码弹出提示
/// @param statusCode 网络状态码
+ (void)showToastWithStatusCode:(long)statusCode;

#pragma mark -
#pragma mark - ImageBrowser

+ (void)showImageBrowserWithDataSourceArray:(NSArray<id<YBIBDataProtocol>> *)dataSourceArray
                                currentPage:(NSInteger)currentPage;

#pragma mark -
#pragma mark - Common

/// 收起键盘
+ (void)dismissKeyboard;

/// 获取最上层Controller
+ (UIViewController *)topViewController;

/// 获取合法（不重名）的文件名
/// @param name 原文件名
/// @param path 文件目录
+ (NSString *)legalFileNameWithName:(NSString *)name path:(NSString *)path;

/// 获取文本内容尺寸
/// @param text 文本
/// @param size 文本区域最大尺寸
/// @param fontSize 字号
/// @param lineSpacing 行间距
+ (CGSize)getContentSizeWithText:(NSString *)text
                            size:(CGSize)size
                        fontSize:(CGFloat)fontSize
                     lineSpacing:(CGFloat)lineSpacing;

@end

NS_ASSUME_NONNULL_END
