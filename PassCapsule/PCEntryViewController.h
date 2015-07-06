//
//  PCCapsuleDetailVC.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/7.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCCapsule;
@interface PCEntryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) PCCapsule *capsule;
@end
