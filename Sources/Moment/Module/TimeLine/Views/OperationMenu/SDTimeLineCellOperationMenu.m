//
//  SDTimeLineCellOperationMenu.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/4/2.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "SDTimeLineCellOperationMenu.h"
#import "UIView+SDAutoLayout.h"

@implementation SDTimeLineCellOperationMenu
{
    UIButton *_likeButton;
    UIButton *_commentButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = Color_BlackText;
    
    _likeButton = [self creatButtonWithTitle:@"赞" selTitle:@"取消" image:[UIImage imageNamed:@"AlbumLike"] selImage:nil target:self selector:@selector(likeButtonClicked)];
    _commentButton = [self creatButtonWithTitle:@"评论" selTitle:nil image:[UIImage imageNamed:@"AlbumComment"] selImage:nil target:self selector:@selector(commentButtonClicked)];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = [UIColor grayColor];
    
    [self sd_addSubviews:@[_likeButton, _commentButton, centerLine]];
    
    CGFloat margin = 5;
    
    _likeButton.sd_layout
    .leftSpaceToView(self, margin)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(80);
    
    centerLine.sd_layout
    .leftSpaceToView(_likeButton, margin)
    .topSpaceToView(self, margin)
    .bottomSpaceToView(self, margin)
    .widthIs(1);
    
    _commentButton.sd_layout
    .leftSpaceToView(centerLine, margin)
    .topEqualToView(_likeButton)
    .bottomEqualToView(_likeButton)
    .widthRatioToView(_likeButton, 1);
}

- (UIButton *)creatButtonWithTitle:(NSString *)title selTitle:(NSString *)selTitle image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:selTitle forState:UIControlStateSelected];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}

- (void)likeButtonClicked
{
    self.is_like = !self.is_like;
    
    CGFloat duration = .5;
    
    /// 点赞动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@1.4, @1.0];
    animation.duration = duration;
    animation.calculationMode = kCAAnimationCubic;
    [_likeButton.imageView.layer addAnimation:animation forKey:@"transform.scale"];
    
    /// 点赞动画结束后，刷新页面
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
        self.show = NO;
        if (self.likeButtonClickedOperation) {
            self.likeButtonClickedOperation(self.is_like);
        }
    });
}

- (void)commentButtonClicked
{
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
    self.show = NO;
}

- (void)setShow:(BOOL)show
{
    _show = show;
    
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (!show) {
            [self clearAutoWidthSettings];
            self.sd_layout.widthIs(0);
        } else {
            self.fixedWidth = nil;
            [self setupAutoWidthWithRightView:self->_commentButton rightMargin:5];
        }
        [self updateLayoutWithCellContentView:self.superview];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setIs_like:(BOOL)is_like
{
    _is_like = is_like;
    _likeButton.selected = _is_like;
}

@end
