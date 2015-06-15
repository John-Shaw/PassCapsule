//
//  PCNewDocumetTableVC.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/15.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCNewDocumetTableVC.h"
#import "PCXMLDocument.h"

@implementation PCNewDocumetTableVC

-(void)viewDidLoad{

}

- (IBAction)donePress:(UIBarButtonItem *)sender {
    PCXMLDocument *new = [PCXMLDocument new];
    [new createWithMasterKey:@"test key 123456"];
}


- (IBAction)cancelPress:(UIBarButtonItem *)sender {
}

@end
