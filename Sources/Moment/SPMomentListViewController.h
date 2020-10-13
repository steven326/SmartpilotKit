//
//  SPMomentListViewController.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/10.
//

#import <UIKit/UIKit.h>
#import "SPDelegationFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPMomentListViewController : UIViewController

/// 数据源
@property (nonatomic, weak) id<SPMomentDataSource> dataSource;
/// 代理
@property (nonatomic, weak) id<SPMomentDelegate> delegate;

/// 刷新数据
- (void)reloadData;

@end


NS_ASSUME_NONNULL_END
