//
//  PCCloudManager.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/13.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCCloudManager.h"
#import "DDXML.h"
#import "PCDocumentManager.h"
#import "PCPassword.h"

@implementation PCCloudManager

+ (instancetype)sharedCloudManager{
    static PCCloudManager *kManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        kManager = [[self alloc] init];
    });
    return kManager;
}

- (void)shouldSyncBy:(NSDate *)date{
    AVUser *user = [AVUser currentUser];
    if (user) {
        NSString *cloudID = [user objectForKey:CLOUD_DATABASE_ID];
        PCCloudDatabase *cloudDatabase = [self queryCloudDatabaseByID:cloudID];
        if (cloudDatabase) {
            NSDate *cloudDate = cloudDatabase.updatedAt;
            NSDate *localDate = [PCDocumentDatabase lastModifyDate];
            NSComparisonResult result = [cloudDate compare:localDate];
            switch (result)
            {
                case NSOrderedAscending:
                    [self syncDatabase:[PCDocumentDatabase sharedDocumentDatabase]];
                    break;
                case NSOrderedDescending:
                    [[PCDocumentManager sharedDocumentManager] syncDocumentFormCloudWithUser:user];
                    break;
                case NSOrderedSame:
                    break;
                default:
                    NSLog(@"erorr dates");
            }
        }
    }

}

#pragma mark - sync cloud object
- (void)syncEntry: (PCCapsule *)entry{
    NSString *cloudID = entry.cloudID;
    PCCloudEntry *cloudEntry = nil;
    if (cloudID) {
        cloudEntry = [self queryCloudEntryByID:cloudID];
    } else {
        cloudEntry = [[PCCloudEntry alloc] init];
    }
    
    cloudEntry.title = entry.title;
    cloudEntry.account = entry.account;
    cloudEntry.password = entry.password;
    cloudEntry.site = entry.site;
    cloudEntry.group = entry.group;
    cloudEntry.entry_id = entry.idString;
    cloudEntry.cloud_id = entry.cloudID;
    
    [cloudEntry saveInBackground];
    
}

- (void)syncgroup: (PCCapsuleGroup *)group{
    PCCloudGroup *cloudGroup = [self queryCloudGroupByID:group.cloudID];
    if (cloudGroup) {
        
    } else {
        cloudGroup = [[PCCloudGroup alloc] init];
    }
    
    cloudGroup.cloud_id = group.cloudID;
    cloudGroup.group_id = [@(group.groupID) stringValue];
    cloudGroup.groupName = group.name;
    
    for (PCCapsule *entry in group.entries) {
        PCCloudEntry *cloudEntry = [self createCloudEntryWithEntry:entry];
        [cloudGroup addObject:cloudEntry forKey:kGroupEntries];
    }
    
    [cloudGroup saveInBackground];
}

- (void)syncDatabase: (PCDocumentDatabase *)database{
    PCCloudDatabase *cloudDatabase = [self queryCloudDatabaseByID:database.cloudID];
    if (cloudDatabase) {
        
    } else {
        cloudDatabase = [[PCCloudDatabase alloc] init];
    }
    
    NSString *databaseName = [PCDocumentDatabase databaseName];
    NSString *documentName = [PCDocumentDatabase documentName];
    
    NSData *xmldata = [database.document XMLData];
    AVFile *xmlFile = [AVFile fileWithName:documentName data:xmldata];
    
    cloudDatabase.name = databaseName;
    cloudDatabase.file = xmlFile;
    
    for (PCCapsuleGroup *group in database.groups) {
        PCCloudGroup *cloudGroup = [self createCloudGroupWithGroup:group];
        if (cloudGroup) {
                    [cloudDatabase addObject:cloudGroup forKey:kDatabaseGroups];
        }
    }
    
    [cloudDatabase saveInBackground];
    NSLog(@"save database cloud");
}

#pragma mark - query cloud object
- (PCCloudEntry *)queryCloudEntryByID:(NSString *)cloudID{
    PCCloudEntry *cloudEntry = nil;
    
    if (!cloudID) {
        return nil;
    }
    
    AVQuery *query = [PCCloudEntry query];
    cloudEntry = (PCCloudEntry *)[query getObjectWithId:cloudID];
    
    return cloudEntry;
}

