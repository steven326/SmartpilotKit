//
//  SDTimeLineCellOperationMenu.h
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/4/2.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDTimeLineCellOperationMenu : UIView

@property (nonatomic, assign, getter = isShowing) BOOL show;

@property (nonatomic, copy) void (^likeButtonClickedOperation)(BOOL isLike);
@property (nonatomic, copy) void (^commentButtonClickedOperation)(void);

@property (nonatomic, assign) BOOL is_like;

@end
