//
//  PCKeyChainCapsule.m
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


#import "PCKeyChainUtils.h"

@implementation PCKeyChainUtils

+ (NSString *)stringForKey:(NSString *)key andServiceName:(NSString *)serviceName {
    CFTypeRef result_data = NULL;
    OSStatus status;
    
    // Check the arguments
    if (key == nil || serviceName == nil) {
        return nil;
    }
    
    NSDictionary *query = @{
                            (__bridge id)kSecReturnData : (id)kCFBooleanTrue,
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService : serviceName,
                            (__bridge id)kSecAttrAccount : key,
                            };
    
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result_data);
    if (status != errSecSuccess) {
        return nil;
    }
    
    NSData *resultData = (__bridge_transfer NSData *)result_data;
    NSString *string = [[NSString alloc] initWithData:(id)resultData encoding:NSUTF8StringEncoding];
    
    return string;
}

+ (BOOL)setString:(NSString *)string forKey:(NSString *)key andServiceName:(NSString *)serviceName {
    OSStatus status;
    
    // Check the arguments
    if (string == nil || key == nil || serviceName == nil) {
        return NO;
    }
    
    // Check if the item already exists
    NSString *existingPassword = [self stringForKey:key andServiceName:serviceName];
    if (existingPassword != nil) {
        // Update
        NSDictionary *query = @{
                                (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                (__bridge id)kSecAttrService : serviceName,
                                (__bridge id)kSecAttrAccount : key,
                                };
        
        NSDictionary *attributesToUpdate = @{
                                             (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlocked,
                                             (__bridge id)kSecValueData : [string dataUsingEncoding:NSUTF8StringEncoding],
                                             };
        
        status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
    } else {
        // Add
        NSDictionary *attributes = @{
                                     (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                                     (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleWhenUnlocked,
                                     (__bridge id)kSecAttrService : serviceName,
                                     (__bridge id)kSecAttrAccount : key,
                                     (__bridge id)kSecValueData : [string dataUsingEncoding:NSUTF8StringEncoding],
                                     };
        
        status = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
    }
    
    return status == errSecSuccess;
}

+ (BOOL)deleteStringForKey:(NSString *)key andServiceName:(NSString *)serviceName {
    OSStatus status;
    
    // Check the arguments
    if (key == nil || serviceName == nil) {
        return NO;
    }
    
    NSDictionary *query = @{
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService : serviceName,
                            (__bridge id)kSecAttrAccount : key,
                            };
    
    status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    return status == errSecSuccess;
}

+ (BOOL)deleteAllForServiceName:(NSString *)serviceName {
    OSStatus status;
    
    // Check the arguments
    if (serviceName == nil) {
        return NO;
    }
    
    NSDictionary *query = @{
                            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService : serviceName,
                            };
    
    status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    return status == errSecSuccess;
}


@end
