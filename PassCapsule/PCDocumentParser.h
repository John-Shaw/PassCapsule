//
//  PCDocumentParser.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/29.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"

static NSString * const NOTIFICATION_PARSER_DONE = @"didLoadData";

@interface PCDocumentParser : NSObject
@property (nonatomic, strong) NSMutableArray *Capsules;



- (void)parser:(NSData *)xmlData;


@end
