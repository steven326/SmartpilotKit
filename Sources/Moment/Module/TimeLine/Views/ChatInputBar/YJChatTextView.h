//
//  YJChatTextView.h
//  YangJiang
//
//  Created by 王泽平 on 2020/1/8.
//  Copyright © 2020 smartpilot. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YJChatTextView;

@protocol YJChatTextViewDelegate <UITextViewDelegate>

- (void)textViewDeleteBackward:(YJChatTextView *)textView;

@end

@interface YJChatTextView : UITextView

@property(nonatomic ,weak) id<YJChatTextViewDelegate> delegate;

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, strong) UIColor *placeHolderTextColor;

- (NSUInteger)numberOfLinesOfText;

@end

NS_ASSUME_NONNULL_END
