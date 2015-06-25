//
//  PCXMLParser.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/6.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PCCapsule;

//暂时废弃这个类，因为NSXML只支持解析不支持写入，所以放弃而使用KissXML

@interface PCXMLParser : NSObject<NSXMLParserDelegate>

@property (nonatomic,strong) NSMutableArray *capsules;
@property (nonatomic,strong) NSMutableString *currentElementValue;
@property (nonatomic,strong) PCCapsule *aCapusle;
@property (nonatomic,strong) NSArray *elementToParse;
@property (nonatomic,readwrite) BOOL storingFlag;
-(NSMutableArray *)paserWithPath:(NSString *)path;
+(instancetype)sharedXMLParser;

/**
 Should create only one instance of class. Should not call init.
 */
- (instancetype)init	__attribute__((unavailable("init is not available in PCXMLParser, Use sharedXMLParser"))) NS_DESIGNATED_INITIALIZER;

/**
 Should create only one instance of class. Should not call new.
 */
+ (instancetype)new	__attribute__((unavailable("new is not available in PCXMLParser, Use sharedXMLParser")));

@end
