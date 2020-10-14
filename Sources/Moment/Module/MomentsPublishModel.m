//
//  MomentsPublishModel.m
//  YangJiang
//
//  Created by 王泽平 on 2019/9/5.
//  Copyright © 2019 smartpilot. All rights reserved.
//

#import "MomentsPublishModel.h"

@implementation MomentsPublishPhotoModel

@end

@implementation MomentsPublishModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
             @"photos":[MomentsPublishPhotoModel class],
             };
}

@end
