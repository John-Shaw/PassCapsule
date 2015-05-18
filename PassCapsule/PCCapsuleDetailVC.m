//
//  PCCapsuleDetailVC.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/7.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCCapsuleDetailVC.h"
#import "PCCapsule.h"
@interface PCCapsuleDetailVC() 
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *detailVeiw;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;


@end

@implementation PCCapsuleDetailVC


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.titleView.text = self.capsule.title;
    self.detailVeiw.text = self.capsule.account;
    
    UIImage *image = [UIImage imageNamed:self.capsule.iconName];
    if (image) {
        self.iconView.image = image;
    }
    else{
        self.iconView.image = [UIImage imageNamed:@"lock"];
    }
    

}


#pragma mark - table view delegate



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *account = @"account";

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:account];

    if (indexPath.row == 0) {
        cell.textLabel.text = @"用户名";
        cell.detailTextLabel.text = self.capsule.account;
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"密码";
        cell.detailTextLabel.text = @"*********";
        
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"网站";
        cell.detailTextLabel.text = self.capsule.site;
    }
    return cell;
}



@end
