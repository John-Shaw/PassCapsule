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

- (void)syncEntry: (PCCapsule *)entry andGroup: (PCCapsuleGroup *)group;
- (void)syncDatabase: (NSString *)databaseID;
- (void)saveDatabase: (NSData *)xmlData;


- (PCCloudEntry *)cloudEntryWithEntry: (PCCapsule *)entry andSync: (BOOL)shouldSync;
- (PCCloudGroup *)cloudGroupWithGroup: (PCCapsuleGroup *)group andSync: (BOOL)shouldSync;
- (PCCloudDatabase *)cloudDatabaseWithDatabase: (PCDocumentDatabase *)database andSync: (BOOL)shouldSync;

- (void)setCloudDatabaseWithDatabase: (PCDocumentDatabase *)database;

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
