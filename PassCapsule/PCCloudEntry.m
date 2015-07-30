//
//  PCCloudEntry.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/16.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCCloudEntry.h"

@implementation PCCloudEntry
@dynamic entry_id,title,password,site,account,iconName,group,cloud_id;
+ (NSString *)parseClassName {
    return @"PCCloudEntry";
}
@end
