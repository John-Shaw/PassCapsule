//
//  PCXMLDocument.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/15.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCDocumentManager.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"
#import "DDXML.h"
#import "PCKeyChainUtils.h"
#import "PCPassword.h"
#import "PCCapsule.h"


#import "PCCloudManager.h"

@interface PCDocumentManager ()

@end

@implementation PCDocumentManager
+(instancetype)sharedDocumentManager{
    static PCDocumentManager *kManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        kManager = [[self alloc] init];
    });
    return kManager;
}

- (PCDocumentDatabase *)documentDatabase{
    if (!_documentDatabase) {
        _documentDatabase = [PCDocumentDatabase sharedDocumentDatabase];
    }
    return _documentDatabase;
}

/**
 *  创建密码库文件
 *
 *  @param documentName   文件名
 *  @param masterPassword 主密码
 *
 *  @return 创建是否成功
 */
- (BOOL)createDocument:(NSString *)databaseName WithMasterPassword:(NSString *)masterPassword{

    [PCPassword setPassword:masterPassword];
    [PCDocumentDatabase setDocumentName:databaseName];
    
    NSString *hashPassword = [PCPassword hashPassword:masterPassword];
    NSLog(@"hashPassword  =  %@",hashPassword);
    NSString *basePassowrd = [[hashPassword dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [PCKeyChainUtils setString:basePassowrd forKey:KEYCHAIN_PASSWORD andServiceName:KEYCHAIN_PASSWORD_SERVICE];


    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *documentName = [PCDocumentDatabase documentName];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:documentName];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    

    
    if (fileExists) {
        NSLog(@"file is existed in path = %@",filePath);
        return NO;
    }else{
        DDXMLDocument *capsuleDocument = [self baseTreeWithPassword:masterPassword];
        [[capsuleDocument XMLData] writeToFile:filePath atomically:YES];
        
        AVUser *user = [AVUser currentUser];
        if (user) {
            [[PCCloudManager sharedCloudManager] createCloudDatabaseWithDatabase:[PCDocumentDatabase sharedDocumentDatabase]];
        }
        [PCDocumentDatabase setLastModifyDate:[NSDate date]];
        return YES;
    }
    return NO;
}

- (BOOL)syncDocumentFormCloudWithUser: (AVUser *)user{
    if(user){
        NSString *cloudID = [user objectForKey:CLOUD_DATABASE_ID];
        if (cloudID) {
            PCCloudDatabase *cloudDatabase = [[PCCloudManager sharedCloudManager] queryCloudDatabaseByID:cloudID];
            AVFile *file = cloudDatabase.file;
            
            NSString *masterPassword = cloudDatabase.masterPassword;
            NSString *databaseName = cloudDatabase.name;
            
            [PCPassword setPassword:masterPassword];
            [PCDocumentDatabase setDocumentName:databaseName];
            
            NSString *hashPassword = [PCPassword hashPassword:masterPassword];
            NSString *basePassowrd = [[hashPassword dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [PCKeyChainUtils setString:basePassowrd forKey:KEYCHAIN_PASSWORD andServiceName:KEYCHAIN_PASSWORD_SERVICE];
        
            
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *documentName = [PCDocumentDatabase documentName];
            NSString *filePath = [documentsPath stringByAppendingPathComponent:documentName];
            
            NSData *xmlData = [file getData];
            [xmlData writeToFile:filePath atomically:YES];
            self.documentDatabase.document = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
            self.documentDatabase.loadDocument = YES;
            
            [PCDocumentDatabase setLastModifyDate:[NSDate date]];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USERDEFAULT_DATABASE_CREATE];
            return YES;
        }
    }
    return NO;
}

- (DDXMLDocument *)baseTreeWithPassword:(NSString *) password{
    DDXMLElement *rootElement = [[DDXMLElement alloc] initWithName:CAPSULE_ROOT];
    
    //!!!:测试用，把明文放到xml中，release时一定要记得删除这行
    DDXMLElement *masterKeyElement = [[DDXMLElement alloc] initWithName:@"MasterPassword"];
    [masterKeyElement addAttribute:[DDXMLNode attributeWithName:CAPSULE_ENTRY_ID stringValue:@"0"]];
    [masterKeyElement setStringValue:password];
    [rootElement addChild:masterKeyElement];
    
    DDXMLElement *databaseConfig = [[DDXMLElement alloc] initWithName:@"database"];
    [databaseConfig addAttribute:[DDXMLNode attributeWithName:@"database_cloud_id" stringValue:@""]];
    [databaseConfig setStringValue:@"config value for test"];
    [rootElement addChild:databaseConfig];
    
    NSArray *groups = @[CAPSULE_GROUP_DEFAULT,CAPSULE_GROUP_WEBACCOUNT,CAPSULE_GROUP_EMAIL,CAPSULE_GROUP_CARD];
    for (NSString *groupName in groups) {
        DDXMLElement *groupElement =  [DDXMLElement elementWithName:CAPSULE_GROUP];
        
        NSString *groupID = [[PCDocumentDatabase sharedDocumentDatabase] autoIncreaseIDString];
        [groupElement addAttribute:[DDXMLNode attributeWithName:CAPSULE_GROUP_ID stringValue:groupID]];
        [groupElement addAttribute:[DDXMLNode attributeWithName:CAPSULE_GROUP_NAME stringValue:groupName]];
        [groupElement addAttribute:[DDXMLNode attributeWithName:CAPSULE_CLOUD_ID stringValue:@""]];
        
//        NSArray *aCapsule = @[[DDXMLElement elementWithName:CAPSULE_ENTRY_TITLE stringValue:[NSString stringWithFormat:@"群组:%@",groupName]],
//                              [DDXMLElement elementWithName:CAPSULE_ENTRY_ACCOUNT stringValue:@"John Shaw"],
//                              [DDXMLElement elementWithName:CAPSULE_ENTRY_PASSWORD stringValue:@"fuck cracker"],
//                              [DDXMLElement elementWithName:CAPSULE_ENTRY_SITE stringValue:@"www.zerz.cn"],
//                              [DDXMLElement elementWithName:CAPSULE_ENTRY_GROUP stringValue:groupName]];
//        
//        NSString *entryID = [[PCDocumentDatabase sharedDocumentDatabase] autoIncreaseIDString];
//        
//        NSArray *attributes = @[[DDXMLNode attributeWithName:CAPSULE_ENTRY_ID stringValue:entryID]];
//        [groupElement addChild:[DDXMLElement elementWithName:CAPSULE_ENTRY children:aCapsule attributes:attributes]];
        
        [rootElement addChild:groupElement];
    }

    
    DDXMLDocument *capsuleDocument = [[DDXMLDocument alloc] initWithXMLString:[rootElement XMLString] options:0 error:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USERDEFAULT_DATABASE_CREATE];
    
    self.documentDatabase.document = capsuleDocument;
    self.documentDatabase.loadDocument = YES;
    return capsuleDocument;
}

//FIXME:什么鬼
- (BOOL)readDocument:(NSString *)documentPath withMasterPassword:(NSString *)masterPassword{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:documentPath];
    if (!fileExists) {
        NSLog(@"file not exits");
        return NO;
    }
    if ([masterPassword length] == 0) {
        NSLog(@"password is empty");
        return NO;
    }
    NSData *xmlData = [NSData dataWithContentsOfFile:documentPath];
    DDXMLDocument *document = nil;
    if (!self.documentDatabase.isLoad) {
        document = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    }
    self.documentDatabase.document = document;
    self.documentDatabase.loadDocument = YES;
    return YES;
}

- (void)preLoadDocunent:(NSData *)xmlData{
    dispatch_queue_t loadDocumentQueue = dispatch_queue_create(LOAD_DOCUMENT_QUEUE, NULL);
    dispatch_async(loadDocumentQueue, ^{
        DDXMLDocument *document = nil;
        if (!self.documentDatabase.isLoad) {
            document = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.documentDatabase.document = document;
            self.documentDatabase.loadDocument = YES;
        });
        
    });
    
}

