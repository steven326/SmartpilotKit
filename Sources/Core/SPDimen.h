//
//  SPDimen.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/9.
//

#ifndef SPDimen_h
#define SPDimen_h

/// 字体
#define YJ_FONT(fontSize) [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular]
#define YJ_FONT_SEMIBOLD(fontSize) [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold]

/// Log
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#define NSLog(FORMAT, ...);
#else
#define NSLog(FORMAT, ...);
#endif

/// Document文件路径
#define PATH_DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/// Cache文件路径
#define PATH_CACHE [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/// 照片缓存路径
#define PATH_PHOTO_CACHE [PATH_DOCUMENT stringByAppendingPathComponent:@"smartpilot.photos"]

/// plist缓存路径
#define PATH_PLIST_CACHE [PATH_CACHE stringByAppendingPathComponent:@"smartpilot.plists"]

/// 下载资料缓存路径
#define PATH_FILE_CACHE [PATH_CACHE stringByAppendingPathComponent:@"smartpilot.files"]

#define kPageSize 10

#pragma mark -
#pragma mark - 第三方信息

#define RCIM_APPKEY @"8w7jv4qb83gmy" // release 8w7jv4qb83gmy / debug mgb7ka1nmdopg

#define AMapAppKey @"ce2f1b11c28cc3f1af3b654691d2215a"

#define UM_APPKEY @"5d8b58860cafb22345001134"

#define AES_KEY @"7f320b77e441bcd9f3df613345c6b42e"

#endif /* SPDimen_h */
