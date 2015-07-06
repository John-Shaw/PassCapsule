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

- (NSUInteger)autoIncreaseID{
    NSUInteger increaseID = self.currentID;
    [self setCurrentID:increaseID+1];
    return increaseID;
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
@synthesize currentID=_currentID;
- (NSUInteger)currentID{
    NSUInteger temp = [[[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_CURRENT_ID] integerValue];
    if (!temp) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{USERDEFAULT_CURRENT_ID:@1}];
        _currentID = 1;
    }
    return temp;
}

- (void)setCurrentID:(NSUInteger)currentID{
    [[NSUserDefaults standardUserDefaults] setInteger:currentID forKey:USERDEFAULT_CURRENT_ID];
    _currentID = currentID;
}


+ (void)setDocumentName:(NSString *)documentName{
    [[NSUserDefaults standardUserDefaults] setObject:documentName forKey:USERDEFAULT_DOCUMENT_NAME];
}
+ (NSString *)documentPath{
    NSString *documentName = [[NSUserDefaults standardUserDefaults] stringForKey:USERDEFAULT_DOCUMENT_NAME];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentsPath stringByAppendingPathComponent:documentName];
}

@end
