//
//  PCCapsuleDetailVC.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/7.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCCapsuleDetailVC.h"
@interface PCCapsuleDetailVC()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation PCCapsuleDetailVC
-(void)setCapsuleTitle:(NSString *)title{
    self.titleLabel.text = title;
}

-(void)setCapsuleDetail:(NSString *)detail{
    self.detailLabel.text = detail;
}

-(void)setCapsuleImage:(UIImage *)image{
    self.iconView.image = image;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"test";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    
    if (indexPath.row == 1) {
        cell.textLabel.text = @"testttttttt";
    }
    
    return cell;
    

}

@end
