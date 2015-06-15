//
//  PCXMLDocument.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/15.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCXMLDocument.h"

@implementation PCXMLDocument

-(void)createWithMasterKey:(NSString *)masterKey{

    
    DDXMLElement *rootElement = [[DDXMLElement alloc] initWithName:@"Capsules"];
    DDXMLElement *masterKeyElement = [[DDXMLElement alloc] initWithName:@"MasterKey"];
    [masterKeyElement addAttribute:[DDXMLNode attributeWithName:@"id" stringValue:@"0"]];
    [masterKeyElement setStringValue:masterKey];
    [rootElement addChild:masterKeyElement];
    
    
    DDXMLDocument *capsuleDocument = [[DDXMLDocument alloc] initWithXMLString:[rootElement XMLString] options:0 error:nil];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"JohnShaw.pcdb"];
    
    [[capsuleDocument XMLData] writeToFile:filePath atomically:YES];
    NSLog(@"path = %@",filePath);
    
}


@end
