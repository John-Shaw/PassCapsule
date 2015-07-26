//
//  PCCloudGroup.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/16.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

static NSString *const kGroupEntries = @"groupEntries";

@interface PCCloudGroup : AVObject<AVSubclassing>
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, strong) NSMutableArray *groupEntries;

+ (NSString *)parseClassName;
@end
