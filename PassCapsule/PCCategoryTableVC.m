//
//  ZZCategoryTableViewController.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/4/26.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCCategoryTableVC.h"
#import "PCXMLParser.h"
#import "PCCapsule.h"
#import "PCCapsuleDetailVC.h"

@interface PCCategoryTableVC()
@property (nonatomic,strong) NSMutableArray *categories;
@end

@implementation PCCategoryTableVC

-(void)viewDidLoad{
    PCXMLParser *aPaser = [PCXMLParser new];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"capsules" ofType:@"xml"];

    self.cells = [aPaser paserWithPath:path];
    
    
    NSLog(@"%@",self.cells);
}


-(NSMutableArray *)categories{
    if (!_categories) {
        _categories = [[NSMutableArray alloc] init];
        [_categories addObject:[self capsulesInCategory:@"互联网账户"]];
        [_categories addObject:[self capsulesInCategory:@"信用卡"]];
    }
    return _categories;
}

-(NSArray *)capsulesInCategory:(NSString *)category{
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (PCCapsule *cell in self.cells) {
        if ([cell.category isEqualToString:category]) {
            [cells addObject:cell];
        }
    }
    return cells;
}

#pragma mark - tableview date source delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.categories count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *category = self.categories[section];
    return [category count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"互联网账户";
    }
    if (section == 1) {
        return @"信用卡";
    }
    return @"unkonw";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"prototype";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    NSArray *cells = self.categories[indexPath.section];
    PCCapsule *capsule = [cells objectAtIndex:indexPath.row];
    cell.textLabel.text = capsule.title;

    return cell;

}

#pragma mark - segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if(indexPath){
        if([segue.identifier isEqualToString:@"showCellDetail"]){
            
            if ([segue.destinationViewController isKindOfClass:[PCCapsuleDetailVC class]]){
                PCCapsuleDetailVC *cdvc = [segue destinationViewController];
                NSArray *cells = self.categories[indexPath.section];
                PCCapsule *capsule = [cells objectAtIndex:indexPath.row];
                cdvc.capsule = capsule;
            }
        }
    }
}

@end
