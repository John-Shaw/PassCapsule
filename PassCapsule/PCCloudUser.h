//
//  PCCloudUser.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/13.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

static NSString * const CLOUD_DATABASE_ID     = @"cloudDatabaseID";

@interface PCCloudUser : NSObject

- (void)registerUserWithUserName: (NSString *)username
                        Password: (NSString *)password
                 andOtherOptions: (NSDictionary *)otherOptions;

- (AVUser *)validUserWithUserName: (NSString *)username
                  andPassword: (NSString *)password;

- (AVUser *)currentUser;

+ (void)saveCloudDatabaseID: (NSString *)cloudDatabaseID;
+ (NSString *)cloudDatabaseID;
@end
