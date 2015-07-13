//
//  PCCloudModel.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/13.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCDocumentDatabase.h"

@interface PCCloudModel : NSObject

- (void)cloudEntryWithEntry: (PCCapsule *)entry;
- (void)cloudGroupWithGroup: (PCCapsuleGroup *)group;
- (void)cloudDatabaseWithDatabase: (PCDocumentDatabase *)database;



@end
