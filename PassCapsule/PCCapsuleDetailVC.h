//
//  PCCapsuleDetailVC.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/7.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCCapsuleDetailVC : UIViewController<UITableViewDataSource>
@property (nonatomic,strong) NSString *titleLabel;
@property (nonatomic,strong) NSString *detailLabel;
@property (nonatomic,strong) NSString *imageName;
@end
