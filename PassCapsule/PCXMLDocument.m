//
//  PCXMLDocument.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/15.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCXMLDocument.h"

@implementation PCXMLDocument

-(void)createDocument:(NSString *)documentName WithMasterKey:(NSData *)masterKey{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:documentName];
    
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    if (fileExists) {
        
    }else{
        DDXMLElement *rootElement = [[DDXMLElement alloc] initWithName:@"Capsules"];
        DDXMLElement *masterKeyElement = [[DDXMLElement alloc] initWithName:@"MasterKey"];
        [masterKeyElement addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:@"0"]];
        [masterKeyElement setStringValue:[masterKey base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        [rootElement addChild:masterKeyElement];
        
        DDXMLDocument *capsuleDocument = [[DDXMLDocument alloc] initWithXMLString:[rootElement XMLString] options:0 error:nil];
        
        
        [[capsuleDocument XMLData] writeToFile:filePath atomically:YES];
    }
    NSLog(@"file path = %@",filePath);
    
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len{
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}


@end
