//
//  SPUtils.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/9/30.
//

#import "SPUtils.h"

@implementation SPUtils

#pragma mark -
#pragma mark - Toast

+ (void)showToastWithMessage:(NSString *)message
{
    [SPUtils showToastWithMessage:message duration:2.0 view:UIApplication.sharedApplication.keyWindow];
}

+ (void)showToastWithMessage:(NSString *)message view:(UIView *)view
{
    [SPUtils showToastWithMessage:message duration:2.0 view:view];
}

+ (void)showToastWithMessage:(NSString *)message duration:(NSTimeInterval)duration view:(UIView *)view
{
    [view hideAllToasts];
    [view makeToast:message duration:duration position:CSToastPositionCenter];
}

+ (void)showToastWithStatusCode:(long)statusCode
{
    NSString *msg = @"网络异常";
    switch (statusCode) {
        case 400:
        {
            msg = @"错误请求";
        }
            break;
        case 401:
        {
            msg = @"未授权";
        }
            break;
        case 403:
        {
            msg = @"禁止访问";
        }
            break;
        case 404:
        {
            msg = @"请求失败";
        }
            break;
        case 405:
        {
            msg = @"请求错误";
        }
            break;
        case 500:
        {
            msg = @"服务器异常";
        }
            break;
        case 502:
        {
            msg = @"Bad Gateway";
        }
            break;
        default:
            break;
    }
    [SPUtils showToastWithMessage:msg duration:2.0 view:SPUtils.topViewController.view];
}

#pragma mark -
#pragma mark - ImageBrowser

+ (void)showImageBrowserWithDataSourceArray:(NSArray<id<YBIBDataProtocol>> *)dataSourceArray
                                currentPage:(NSInteger)currentPage
{
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = dataSourceArray;
    browser.currentPage = currentPage;
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser show];
}

/// 收起键盘
+ (void)dismissKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

+ (UIViewController *)topViewController
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

+ (NSString *)legalFileNameWithName:(NSString *)name path:(NSString *)path
{
    NSString *file = [path stringByAppendingPathComponent:name];
    if ([NSFileManager.defaultManager fileExistsAtPath:file]) {
        NSArray *classArray = [name componentsSeparatedByString:@"."];
        NSString *fileClass = [classArray lastObject];
        NSString *fileName = [classArray firstObject];
        NSArray *array = [fileName componentsSeparatedByString:@"-"];
        fileName = @"";
        if (array.count > 1 && [[array lastObject] intValue] > 0) {
            for (int i = 0; i < array.count-1; i++) {
                if (i > 0) {
                    fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@"-%@",[array objectAtIndex:i]]];
                }
                else {
                    fileName = [array objectAtIndex:0];
                }
            }
            name = [fileName stringByAppendingString:[NSString stringWithFormat:@"-%d.%@",[[array lastObject] intValue]+1,fileClass]];
        }
        else {
            name = [fileName stringByAppendingString:[NSString stringWithFormat:@"%@-1.%@",[array firstObject],fileClass]];
        }
        return [self legalFileNameWithName:name path:path];
    }
    else {
        return name;
    }
}

+ (CGSize)getContentSizeWithText:(NSString *)text
                            size:(CGSize)size
                        fontSize:(CGFloat)fontSize
                     lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyles setLineSpacing:lineSpacing];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyles};
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}
@end
