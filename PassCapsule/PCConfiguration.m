//
//  PCConfiguration.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/25.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCConfiguration.h"



@implementation PCConfiguration

+ (void)setDocumentPath:(NSString *)documentPath{
    [[NSUserDefaults standardUserDefaults] setObject:documentPath forKey:@"documentPath"];
}
+ (NSString *)documentPath{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"documentPath"];
}

@end
