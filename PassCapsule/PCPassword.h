//
//  PCPassword.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/26.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCPassword : NSObject

+ (NSString *)password;
+ (void)setPassword:(NSString *)password;
+ (NSData *)encryptedData:(NSString *)password;
+ (NSData *)encryptedData:(NSString *)password WithKey:(NSString *)key;
+ (NSString *)encryptedString:(NSString *)password;
+ (NSString *)decryptedString:(NSString *)encryptedString;
+ (NSString *)decryptedString:(NSString *)encryptedString  WithKey:(NSString *)key;
//+ (NSString *)masterKey;

#pragma mark - from miniKeePass

+ (BOOL)validatePassword:(NSString *)password againstHash:(NSString *)hash;

+ (NSData *)generateSaltOfSize:(NSInteger)size;
+ (NSString *)hashPassword:(NSString *)password withSalt:(NSData *)salt andRounds:(NSUInteger)rounds andKeySize:(NSInteger)keySize;
+ (NSString *)hashPassword:(NSString *)password;
+ (NSData *)dataFromHexString:(NSString *)string;
+ (NSString *)hexStringFromData:(NSData *)data;
@end
