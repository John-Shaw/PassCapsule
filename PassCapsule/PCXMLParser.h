//
//  PCXMLParser.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/6.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PCCapsule;

@interface PCXMLParser : NSObject<NSXMLParserDelegate>

@property (nonatomic,strong) NSMutableArray *capsules;
@property (nonatomic,strong) NSMutableString *currentElementValue;
@property (nonatomic,strong) PCCapsule *aCapusle;
@property (nonatomic,strong) NSArray *elementToParse;
@property (nonatomic,readwrite) BOOL storingFlag;
-(void)paserWithPath:(NSString *)path;

@end
