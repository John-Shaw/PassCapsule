//
//  PCDocumentDatabase.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/25.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCDocumentDatabase.h"

@implementation PCDocumentDatabase

+ (instancetype)sharedDocumentDatabase{
    static PCDocumentDatabase *kDatabase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        kDatabase = [[self alloc] init];
    });
    return kDatabase;
}

/**
 *  自动增长的ID，每次取得后会自动增长并存入NSUserDefault，主要是为了给每个记录一个不重复的标志符
 *
 *  @return 标志符,是一个非负整数
 */
- (NSUInteger)autoIncreaseID{
    NSUInteger increaseID = self.currentID;
    [self setCurrentID:increaseID+1];
    return increaseID;
}

- (NSString *)autoIncreaseIDString{
    return [@(self.autoIncreaseID) stringValue];
}

#pragma mark - getter and setter
- (NSMutableArray *)entries{
    if (!_entries) {
        _entries = [[NSMutableArray alloc] init];
    }
    return _entries;
}

- (NSMutableArray *)groups{
    if (!_groups) {
        _groups = [[NSMutableArray alloc] init];
    }
    return _groups;
}

//readwrite 的属性如果同时重写了getter和setter，必须手动 @synthesize
//readonly 的属性如果重写了getter，必须手动 @synthesize
@synthesize currentID = _currentID;
- (NSUInteger)currentID{
    NSString *stringValue = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_CURRENT_ID];
    NSUInteger temp = [stringValue integerValue];
    if (!stringValue) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{USERDEFAULT_CURRENT_ID:@1}];
        temp = self.currentID;
    }

    return temp;
}

- (void)setCurrentID:(NSUInteger)currentID{
    [[NSUserDefaults standardUserDefaults] setInteger:currentID forKey:USERDEFAULT_CURRENT_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _currentID = currentID;
}


+ (void)setDocumentName:(NSString *)documentName{
    [[NSUserDefaults standardUserDefaults] setObject:documentName forKey:USERDEFAULT_DOCUMENT_NAME];
}

+ (NSString *)databaseName{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_DOCUMENT_NAME];
}

+ (NSString *)documentName{
    NSString *databaseName = [PCDocumentDatabase databaseName];
    return [databaseName stringByAppendingPathExtension:@"pcdb"];
}
+ (NSString *)documentPath{
    NSString *documentName = [PCDocumentDatabase documentName];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    return [documentsPath stringByAppendingPathComponent:documentName];
}

@end
