//
//  PCXMLDocument.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/15.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PCDocumentManager : NSObject

@property (nonatomic,strong) NSString *masterPassword;
@property (nonatomic,strong) NSString *documentPath;

- (BOOL)createDocument:(NSString *)documentName WithMasterPassword:(NSString *)masterPassword;
- (NSString *)randomStringWithLength: (int) len;


@end
