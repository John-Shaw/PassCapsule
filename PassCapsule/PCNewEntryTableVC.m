//
//  PCNewEntryTableVC.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/30.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCNewEntryTableVC.h"
#import "PCDocumentManager.h"

@implementation PCNewEntryTableVC

- (void)viewDidLoad{
    [super viewDidLoad];

//    self.navigationItem.title = @"新记录";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editDone)];
}
- (IBAction)editDone:(UIBarButtonItem *)sender {
    if ([self validateTextFileds]) {
        PCCapsule *aCapsule = [[PCCapsule alloc] init];
        aCapsule.title = self.titleTextField.text;
        aCapsule.account = self.accountTextField.text;
        aCapsule.password = self.passwordTextField.text;
        aCapsule.site = self.siteTextField.text;
        aCapsule.group = CAPSULE_GROUP_DEFAULT;
        
        PCDocumentManager *manager = [PCDocumentManager sharedDocumentManager];
        [manager addNewEntry:aCapsule];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)editCancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL)validateTextFileds{
    if ([self.titleTextField.text length] == 0) {
        NSLog(@"title cant be empty");
        return NO;
    }
    if ([self.accountTextField.text length] == 0) {
        NSLog(@"account cant be empty");
        return NO;
    }
    if ([self.passwordTextField.text length] == 0) {
        NSLog(@"password cant be empty");
        return NO;
    }
    if ([self.siteTextField.text length] == 0) {
        
        self.siteTextField.text = @"";
    }
    return YES;
}

@end
