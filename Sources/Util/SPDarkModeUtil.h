//
//  SPDarkModeUtil.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPDarkModeUtil : NSObject

/// 一般文字颜色
+ (UIColor *)normalTextColor;
/// 一般文字高亮颜色
+ (UIColor *)normalTextHighlightColor;
/// 港航圈深蓝标题颜色
+ (UIColor *)momentTitleColor;
/// 港航圈深蓝副标题颜色
+ (UIColor *)momentSubTitleColor;
/// 港航圈item背景颜色
+ (UIColor *)momentCellBackgroundColor;
/// 港航圈item拆分线颜色
+ (UIColor *)momentSepratorColor;
/// 深色模式下的蓝色
+ (UIColor *)blueDarkmodeColor;
/// 占位颜色
+ (UIColor *)holderTextColor;
/// 弹窗背景色
+ (UIColor *)dialogBackgroundColor;
@end

NS_ASSUME_NONNULL_END
