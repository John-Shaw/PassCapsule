//
//  PCCapsule.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/6.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const CAPSULE_ROOT           = @"Capsules";
static NSString * const CAPSULE_CLOUD_ID       = @"cloudID";
static NSString * const CAPSULE_ENTRY          = @"entry";
static NSString * const CAPSULE_ENTRY_ID       = @"entry_id";
static NSString * const CAPSULE_ENTRY_TITLE    = @"title";
static NSString * const CAPSULE_ENTRY_ACCOUNT  = @"account";
static NSString * const CAPSULE_ENTRY_PASSWORD = @"password";
static NSString * const CAPSULE_ENTRY_SITE     = @"site";
static NSString * const CAPSULE_ENTRY_GROUP    = @"entry_group";
static NSString * const CAPSULE_ENTRY_ICON     = @"icon";



@interface PCCapsule : NSObject

@property (nonatomic, readwrite) NSUInteger capsuleID;
@property (nonatomic, copy) NSString  *title;
@property (nonatomic, copy) NSString  *password;
@property (nonatomic, copy) NSString  *site;
@property (nonatomic, copy) NSString  *account;
@property (nonatomic, copy) NSString  *iconName;
@property (nonatomic, copy) NSString  *group;

@property (nonatomic, strong) NSString  *cloudID;

- (NSString *)decrptedPassword;
- (NSString *)idString;


@end
