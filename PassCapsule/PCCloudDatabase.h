//
//  PCCloudModel.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/7/13.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//


#import <AVOSCloud/AVOSCloud.h>

static NSString *const kDatabaseGroups = @"cloudGroups";

@interface PCCloudDatabase : AVObject<AVSubclassing>

@property (nonatomic, strong) NSArray  *cloudGroups;
@property (nonatomic, strong) AVFile   *file;
@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, copy  ) NSString *fileID;


@end
