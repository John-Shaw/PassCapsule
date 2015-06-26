//
//  PCPassword.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/26.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCPassword.h"
#import "PCKeyChainCapsule.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

@implementation PCPassword

+ (NSData *)encryptedDataWithPassword:(NSString *)password{

    NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:[self masterKey]
                                               error:&error];
    return encryptedData;
}

+ (NSString *)encryptedStringWithPassword:(NSString *)password{
    NSData *encryptedData = [self encryptedDataWithPassword:password];
    NSString* encryptedPassword = [encryptedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"user encrpyt pass  =  %@",encryptedPassword);
    return encryptedPassword;
}

+ (NSString *)decryptedStringWithPassword:(NSString *)password{
    NSString *key = [self masterKey];
    NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:password options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [RNDecryptor decryptData:encryptedData
                                      withPassword:key
                                             error:nil];
    NSString *decryptString = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    return decryptString;
}

+ (NSString *)masterKey{
    NSString *base64key = [PCKeyChainCapsule stringForKey:KEYCHAIN_KEY andServiceName:KEYCHAIN_KEY_SERVICE];
    NSData *datakey = [[NSData alloc] initWithBase64EncodedString:base64key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *key = [[NSString alloc] initWithData:datakey encoding:NSUTF8StringEncoding];
    NSLog(@"get key from keychain =  %@",base64key);
    NSLog(@"origin key =  %@",key);
    return key;
}

@end