- (void)parserDocument:(NSData *)xmlData{
    DDXMLDocument *document = nil;
    if (!self.documentDatabase.isLoad) {
        document = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
        self.documentDatabase.document = document;
        self.documentDatabase.loadDocument = YES;
    } else {
        document = self.documentDatabase.document;
    }
    NSArray *groups = [document nodesForXPath:@"//group" error:nil];
    //遍历group
    for (DDXMLElement *group in groups) {
        PCCapsuleGroup *aGroup = [PCCapsuleGroup new];
        aGroup.groupID = [[[group attributeForName:CAPSULE_GROUP_ID] stringValue] integerValue];
        aGroup.name = [[group attributeForName:CAPSULE_GROUP_NAME] stringValue];
        aGroup.cloudID = [[group attributeForName:CAPSULE_CLOUD_ID] stringValue];

        NSArray *entries = [group children];
        //遍历group中的每个entry
        for (DDXMLElement *entry in entries) {
            NSArray *aEntry = [entry children];
            PCCapsule *aCapsule = [PCCapsule new];
            
            //entry 的标志符
            aCapsule.cloudID = [[entry attributeForName:CAPSULE_CLOUD_ID] stringValue];
            aCapsule.capsuleID = [[[entry attributeForName:CAPSULE_ENTRY_ID] stringValue] integerValue];
            
            //遍历entry中的每个详细记录
            for (DDXMLNode *e in aEntry) {
                if ([e.name isEqualToString:CAPSULE_ENTRY_TITLE]) {
                    aCapsule.title = e.stringValue;
                }
                if ([e.name isEqualToString:CAPSULE_ENTRY_ACCOUNT]) {
                    aCapsule.account = e.stringValue;
                }
                if ([e.name isEqualToString:CAPSULE_ENTRY_PASSWORD]) {
                    aCapsule.password = e.stringValue;
                }
                if ([e.name isEqualToString:CAPSULE_ENTRY_SITE]) {
                    aCapsule.site = e.stringValue;
                }
                if ([e.name isEqualToString:CAPSULE_ENTRY_ICON]) {
                    aCapsule.iconName = e.stringValue;
                }
                if ([e.name isEqualToString:CAPSULE_ENTRY_GROUP]) {
                    aCapsule.group = e.stringValue;
                }
                if ([e.name isEqualToString:CAPSULE_CLOUD_ID]) {
                    aCapsule.cloudID = e.stringValue;
                }

            }
            //将entry反序列化到capsule对象后，保存到相关集合中
            //FIXME:额外在维护一个全部记录的数组，意义何在，有待考证
            [self.documentDatabase.entries addObject:aCapsule];
            [aGroup.entries addObject:aCapsule];
        }
        
        //保存group
        [self.documentDatabase.groups addObject:aGroup];
        
    }
    
}

