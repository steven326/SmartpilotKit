//
//  SPDelegationFactory.h
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/10.
//

#import <Foundation/Foundation.h>
#import "SPDelegationProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPDelegationFactory : NSObject

+ (SPDelegationProxy *)dataSourceProxy;
+ (SPDelegationProxy *)delegateProxy;

@end

NS_ASSUME_NONNULL_END