- (PCCloudGroup *)queryCloudGroupByID:(NSString *)cloudID{
    PCCloudGroup *cloudGroup = nil;
    
    if (!cloudID) {
        return nil;
    }
    
    AVQuery *query = [PCCloudGroup query];
    cloudGroup = (PCCloudGroup *)[query getObjectWithId:cloudID];
    
    return cloudGroup;
}

- (PCCloudDatabase *)queryCloudDatabaseByID:(NSString *)cloudID{
    PCCloudDatabase *cloudDatabase = nil;
    
    if (!cloudID) {
        return nil;
    }

    AVQuery *query = [PCCloudDatabase query];
    cloudDatabase = (PCCloudDatabase *)[query getObjectWithId:cloudID];
    
    return cloudDatabase;
}

#pragma mark - create cloud object
- (PCCloudEntry *)createCloudEntryWithEntry:(PCCapsule *)entry{
    PCCloudEntry *cloudEntry = [self queryCloudEntryByID:entry.cloudID];
    if (cloudEntry) {
        return cloudEntry;
    } else {
        cloudEntry = [[PCCloudEntry alloc] init];
    }
    
    cloudEntry.title = entry.title;
    cloudEntry.account = entry.account;
    cloudEntry.password = entry.password;
    cloudEntry.site = entry.site;
    cloudEntry.group = entry.group;
    cloudEntry.entry_id = entry.idString;
    cloudEntry.cloud_id = [cloudEntry objectId];
    
    AVUser *user = [AVUser currentUser];
    if (user) {
        [cloudEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"create entry succeeded!");
                entry.cloudID = [cloudEntry objectId];
                cloudEntry.cloud_id = [cloudEntry objectId];
                //持久化
                [[PCDocumentManager sharedDocumentManager] modifyEntry:entry];
            }
        }];
    }
    
    return cloudEntry;
}

- (PCCloudGroup *)createCloudGroupWithGroup:(PCCapsuleGroup *)group{
    PCCloudGroup *cloudGroup = [self queryCloudGroupByID:group.cloudID];
    if (cloudGroup) {
        return cloudGroup;
    } else {
        cloudGroup = [[PCCloudGroup alloc] init];
    }
    
    cloudGroup.groupName = group.name;
    
    for (PCCapsule *entry in group.entries) {
        PCCloudEntry *cloudEntry = [self createCloudEntryWithEntry:entry];
        [cloudGroup addObject:cloudEntry forKey:kGroupEntries];
    }
    
    AVUser *user = [AVUser currentUser];
    if (user) {
        [cloudGroup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            group.cloudID = [cloudGroup objectId];
            
            //持久化
            [[PCDocumentManager sharedDocumentManager] modifyGroup:group];
        }];
    }
    
    return cloudGroup;
}

- (PCCloudDatabase *)createCloudDatabaseWithDatabase:(PCDocumentDatabase *)database{
    PCCloudDatabase *cloudDatabase = [self queryCloudDatabaseByID:database.cloudID];
    if (cloudDatabase) {
        return cloudDatabase;
    } else {
        cloudDatabase = [[PCCloudDatabase alloc] init];
    }
    
    NSString *databaseName = [PCDocumentDatabase databaseName];
    NSString *documentName = [PCDocumentDatabase documentName];
    
    cloudDatabase.name = databaseName;
    cloudDatabase.masterPassword = [PCPassword password];;
    
    NSData *xmldata = [database.document XMLData];
    AVFile *xmlFile = [AVFile fileWithName:documentName data:xmldata];
    cloudDatabase.file = xmlFile;
    
    
    for (PCCapsuleGroup *group in database.groups) {
        PCCloudGroup *cloudGroup = [self createCloudGroupWithGroup:group];
        [cloudDatabase addObject:cloudGroup forKey:kDatabaseGroups];
    }
    AVUser *user = [AVUser currentUser];
    if (user) {

        [cloudDatabase saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"save cloud database succeeded");

                [PCCloudUser saveCloudDatabaseID:[cloudDatabase objectId]];
                //FIXME:写到xml里
                NSString *cloudDatabaseID = [cloudDatabase objectId];
                database.cloudID = cloudDatabaseID;


                NSLog(@"object objectID = %@",cloudDatabase.objectId);
                [cloudDatabase saveInBackground];
                
                //AVUser 里保存 database 的 ID 值
                [user setObject:cloudDatabaseID forKey:CLOUD_DATABASE_ID];
                [user saveInBackground];

                //持久化
                [[PCDocumentManager sharedDocumentManager] saveDatabase];

            }
        }];
    }
    return cloudDatabase;
}


@end
