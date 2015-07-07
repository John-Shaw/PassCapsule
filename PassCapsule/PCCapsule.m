//
//  PCCapsule.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/6.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCCapsule.h"
#import "PCPassword.h"

@implementation PCCapsule

- (void)setPassword:(NSString *)password{
    if ([password length] == 0) {
        _password = nil;
    } else {
        _password = [PCPassword encryptedString:password];
    }
}

- (NSString *)decrptedPassword{
    return [PCPassword decryptedString:self.password];
}

- (NSString *)idString{
    return [@(self.capsuleID) stringValue];
}

@end
