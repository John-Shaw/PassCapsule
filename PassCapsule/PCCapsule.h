//
//  PCCapsule.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/6.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const CAPSULE_ROOT           = @"Capsules";
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
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *password;
@property (nonatomic, strong) NSString  *site;
@property (nonatomic, strong) NSString  *account;
@property (nonatomic, strong) NSString  *iconName;
@property (nonatomic, strong) NSString  *group;

- (NSString *)decrptedPassword;


@end
