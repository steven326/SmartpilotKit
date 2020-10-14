//
//  YJChatInputBarControl.h
//  YangJiang
//
//  Created by 王泽平 on 2020/1/8.
//  Copyright © 2020 smartpilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJChatTextView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YJChatInputBarControlDelegate <NSObject>

@optional

/// 输入框位置尺寸发生变化回调
/// @param frame frame
- (void)chatInputBarShouldChangeFrame:(CGRect)frame;

/// 输入框点击发送按钮回调
/// @param content 输入框内容
- (void)chatInputBarDidClickSendButton:(NSString *)content;

/// TextView代理
- (void)chatInputBarTextViewDidBeginEditing:(UITextView *)textView;
- (void)chatInputBarTextViewDidChange:(UITextView *)textView;
- (void)chatInputBarTextViewDeleteBackward:(YJChatTextView *)textView;

@end

@interface YJChatInputBarControl : UIView

@property (nonatomic, weak) id<YJChatInputBarControlDelegate> delegate;

/// 输入框和键盘的可视总高度
@property (nonatomic, assign, readonly) CGFloat visibleInputKeyboardHeight;

/// 收起键盘
- (void)keyboardResignFirstResponder;

/// 弹起键盘
- (void)keyboardBecomeFirstResponder;

/// 配置textView内容
- (void)setTextViewContent:(NSString *)text;

/// 清除内容
- (void)clearTextViewContent;

/// 配置placeHolder
- (void)setTextViewPlaceHolder:(NSString *)placeholder;
- (void)setTextViewPlaceHolderColor:(UIColor *)placeHolderColor;

@end

NS_ASSUME_NONNULL_END