#pragma mark - entry API
- (void)addNewEntry: (PCCapsule *)entry{
    if (self.documentDatabase.isLoad) {
        
        DDXMLDocument *document = self.documentDatabase.document;
        NSString *xpath = [NSString stringWithFormat:@"//group[@%@='%@']",
                           CAPSULE_GROUP_NAME,CAPSULE_GROUP_DEFAULT];
        NSArray *results = [document nodesForXPath:xpath error:nil];
        
        if ([results count] == 0) {
            NSLog(@"group name error");
            return;
        }
        
        //TODO:entry id 的设置与获取 － 通过 getter setter 还是 documentDatabase 的 currentID
        DDXMLElement *groupElement = [results firstObject];
        DDXMLElement *newEntry = [DDXMLElement elementWithName:CAPSULE_ENTRY];
        
        //id应该通过documentDatabase 的自动增长方法获取
        entry.capsuleID = [[PCDocumentDatabase sharedDocumentDatabase] autoIncreaseID];
        [newEntry addAttribute:[DDXMLNode attributeWithName:CAPSULE_ENTRY_ID stringValue:entry.idString]];
        //entry cloudID
        [newEntry addAttribute:[DDXMLNode attributeWithName:CAPSULE_CLOUD_ID stringValue:entry.cloudID]];
        
        //entry的子节点
        [newEntry addChild:[DDXMLElement elementWithName:CAPSULE_ENTRY_TITLE stringValue:entry.title]];
        [newEntry addChild:[DDXMLElement elementWithName:CAPSULE_ENTRY_ACCOUNT stringValue:entry.account]];
        [newEntry addChild:[DDXMLElement elementWithName:CAPSULE_ENTRY_PASSWORD stringValue:entry.password]];
        [newEntry addChild:[DDXMLElement elementWithName:CAPSULE_ENTRY_SITE stringValue:entry.site]];
        [newEntry addChild:[DDXMLElement elementWithName:CAPSULE_ENTRY_GROUP stringValue:entry.group]];
        [groupElement addChild:newEntry];
        
        [self.documentDatabase.entries addObject:entry];
        PCCapsuleGroup *group = self.documentDatabase.groups[PCGroupTypeDefault];
        [group.entries addObject:entry];
        
//        //sync cloudGroup
        PCCloudManager *manager = [PCCloudManager sharedCloudManager];
        PCCloudGroup *cloudGroup = (PCCloudGroup *)manager.cloudDatabase.cloudGroups[0];
        [cloudGroup addUniqueObject:[manager createCloudEntryWithEntry:entry] forKey:kGroupEntries];
        
        [PCDocumentDatabase setLastModifyDate:[NSDate date]];
        self.documentDatabase.refreshDocument = YES;
        [self saveDocument];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOULD_RELOAD object:nil];
    }
}

