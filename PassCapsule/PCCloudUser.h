//
//  PCCloudUser.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/13.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCCloudUser : NSObject

- (void)registerUserWithUserName: (NSString *)username
                        Password:(NSString *)password
                 andOtherOptions: (NSDictionary *)otherOptions;

- (void)validUserWithUserName: (NSString *)username andPassword:(NSString *)password;

@end
