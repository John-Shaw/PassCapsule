//
//  PCCloudEntry.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/16.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface PCCloudEntry : AVObject<AVSubclassing>
@property (nonatomic, copy) NSString  *entry_id;
@property (nonatomic, copy) NSString  *title;
@property (nonatomic, copy) NSString  *password;
@property (nonatomic, copy) NSString  *site;
@property (nonatomic, copy) NSString  *account;
@property (nonatomic, copy) NSString  *iconName;
@property (nonatomic, copy) NSString  *group;

+ (NSString *)parseClassName;
@end
