//
//  PCCloudManager.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/13.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCCloudManager.h"
#import "DDXML.h"

@implementation PCCloudManager
+(instancetype)sharedCloudManager{
    static PCCloudManager *kManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        kManager = [[self alloc] init];
    });
    return kManager;
}

- (void)syncEntry: (PCCapsule *)entry andGroup: (PCCapsuleGroup *)group{
    
}

- (void)syncDatabase: (NSString *)databaseID{
    [AVFile getFileWithObjectId:databaseID withBlock:^(AVFile *file, NSError *error) {
        //TODO: handle when get file in leanCloud
    }];
}

- (void)saveDatabase:(NSData *)xmlData{
    AVFile *file = [AVFile fileWithName:[PCDocumentDatabase documentName] data:xmlData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //TODO: handle when succeeded
    } progressBlock:^(NSInteger percentDone) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //TODO: do something UI progress
        });
    }];

}

- (void)setCloudDatabaseWithDatabase:(PCDocumentDatabase *)database{
    
}

- (AVObject *)cloudEntryWithEntry:(PCCapsule *)entry  andSync: (BOOL)shouldSync{
    AVObject *cloudEntry = [[AVObject alloc] initWithClassName:entry.title];
    
    [cloudEntry setObject:entry.title forKey:CAPSULE_ENTRY_TITLE];
    [cloudEntry setObject:entry.account forKey:CAPSULE_ENTRY_ACCOUNT];
    [cloudEntry setObject:entry.password forKey:CAPSULE_ENTRY_PASSWORD];
    [cloudEntry setObject:entry.site forKey:CAPSULE_ENTRY_SITE];
    [cloudEntry setObject:entry.group forKey:CAPSULE_ENTRY_GROUP];
    [cloudEntry setObject:entry.idString forKey:CAPSULE_ENTRY_ID];
    
    if (shouldSync) {
        [cloudEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"create entry succeeded!");
            }
        }];
    }
    
    entry.cloudID = [cloudEntry objectId];
    return cloudEntry;
}

- (AVObject *)cloudGroupWithGroup:(PCCapsuleGroup *)group andSync: (BOOL)shouldSync{
    AVObject *cloudGroup = [[AVObject alloc] initWithClassName:group.groupName];
    NSMutableArray *cloudEntries = [[NSMutableArray alloc] init];
    for (PCCapsule *entry in group.groupEntries) {
        AVObject *cloudEntry = [self cloudEntryWithEntry:entry andSync:NO];
        [cloudEntries addObject:cloudEntry];
    }
    [cloudGroup setObject:cloudEntries forKey:CAPSULE_GROUP];
    
    if (shouldSync) {
        [cloudGroup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
        }];
    }
    
    group.cloudID = [cloudGroup objectId];
    return cloudGroup;
}

- (AVObject *)cloudDatabaseWithDatabase:(PCDocumentDatabase *)database andSync: (BOOL)shouldSync{
    NSString *databaseName = [PCDocumentDatabase databaseName];
    NSString *documentName = [PCDocumentDatabase documentName];

    AVObject *cloudDatabase = [[AVObject alloc] initWithClassName:@"johnshaw"];
    NSData *xmldata = [database.document XMLData];
    AVFile *xmlFile = [AVFile fileWithName:@"acsdassd.pcdb" data:xmldata];
    [cloudDatabase setObject:xmlFile forKey:@"CloudFile"];
    [xmlFile saveInBackground];
    //    NSMutableArray *cloudGroupes = [[NSMutableArray alloc] init];
//    for (PCCapsuleGroup *gourp in database.groups) {
//        AVObject *cloudGroup = [self cloudGroupWithGroup:gourp andSync:NO];
//        [cloudDatabase addObject:cloudGroup forKey:kDatabaseGroups];
//    }
    
    if (shouldSync) {
        [cloudDatabase saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"database save in leanCloud");
        }];
    }
    
    database.cloudID = [cloudDatabase objectId];
    return cloudDatabase;
}

- (AVObject *)createCloudDatabase:(PCDocumentDatabase *)database{
    //    AVObject *cloudDatabase = [[AVObject alloc] initWithClassName:@"Database"];
    PCCloudDatabase *cloudDatabase = [[PCCloudDatabase alloc] init];
    //FIXME:未知bug
    cloudDatabase.name = [PCDocumentDatabase databaseName];
    AVFile *file = [AVFile fileWithName:[cloudDatabase.name stringByAppendingPathExtension:@"xml"] data:[database.document XMLData]];
    cloudDatabase.file = file;
//    cloudDatabase.fileID = [file objectId];
    [cloudDatabase saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"save cloud database succeeded");
            cloudDatabase.fileID = [file objectId];
            NSLog(@"when succeeded objectID = %@",cloudDatabase.fileID);
        }
    }];
    
    return cloudDatabase;
}


@end
