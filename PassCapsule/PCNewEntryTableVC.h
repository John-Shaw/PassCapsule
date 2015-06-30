//
//  PCNewEntryTableVC.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/6/30.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCNewEntryTableVC : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *siteTextField;

@end