- (void)deleteEntry: (PCCapsule *)entry{
    if (self.documentDatabase.isLoad) {
        DDXMLDocument *document = self.documentDatabase.document;
        NSString *idString = [@(entry.capsuleID) stringValue];
        NSString *xpath = [NSString stringWithFormat:@"//group[@%@='%@']/entry[@%@='%@']"
                           ,CAPSULE_GROUP_NAME,CAPSULE_GROUP_DEFAULT,CAPSULE_ENTRY_ID,idString];
        
        NSArray *results = [document nodesForXPath:xpath error:nil];
        if ([results count] == 0) {
            NSLog(@"group name error");
            return;
        }
        DDXMLElement *deleteElement = [results firstObject];
        DDXMLElement *groupElement = (DDXMLElement *)[deleteElement parent];
        [groupElement removeChildAtIndex:[deleteElement index]];
        
        [self.documentDatabase.entries removeObject:entry];
        PCCapsuleGroup *group = self.documentDatabase.groups[0];
        [group.entries removeObject:entry];
        self.documentDatabase.refreshDocument = YES;
        [PCDocumentDatabase setLastModifyDate:[NSDate date]];
        
        //sync
        PCCloudManager *manager = [PCCloudManager sharedCloudManager];
        PCCloudGroup *cloudGroup = (PCCloudGroup *)manager.cloudDatabase.cloudGroups[0];
        [cloudGroup removeObject:[manager queryCloudEntryByID:entry.cloudID] forKey:kGroupEntries];

    } else {
        [self readDocument:[PCDocumentDatabase documentPath] withMasterPassword:@"the method is uncompeleted"];
        [self deleteEntry:entry];
    }
}

- (void)modifyEntry: (PCCapsule *)entry{
    if (self.documentDatabase.isLoad) {
        DDXMLDocument *document = self.documentDatabase.document;
        NSString *idString = [@(entry.capsuleID) stringValue];
        NSString *xpath = [NSString stringWithFormat:@"//group[@%@='%@']/entry[@%@='%@']"
                           ,CAPSULE_GROUP_NAME,CAPSULE_GROUP_DEFAULT,CAPSULE_ENTRY_ID,idString];
        NSArray *results = [document nodesForXPath:xpath error:nil];
        if ([results count] == 0) {
            NSLog(@"entry id error");
            return;
        }
        DDXMLElement *modifyEntry = [results firstObject];
        //修改记录id
        [[modifyEntry attributeForName:CAPSULE_ENTRY_ID] setStringValue:entry.idString];
        [[modifyEntry attributeForName:CAPSULE_CLOUD_ID] setStringValue:entry.cloudID];
        
        //修改记录内容
        NSArray *aEntry = [modifyEntry children];
        for (DDXMLNode *e in aEntry) {
            if ([e.name isEqualToString:CAPSULE_ENTRY_TITLE]) {
                [e setStringValue:entry.title];
            }
            if ([e.name isEqualToString:CAPSULE_ENTRY_ACCOUNT]) {
                [e setStringValue:entry.account];
            }
            if ([e.name isEqualToString:CAPSULE_ENTRY_PASSWORD]) {
                [e setStringValue:entry.password];
            }
            if ([e.name isEqualToString:CAPSULE_ENTRY_SITE]) {
                [e setStringValue:entry.site];
            }
            if ([e.name isEqualToString:CAPSULE_ENTRY_ICON]) {
                [e setStringValue:entry.iconName];
            }
            if ([e.name isEqualToString:CAPSULE_ENTRY_GROUP]) {
                [e setStringValue:entry.group];
            }
            
        }
        
//        //sync cloudEntry
        PCCloudManager *manager = [PCCloudManager sharedCloudManager];
        [manager syncEntry:entry];
        
        [PCDocumentDatabase setLastModifyDate:[NSDate date]];
        self.documentDatabase.refreshDocument = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOULD_RELOAD object:nil];
    } else {
        [self readDocument:[PCDocumentDatabase documentPath] withMasterPassword:@"the method is uncompeleted"];
        [self modifyEntry:entry];
    }
}

