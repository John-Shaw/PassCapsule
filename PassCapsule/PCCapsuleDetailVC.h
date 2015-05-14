//
//  PCCapsuleDetailVC.h
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/7.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCCapsuleDetailVC : UIViewController<UITableViewDataSource>
- (void)setCapsuleTitle:(NSString *)title;
- (void)setCapsuleDetail:(NSString *)detail;
- (void)setCapsuleImage:(UIImage *)image;
@end
