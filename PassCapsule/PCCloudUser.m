//
//  PCCloudUser.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/13.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCCloudUser.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation PCCloudUser

- (void)registerUserWithUserName: (NSString *)username
                        Password:(NSString *)password
                 andOtherOptions: (NSDictionary *)otherOptions{
    AVUser *aUser = [AVUser user];
    aUser.username = username;
    aUser.password = password;
    
    if (otherOptions) {
        aUser.email = otherOptions[@"email"];
        [aUser setObject:otherOptions[@"phone"] forKey:@"phone"];
    }
    [aUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"user %@ register success !",username);
        } else {
            NSLog(@"user %@ register error !",username);
        }
    }];
}

- (void)validUserWithUserName:(NSString *)username andPassword:(NSString *)password{
    [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            
        } else {
            
        }
    }];
}

@end
