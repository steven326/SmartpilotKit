//
//  SPDarkModeUtil.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/9.
//

#import "SPDarkModeUtil.h"

#define YJUserInterfaceStyleColor(dark, light) UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? dark : light;

@implementation SPDarkModeUtil

+ (UIColor *)normalTextColor
{
    if (@available(iOS 13.0, *)) {
        return YJUserInterfaceStyleColor(UIColor.whiteColor, Color_BlackText);
    }
    else {
        return Color_BlackText;
    }
}

+ (UIColor *)normalTextHighlightColor
{
    if (@available(iOS 13.0, *)) {
        return YJUserInterfaceStyleColor(UIColor.blackColor, Color_BackGroundGray);
    }
    else {
        return Color_BackGroundGray;
    }
}

+ (UIColor *)momentTitleColor
{
    if (@available(iOS 13.0, *)) {
        return YJUserInterfaceStyleColor(UIColor.whiteColor, Color_BlueDarkText);
    }
    else {
        return Color_BlueDarkText;
    }
}

+ (UIColor *)momentSubTitleColor
{
    if (@available(iOS 13.0, *)) {
        return YJUserInterfaceStyleColor(Color_BlueLine, Color_BlueTextHolder);
    }
    else {
        return Color_BlueTextHolder;
    }
}

+ (UIColor *)momentCellBackgroundColor
{
    if (@available(iOS 13.0, *)) {
        return YJUserInterfaceStyleColor(Color_DarkMode_Black, UIColor.whiteColor);
    }
    else {
        return UIColor.whiteColor;
    }
}

+ (UIColor *)momentSepratorColor
{
    if (@available(iOS 13.0, *)) {
        return YJUserInterfaceStyleColor(UIColor.blackColor, Color_BackGroundGray);
    }
    else {
        return Color_BackGroundGray;
    }
}

+ (UIColor *)blueDarkmodeColor
{
    if (@available(iOS 13.0, *)) {
        return YJUserInterfaceStyleColor(Color_ButtonBackground, Color_BlueText);
    }
    else {
        return Color_BlueText;
    }
}

+ (UIColor *)holderTextColor
{
    if (@available(iOS 13.0, *)) {
        return YJUserInterfaceStyleColor(Color_BlueTextHolder, Color_BlueText);
    }
    else {
        return Color_BlueText;
    }
}

+ (UIColor *)dialogBackgroundColor
{
    if (@available(iOS 13.0, *)) {
        return YJUserInterfaceStyleColor(Color_DarkMode_Black, UIColor.whiteColor);
    }
    else {
        return UIColor.whiteColor;
    }
}

@end
