//
//  PCNewDocumetTableVC.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/15.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCNewDocumetTableVC.h"
#import "PCDocumentManager.h"
#import "RNEncryptor.h"

@implementation PCNewDocumetTableVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
}


- (BOOL)validInput{
    if ([self.nameTextField.text length] == 0
        || [self.passwordTextField.text length] == 0
        || [self.confirmPasswordTextField.text length] == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"创建密码库"
                                                        message:@"该项不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        return NO;
    }
    return YES;
}



- (IBAction)donePress:(UIBarButtonItem *)sender {
    if ([self validInput]) {
        PCDocumentManager *document = [PCDocumentManager sharedDocumentManager];
        NSString *name = self.nameTextField.text;
        NSString *password = self.passwordTextField.text;
        BOOL createSuccess = [document createDocument:name WithMasterPassword:password];
        if (createSuccess) {
            [self performSegueWithIdentifier:@"toUnLockView" sender:self];
        }
    }

}


- (IBAction)cancelPress:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