#pragma mark - group API

- (void)modifyGroup: (PCCapsuleGroup *)group{
    if (self.documentDatabase.isLoad) {
        DDXMLDocument *document = self.documentDatabase.document;
        NSString *idString = [@(group.groupID) stringValue];
        NSString *xpath = [NSString stringWithFormat:@"//group[@%@='%@']"
                           ,CAPSULE_GROUP_ID,idString];
        NSArray *results = [document nodesForXPath:xpath error:nil];
        if ([results count] == 0) {
            NSLog(@"group id error");
            return;
        }
        DDXMLElement *modifyGroup = [results firstObject];
        //修改记录id
        [[modifyGroup attributeForName:CAPSULE_GROUP_ID] setStringValue:idString];
        [[modifyGroup attributeForName:CAPSULE_CLOUD_ID] setStringValue:group.cloudID];
        [[modifyGroup attributeForName:CAPSULE_GROUP_NAME] setStringValue:group.name];
        
        [PCDocumentDatabase setLastModifyDate:[NSDate date]];
        self.documentDatabase.refreshDocument = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOULD_RELOAD object:nil];
    } else {
        [self readDocument:[PCDocumentDatabase documentPath] withMasterPassword:@"the method is uncompeleted"];
        [self modifyGroup:group];
    }

}

#pragma mark - database API
- (void)saveDatabase{
    PCDocumentDatabase *database = [PCDocumentDatabase sharedDocumentDatabase];
    if (self.documentDatabase.isLoad) {
        DDXMLDocument *document = self.documentDatabase.document;

        NSString *xpath = @"//database";
        NSArray *results = [document nodesForXPath:xpath error:nil];
        if ([results count] == 0) {
            NSLog(@"group id error");
            return;
        }
        DDXMLElement *modifyDatabase = [results firstObject];
        //修改云端id
        [[modifyDatabase attributeForName:@"database_cloud_id"] setStringValue:database.cloudID];
        self.documentDatabase.refreshDocument = YES;
        [PCDocumentDatabase setLastModifyDate:[NSDate date]];

    } else {
        [self readDocument:[PCDocumentDatabase documentPath] withMasterPassword:@"the method is uncompeleted"];
        [self saveDatabase];
    }

}


- (void)saveDocument{
    if (self.documentDatabase.shouldRefresh) {
        DDXMLElement *root = [self.documentDatabase.document rootElement];
        NSString *path = [PCDocumentDatabase documentPath];
        NSLog(@"documentPath = %@",path);
        dispatch_queue_t saveDocumentQueue = dispatch_queue_create(SAVE_DOCUMENT_QUEUE, DISPATCH_QUEUE_SERIAL);
        dispatch_async(saveDocumentQueue, ^{
            BOOL wirteSuccess = [[root XMLString] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            NSLog(@" %@ ",[root XMLString]);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (wirteSuccess) {
                    [PCDocumentDatabase setLastModifyDate:[NSDate date]];
                    self.documentDatabase.refreshDocument = NO;
                    NSLog(@"write file success");
                } else {
                    NSLog(@"write file fail");
                }
            });
        });
        [[PCCloudManager sharedCloudManager] syncDatabase:self.documentDatabase];
    }
}


@end
