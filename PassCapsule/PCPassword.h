//
//  PCPassword.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/26.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCPassword : NSObject

+ (NSData *)encryptedDataWithPassword:(NSString *)password;
+ (NSString *)encryptedStringWithPassword:(NSString *)password;
+ (NSString *)decryptedStringWithPassword:(NSString *)password;
+ (NSString *)masterKey;

@end
