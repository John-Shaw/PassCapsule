//
//  PCDocumentDatabase.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/25.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCDocumentDatabase.h"

@implementation PCDocumentDatabase

+(instancetype)sharedDocumentDatabase{
    static PCDocumentDatabase *kDatabase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        kDatabase = [[self alloc] init];
    });
    return kDatabase;
}



-(NSMutableArray *)entries{
    if (!_entries) {
        _entries = [[NSMutableArray alloc] init];
    }
    return _entries;
}

-(NSMutableArray *)groups{
    if (!_groups) {
        _groups = [[NSMutableArray alloc] init];
    }
    return _groups;
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
