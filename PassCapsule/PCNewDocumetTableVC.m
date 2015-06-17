//
//  PCNewDocumetTableVC.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/15.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCNewDocumetTableVC.h"
#import "PCXMLDocument.h"
#import "RNEncryptor.h"

@implementation PCNewDocumetTableVC

-(void)viewDidLoad{

}


- (BOOL)validInput{
    if ([self.nameTextField.text length] == 0
        || [self.passwordTextField.text length] == 0
        || [self.confirmPasswordTextField.text length] == 0) {
        
        return NO;
    }
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        return NO;
    }
    return YES;
}

- (IBAction)donePress:(UIBarButtonItem *)sender {
    
    
    if ([self validInput]) {
        PCXMLDocument *new = [PCXMLDocument new];

        NSString *password = self.passwordTextField.text;
        
        NSString *randomString = [new randomStringWithLength:arc4random()%64+16];
        
        NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSData *encryptedData = [RNEncryptor encryptData:data
                                            withSettings:kRNCryptorAES256Settings
                                                password:randomString
                                                   error:&error];
        
        
        
        [new createDocument:[self.nameTextField.text stringByAppendingPathExtension:@"pcdb"] WithMasterKey:encryptedData];
        
        
    }

}


- (IBAction)cancelPress:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
