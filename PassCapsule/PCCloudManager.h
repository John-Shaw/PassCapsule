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

@interface PCCloudManager : NSObject

- (void)syncEntry: (PCCapsule *)entry andGroup: (PCCapsuleGroup *)group;
- (void)syncDatabase: (NSString *)databaseID;
- (void)saveDatabase: (NSData *)xmlData;
@end
