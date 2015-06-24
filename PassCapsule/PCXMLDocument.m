//
//  PCXMLDocument.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/15.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCXMLDocument.h"
#import "RNENcryptor.h"
#import "RNDecryptor.h"
#import "DDXML.h"
#import "PCKeyChainCapsule.h"

@interface PCXMLDocument ()

@property (nonatomic,strong) NSData *testEncryptData;

@end

@implementation PCXMLDocument

- (void)createDocument:(NSString *)documentName WithMasterPassword:(NSString *)masterPassword{
    
    NSString *randomKey = [self randomStringWithLength:arc4random()%48+16];
    [PCKeyChainCapsule setString:randomKey forKey:@"masterKey" andServiceName:KEYCHAIN_KEY_SERVICE];
    
    NSData *data = [masterPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSData *encryptedData = [RNEncryptor encryptData:data
                                        withSettings:kRNCryptorAES256Settings
                                            password:randomKey
                                               error:&error];
    NSString* encryptedPassword = [encryptedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [PCKeyChainCapsule setString:encryptedPassword forKey:@"masterPassword" andServiceName:KEYCHAIN_PASSWORD_SERVICE];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:documentName];
    
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    if (fileExists) {
        NSLog(@"file is existed in path = %@",filePath);
    }else{
        DDXMLElement *rootElement = [[DDXMLElement alloc] initWithName:@"Capsules"];
        DDXMLElement *masterKeyElement = [[DDXMLElement alloc] initWithName:@"MasterKey"];
        [masterKeyElement addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:@"0"]];
        [masterKeyElement setStringValue:encryptedPassword];
        [rootElement addChild:masterKeyElement];
        
//        self.testEncryptData = [[NSData alloc] initWithBase64EncodedString:[masterKeyElement stringValue] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        DDXMLDocument *capsuleDocument = [[DDXMLDocument alloc] initWithXMLString:[rootElement XMLString] options:0 error:nil];
        [[capsuleDocument XMLData] writeToFile:filePath atomically:YES];
    }
//    NSLog(@"file path = %@",filePath);
//    [self testDecypyt];
}

//- (void)creatKey:(NSString *)encryptionText{
//    NSString *randomKey = [self randomStringWithLength:32];
//    [PCKeyChainCapsule setString:randomKey forKey:@"MasterKey" andServiceName:KEYCHAIN_KEY_SERVICE];
//    
//}


- (void)testDecypyt{
    NSData *decryptData = [RNDecryptor decryptData:self.testEncryptData
                                      withPassword:@"test"
                                             error:nil];
    NSString *decryptString = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
    NSLog(@"decrypt string is %@",decryptString);
}


NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*()_+`-=[]\\;',./{}|:\"<>?";

- (NSString *) randomStringWithLength: (int)len{
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
    
//另一种方案
//    char data[NUMBER_OF_CHARS];
//    for (int x=0;x<NUMBER_OF_CHARS;data[x++] = (char)('A' + (arc4random_uniform(26))));
//    return [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
//
//

    //第三种方案
//    NSTimeInterval  today = [[NSDate date] timeIntervalSince1970];
//    NSString *intervalString = [NSString stringWithFormat:@"%f", today];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[intervalString doubleValue]];
//    
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyyMMddhhmm"];
//    NSString *strdate=[formatter stringFromDate:date];
}


@end
