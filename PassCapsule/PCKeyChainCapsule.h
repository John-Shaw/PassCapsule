//
//  PCKeyChainCapsule.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/17.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

//copy from miniKeepass
//and I don't sure should I include the license below?

//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

static NSString * const KEYCHAIN_KEY = @"masterKey";
static NSString * const KEYCHAIN_PASSWORD = @"masterPassword";
static NSString * const KEYCHAIN_KEY_SERVICE = @"cn.zerz.PassCapsule.Key";
static NSString * const KEYCHAIN_PASSWORD_SERVICE = @"cn.zerz.PassCapsule.Password";

@interface PCKeyChainCapsule : NSObject

+ (NSString *)stringForKey:(NSString *)key andServiceName:(NSString *)serviceName;
+ (BOOL)setString:(NSString *)string forKey:(NSString *)key andServiceName:(NSString *)serviceName;
+ (BOOL)deleteStringForKey:(NSString *)key andServiceName:(NSString *)serviceName;
+ (BOOL)deleteAllForServiceName:(NSString *)serviceName;

@end
