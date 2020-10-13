//
//  SPDelegationFactory.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/10/10.
//

#import "SPDelegationFactory.h"
#import "SPMomentConfig.h"
@implementation SPDelegationFactory

+ (SPDelegationProxy *)dataSourceProxy
{
    SPDelegationProxy *delegation = [[SPDelegationProxy alloc] init];
    delegation.protocol = @protocol(SPMomentDataSource);
    return delegation;
}

+ (SPDelegationProxy *)delegateProxy
{
    SPDelegationProxy *delegation = [[SPDelegationProxy alloc] init];
    delegation.protocol = @protocol(SPMomentDelegate);
    return delegation;
}

@end
