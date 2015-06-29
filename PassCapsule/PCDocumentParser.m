//
//  PCDocumentParser.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/29.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCDocumentParser.h"
#include "PCCapsule.h"
#include "PCDocumentDatabase.h"

@implementation PCDocumentParser

- (void)parser:(NSData *)xmlData{
    DDXMLDocument *document = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    PCDocumentDatabase *databse = [PCDocumentDatabase sharedDocumentDatabase];
    NSArray *capsules = [document nodesForXPath:@"//Capsule" error:nil];
    for (DDXMLElement *capsule in capsules) {
        NSArray *entries = [capsule children];
        PCCapsule *aCapsule = [PCCapsule new];
        for (DDXMLNode *e in entries) {
            if ([e.name isEqualToString:CAPSULE_TITLE]) {
                aCapsule.title = e.stringValue;
            }
            if ([e.name isEqualToString:CAPSULE_ACCOUNT]) {
                aCapsule.account = e.stringValue;
            }
            if ([e.name isEqualToString:CAPSULE_PASSWORD]) {
                aCapsule.pass = e.stringValue;
            }
            if ([e.name isEqualToString:CAPSULE_SITE]) {
                aCapsule.site = e.stringValue;
            }
            if ([e.name isEqualToString:CAPSULE_ICON]) {
                aCapsule.iconName = e.stringValue;
            }
            if ([e.name isEqualToString:CAPSULE_GROUP]) {
                aCapsule.category = e.stringValue;
            }
        }
        if (aCapsule) {
            [databse.entries addObject:aCapsule];
        }
    }
    
}

@end
