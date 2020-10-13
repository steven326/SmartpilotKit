//
//  SnapshotsListModel.m
//  YangJiang
//
//  Created by 王泽平 on 2019/9/27.
//  Copyright © 2019 smartpilot. All rights reserved.
//

#import "SnapshotsListModel.h"

@implementation SnapshotsListModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"pictures":[MomentsPicturesModel class],
             };
}

@end
