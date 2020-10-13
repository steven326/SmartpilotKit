//
//  MomentsListModel.m
//  YangJiang
//
//  Created by 王泽平 on 2019/9/5.
//  Copyright © 2019 smartpilot. All rights reserved.
//

#import "MomentsListModel.h"

@implementation MomentsPicturesModel

@end

@implementation MomentsLikeUsersModel

@end

@implementation MomentsCommentsModel

@end

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;

@implementation MomentsListModel
{
    CGFloat _lastContentWidth;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"pictures":[MomentsPicturesModel class],
             @"like_users":[MomentsLikeUsersModel class],
             @"comments":[MomentsCommentsModel class],
             };
}

- (NSString *)content
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 55;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
            self.contentLabelFrame = CGRectMake(30.f, 72.f, contentW, maxContentLabelHeight);
        }
        else {
            _shouldShowMoreButton = NO;
            self.contentLabelFrame = CGRectMake(30.f, 72.f, contentW, textRect.size.height);
        }
    }
    return _content;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    }
    else {
        _isOpening = isOpening;
    }
}

@end
