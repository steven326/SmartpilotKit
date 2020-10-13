//
//  YJChatInputBarControl.m
//  YangJiang
//
//  Created by 王泽平 on 2020/1/8.
//  Copyright © 2020 smartpilot. All rights reserved.
//

#import "YJChatInputBarControl.h"

@interface YJChatInputBarControl ()<YJChatTextViewDelegate>

@property (nonatomic, strong) YJChatTextView *textView;

@property (nonatomic, strong) UIButton *sendButton;

@property CGFloat previousTextViewHeight;

@end

@implementation YJChatInputBarControl

@synthesize visibleInputKeyboardHeight = _visibleInputKeyboardHeight;

#pragma mark - dealloc

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            self.backgroundColor = YJDarkModeFactory.shareInstance.momentSepratorColor;
            self.textView.textColor = YJDarkModeFactory.shareInstance.xinyuTextColor;
            self.textView.backgroundColor = YJDarkModeFactory.shareInstance.momentCellBackgroundColor;
        }
    }
}

- (void)dealloc
{
    [self removeObserverBlocks];
    [NSNotificationCenter.defaultCenter removeObserverBlocks];
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initUI];
        [self _layoutUI];
        [self _bindEvent];
    }
    return self;
}

- (void)_initUI
{
    self.previousTextViewHeight = 36;
    self.backgroundColor = YJDarkModeFactory.shareInstance.momentSepratorColor;
    self.textView.textColor = YJDarkModeFactory.shareInstance.xinyuTextColor;
    self.textView.backgroundColor = YJDarkModeFactory.shareInstance.momentCellBackgroundColor;
    [self addSubview:self.textView];
    [self addSubview:self.sendButton];
}

- (void)_layoutUI
{
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.equalTo(@55);
        make.height.equalTo(@30);
        make.bottom.equalTo(self.textView.mas_bottom).offset(-3);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.sendButton.mas_left).offset(-10);
        make.top.equalTo(self).offset(7);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
    }];
}

- (void)_bindEvent
{
    @weakify(self);
    
    [self addObserverBlockForKeyPath:@"self.textView.contentSize" block:^(id  _Nonnull obj, id  _Nonnull oldVal, id  _Nonnull newVal) {
        @strongify(self);
        [self layoutAndAnimateTextView:self.textView];
    }];
    
    /// 监听键盘
    [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull notification) {
        if (!self) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                @strongify(self);
                CGRect begin = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
                CGRect end = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
                CGFloat targetY = end.origin.y - self.frame.size.height - (kScreenHeight - self.superview.frame.size.height);
                if (begin.size.height >= 0 && (begin.origin.y - end.origin.y > 0)) {
                    self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                    self->_visibleInputKeyboardHeight = self.superview.frame.size.height - targetY;
                }
                else if (end.origin.y == kScreenHeight && begin.origin.y != end.origin.y && duration > 0) {
                    self.frame = CGRectMake(0, kScreenHeight, CGRectGetWidth(self.frame), self.frame.size.height);
                    self->_visibleInputKeyboardHeight = 0;
                }
                if ([self.delegate respondsToSelector:@selector(chatInputBarShouldChangeFrame:)]) {
                    [self.delegate chatInputBarShouldChangeFrame:self.frame];
                }
            }];
        });
    }];
    
    /// 发送按钮
    [self.sendButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self keyboardResignFirstResponder];
        if ([self.delegate respondsToSelector:@selector(chatInputBarDidClickSendButton:)]) {
            [self.delegate chatInputBarDidClickSendButton:self.textView.text];
        }
        self.textView.text = nil;
    }];
}

- (void)layoutAndAnimateTextView:(YJChatTextView *)textView
{
    CGFloat maxHeight = 36 * 5;
    CGFloat contentH = textView.contentSize.height <= 36 ? 36 : textView.contentSize.height;
    
    BOOL isShrinking = contentH < self.previousTextViewHeight;
    CGFloat changeInHeight = contentH - self.previousTextViewHeight;
    
    if (!isShrinking && (self.previousTextViewHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f animations:^{
            if (isShrinking) {
                // if shrinking the view, animate text view frame BEFORE input view frame
                [self adjustTextViewHeightBy:changeInHeight];
            }
            CGRect inputViewFrame = self.frame;
            self.frame = CGRectMake(0.0f, inputViewFrame.origin.y - changeInHeight, inputViewFrame.size.width, (inputViewFrame.size.height + changeInHeight));
            self->_visibleInputKeyboardHeight = self.superview.frame.size.height - (inputViewFrame.origin.y - changeInHeight);
            if ([self.delegate respondsToSelector:@selector(chatInputBarShouldChangeFrame:)]) {
                [self.delegate chatInputBarShouldChangeFrame:self.frame];
            }
            if (!isShrinking) {
                // growing the view, animate the text view frame AFTER input view frame
                [self adjustTextViewHeightBy:changeInHeight];
            }
        } completion:^(BOOL finished) {}];
        self.previousTextViewHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
            [textView setContentOffset:bottomOffset animated:YES];
        });
    }
}

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    //动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.textView.frame;
    
    NSUInteger numLines = MAX([self.textView numberOfLinesOfText],
                              [[self.textView.text componentsSeparatedByString:@"\n"] count] + 1);
    
    
    self.textView.frame = CGRectMake(prevFrame.origin.x, prevFrame.origin.y, prevFrame.size.width, prevFrame.size.height + changeInHeight);
    
    self.textView.contentInset = UIEdgeInsetsMake((numLines >=6 ? 4.0f : 0.0f), 0.0f, (numLines >=6 ? 4.0f : 0.0f), 0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    //self.messageInputTextView.scrollEnabled = YES;
    if (numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height-self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length-2, 1)];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatInputBarTextViewDidBeginEditing:)]) {
        [self.delegate chatInputBarTextViewDidBeginEditing:self.textView];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatInputBarTextViewDidChange:)]) {
        [self.delegate chatInputBarTextViewDidChange:self.textView];
    }
    self.sendButton.enabled = textView.text.length;
}

- (void)textViewDeleteBackward:(YJChatTextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(chatInputBarTextViewDeleteBackward:)]) {
        [self.delegate chatInputBarTextViewDeleteBackward:textView];
    }
}

#pragma mark - Setter

#pragma mark - Lazy
- (YJChatTextView *)textView
{
    if (!_textView) {
        _textView = [[YJChatTextView alloc] init];
        _textView.delegate = self;
    }
    return _textView;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton yj_blue_setTitle:@"发送" font:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] size:CGSizeZero];
        _sendButton.enabled = NO;
    }
    return _sendButton;
}

#pragma mark - Public
- (void)keyboardResignFirstResponder
{
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

- (void)keyboardBecomeFirstResponder
{
    [self.textView becomeFirstResponder];
}

- (void)setTextViewContent:(NSString *)text
{
    self.textView.text = text;
    self.sendButton.enabled = text.length;
}

- (void)clearTextViewContent
{
    self.textView.text = @"";
    self.sendButton.enabled = NO;
}

- (void)setTextViewPlaceHolder:(NSString *)placeholder
{
    if (placeholder == nil) {
        return;
    }
    self.textView.placeHolder = placeholder;
}

- (void)setTextViewPlaceHolderColor:(UIColor *)placeHolderColor
{
    if (placeHolderColor == nil) {
        return;
    }
    self.textView.placeHolderTextColor = placeHolderColor;
}
@end
