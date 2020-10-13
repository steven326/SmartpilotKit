//
//  SPMomentMapViewController.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPMomentMapViewController : UIViewController

/// 经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/// 定位地址
@property (nonatomic, strong) NSString *locationTitle;

@end

NS_ASSUME_NONNULL_END
