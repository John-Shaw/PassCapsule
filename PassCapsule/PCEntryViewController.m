//
//  PCCapsuleDetailVC.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/7.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCEntryViewController.h"
#import "PCCapsule.h"

typedef enum : NSUInteger {
    PCEntryCellTypeAccount,
    PCEntryCellTypePassword,
    PCEntryCellTypeSite,
    PCEntryCellTypeGroup,
} PCEntryCellType;

@interface PCEntryViewController() 
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *detailVeiw;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

@implementation PCEntryViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray *randomIcons = @[@"google_plus",@"zhihu",@"douban",@"passcapsule"];
    
    self.titleView.text = self.capsule.title;
    self.detailVeiw.text = self.capsule.account;
    UIImage *image = [UIImage imageNamed:self.capsule.iconName];
    if (image) {
        self.iconView.image = image;
    }
    else{
        NSString *iconName = randomIcons[arc4random()%4];
        self.iconView.image = [UIImage imageNamed:iconName];
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

    if (indexPath.row == PCEntryCellTypeAccount) {
        cell.textLabel.text = @"用户名";
        cell.detailTextLabel.text = self.capsule.account;
    }
    if (indexPath.row == PCEntryCellTypePassword) {
        cell.textLabel.text = @"密码";
        cell.detailTextLabel.text = @"*********";
        
    }
    if (indexPath.row == PCEntryCellTypeSite) {
        cell.textLabel.text = @"网站";
        cell.detailTextLabel.text = self.capsule.site;
    }
    if (indexPath.row == PCEntryCellTypeGroup) {
        cell = [tableView dequeueReusableCellWithIdentifier:group];
        cell.textLabel.text = @"群组";
    }
    return cell;
}



#pragma mark - table view delagate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == PCEntryCellTypePassword) {
        return NO;
    }
    return YES;
}


- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
//    if (action == @selector(copy:)) {
//        return YES;
//    }
//    return NO;
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (action == @selector(copy:)) {
        NSString *copyString = @"";
        switch (indexPath.row) {
            case PCEntryCellTypeAccount:
                copyString = self.capsule.account;
                break;
            case PCEntryCellTypePassword:
                copyString = [self.capsule decrptedPassword];
                break;
            case PCEntryCellTypeSite:
                copyString = self.capsule.site;
                break;
            default:
                break;
        }
        [UIPasteboard generalPasteboard].string = copyString;
    }
}







@end
