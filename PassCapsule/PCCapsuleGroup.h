//
//  PCCapsuleGroup.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/29.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCCapsule.h"

static NSString * const CAPSULE_GROUP      = @"group";
static NSString * const CAPSULE_GROUP_NAME = @"group_name";
static NSString * const CAPSULE_GROUP_DEFAULT = @"未分类";
static NSString * const CAPSULE_GROUP_WEBACCOUNT = @"网站账户";
static NSString * const CAPSULE_GROUP_EMAIL = @"电子邮件";
static NSString * const CAPSULE_GROUP_CARD= @"银行卡";

typedef NS_ENUM(NSUInteger, PCGroupType) {
    PCGroupTypeDefault,
    PCGroupTypeWebAccout,
    PCGroupTypeEmail,
    PCGroupTypeCard
};

@interface PCCapsuleGroup : NSObject

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, strong) NSMutableArray *groupEntries;

@property (nonatomic, strong) NSString *cloudID;

@end
