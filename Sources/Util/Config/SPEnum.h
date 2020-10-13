//
//  SPEnum.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/9/30.
//

#ifndef SPEnum_h
#define SPEnum_h

typedef NS_ENUM(NSUInteger, YJEnviromentType) {
    ///生产环境
    YJEnviromentRelease = 0,
    ///测试环境
    YJEnviromentTest = 1,
    ///开发环境
    YJEnviromentDevelopment = 2,
};

typedef NS_ENUM(NSUInteger, SPFileMimeType) {
    ///PDF类型
    SPFileMimeTypePDF = 1,
    ///PNG类型
    SPFileMimeTypePNG,
};

typedef NS_ENUM(NSUInteger, SPChoicesDialogViewType) {
    ///图片+文字
    SPChoicesDialogViewTypeText = 1,
    ///自定义视图
    SPChoicesDialogViewTypeCustomView,
    ///纯文字
    SPChoicesDialogViewTypeTextOnly,
    ///自定义视图+知道了
    SPChoicesDialogViewTypeCustomViewKnown,
    ///图片+文字+知道了
    SPChoicesDialogViewTypeTextKnown,
    ///图片+文字+知道了+取消
    SPChoicesDialogViewTypeTextKnownCancel,
    ///文字+自定义视图
    SPChoicesDialogViewTypeTextAndCustomView,
};

#endif /* SPEnum_h */
