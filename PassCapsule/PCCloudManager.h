//
//  PCCloudManager.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/13.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCDocumentDatabase.h"
#import <AVOSCloud/AVOSCloud.h>

#import "PCCloudDatabase.h"
#import "PCCloudGroup.h"
#import "PCCloudEntry.h"
#import "PCCloudUser.h"

@interface PCCloudManager : NSObject

- (void)shouldSyncBy: (NSDate *)date;

- (void)syncEntry: (PCCapsule *)entry;
- (void)syncgroup: (PCCapsuleGroup *)group;
- (void)syncDatabase: (PCDocumentDatabase *)database;

- (PCCloudEntry *)queryCloudEntryByID:(NSString *)cloudID;
- (PCCloudGroup *)queryCloudGroupByID:(NSString *)cloudID;
- (PCCloudDatabase *)queryCloudDatabaseByID:(NSString *)cloudID;

- (PCCloudEntry *)createCloudEntryWithEntry: (PCCapsule *)entry;
- (PCCloudGroup *)createCloudGroupWithGroup: (PCCapsuleGroup *)group;
- (PCCloudDatabase *)createCloudDatabaseWithDatabase: (PCDocumentDatabase *)database;


+(instancetype)sharedCloudManager;
/**
 Should create only one instance of class. Should not call init.
 */
- (instancetype)init	__attribute__((unavailable("init is not available in PCCloudManager, Use sharedCloudManager"))) NS_DESIGNATED_INITIALIZER;

/**
 Should create only one instance of class. Should not call new.
 */
+ (instancetype)new	__attribute__((unavailable("new is not available in PCCloudManager, Use sharedCloudManager")));
@end
