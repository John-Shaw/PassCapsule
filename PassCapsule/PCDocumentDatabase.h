//
//  PCDocumentDatabase.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/25.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCCapsule.h"
#import "PCCapsuleGroup.h"
@class DDXMLDocument;

static NSString * const NOTIFICATION_SHOULD_RELOAD = @"didLoadData";
static NSString * const USERDEFAULT_DATABASE_CREATE = @"isCreateDatabase";
static NSString * const USERDEFAULT_DOCUMENT_NAME = @"documentName";
static NSString * const USERDEFAULT_CURRENT_ID = @"currentID";

@interface PCDocumentDatabase : NSObject

+(instancetype)sharedDocumentDatabase;
+ (void)setDocumentName:(NSString *)documentName;
+ (NSString *)documentPath;

@property (nonatomic, strong) DDXMLDocument *document;
@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, getter=isLoad) BOOL loadDocument;
@property (nonatomic, getter=shouldRefresh) BOOL refreshDocument;
@property (nonatomic, readwrite) NSUInteger currentID;

- (NSUInteger)autoIncreaseID;

/**
 Should create only one instance of class. Should not call init.
 */
- (instancetype)init	__attribute__((unavailable("init is not available in PCXMLParser, Use sharedXMLParser"))) NS_DESIGNATED_INITIALIZER;

/**
 Should create only one instance of class. Should not call new.
 */
+ (instancetype)new	__attribute__((unavailable("new is not available in PCXMLParser, Use sharedXMLParser")));


@end
