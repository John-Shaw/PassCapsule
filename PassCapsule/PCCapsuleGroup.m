//
//  PCCapsuleGroup.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/29.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCCapsuleGroup.h"

@implementation PCCapsuleGroup

- (NSMutableArray *)groupEntries{
    if (!_groupEntries) {
        _groupEntries = [[NSMutableArray alloc] init];
    }
    return _groupEntries;
}

@end
