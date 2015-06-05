//
//  PCXMLManager.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/2.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCXMLManager.h"



@implementation PCXMLManager

-(void)xmlCreate{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"test.xml"];
    NSLog(@"filepath : %@",filePath);
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    if(!fileExists){

    }
}

@end
