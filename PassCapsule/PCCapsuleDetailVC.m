//
//  PCCapsuleDetailVC.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/7.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCCapsuleDetailVC.h"
#import "PCCapsule.h"

typedef enum : NSUInteger {
    CELL_ACCOUNT,
    CELL_PASSWORD,
    CELL_SITE,
    CELL_GROUP,
} CELL_TYPE;

@interface PCCapsuleDetailVC() 
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *detailVeiw;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

@implementation PCCapsuleDetailVC


-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
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

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    
}

#pragma mark - data source delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *common = @"common";
    static NSString *group = @"group";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:common];

    if (indexPath.row == CELL_ACCOUNT) {
        cell.textLabel.text = @"用户名";
        cell.detailTextLabel.text = self.capsule.account;
    }
    if (indexPath.row == CELL_PASSWORD) {
        cell.textLabel.text = @"密码";
        cell.detailTextLabel.text = @"*********";
        
    }
    if (indexPath.row == CELL_SITE) {
        cell.textLabel.text = @"网站";
        cell.detailTextLabel.text = self.capsule.site;
    }
    if (indexPath.row == CELL_GROUP) {
        cell = [tableView dequeueReusableCellWithIdentifier:group];
        cell.textLabel.text = @"群组";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (action == @selector(copy:)) {
        NSString *copyString = @"";
        switch (indexPath.row) {
            case CELL_ACCOUNT:
                copyString = self.capsule.account;
                break;
            case CELL_PASSWORD:
                copyString = self.capsule.pass;
                break;
            case CELL_SITE:
                copyString = self.capsule.site;
                break;
            default:
                break;
        }
        [UIPasteboard generalPasteboard].string = copyString;
    }
}


#pragma mark - table view delagate





@end
