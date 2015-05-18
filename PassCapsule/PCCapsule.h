//
//  PCCapsule.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/6.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCCapsule : NSObject

@property (nonatomic, readwrite) NSInteger capsuleID;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *pass;
@property (nonatomic, strong) NSString  *site;
@property (nonatomic, strong) NSString  *account;
@property (nonatomic, strong) NSString  *iconName;
@property (nonatomic, strong) NSString  *category;

@end
