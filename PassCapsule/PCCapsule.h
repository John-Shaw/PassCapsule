//
//  PCCapsule.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/6.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const CAPSULE_ROOT     = @"Capsules";
static NSString * const CAPSULE_ENTRY    = @"Capsule";
static NSString * const CAPSULE_ID       = @"id";
static NSString * const CAPSULE_TITLE    = @"title";
static NSString * const CAPSULE_ACCOUNT  = @"account";
static NSString * const CAPSULE_PASSWORD = @"pass";
static NSString * const CAPSULE_SITE     = @"site";
static NSString * const CAPSULE_GROUP    = @"category";
static NSString * const CAPSULE_ICON     = @"icon";


@interface PCCapsule : NSObject

@property (nonatomic, readwrite) NSInteger capsuleID;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *pass;
@property (nonatomic, strong) NSString  *site;
@property (nonatomic, strong) NSString  *account;
@property (nonatomic, strong) NSString  *iconName;
@property (nonatomic, strong) NSString  *category;


@end
