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
    
    self.navigationItem.title = @"新记录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editDone)];
}

- (void)editDone{
    if ([self validateTextFileds]) {
        PCCapsule *aCapsule = [[PCCapsule alloc] init];
        aCapsule.title = @"testTitle";
        aCapsule.account = @"fucker";
        aCapsule.pass = @"hello,cracker";
        aCapsule.site = @"www.apple.com";
        aCapsule.category = @"互联网账户";
        PCDocumentManager *manager = [PCDocumentManager sharedDocumentManager];
        [manager addNewEntry:aCapsule];
        NSLog(@"start addentry");
    }
}

- (BOOL)validateTextFileds{

    
    return YES;
}

@end
