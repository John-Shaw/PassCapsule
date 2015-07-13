//
//  PCCloudManager.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/13.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCCloudManager.h"

@implementation PCCloudManager

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

@end
