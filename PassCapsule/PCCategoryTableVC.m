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

@implementation PCCategoryTableVC

-(void)viewDidLoad{
    PCXMLParser *aPaser = [PCXMLParser new];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"capsules" ofType:@"xml"];

    self.cells = [aPaser paserWithPath:path];
    
    NSLog(@"%@",self.cells);
}

//-(NSMutableArray *)cells{
//    if (!_cells) {
//        _cells = [[NSMutableArray alloc] init];
//    }
//    return _cells;
//}


#pragma mark - tableview date source delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.cells count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"prototype";
    
    /*
     Retrieve a cell with the given identifier from the table view.
     The cell is defined in the main storyboard: its identifier is MyIdentifier, and  its selection style is set to None.
     */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // Set up the cell.
//    NSString *timeZoneName = [self.timeZoneNames objectAtIndex:indexPath.row];
//    cell.textLabel.text = timeZoneName;
    
    PCCapsule *capsule = [self.cells objectAtIndex:indexPath.row];
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
                PCCapsule *capsule = [self.cells objectAtIndex:indexPath.row];
                
                cdvc.capsule = capsule;
//                cdvc.titleLabel = capsule.title;
//                cdvc.detailLabel = capsule.site;
//                cdvc.imageName = @"lock_error";
                
            }
        }
    }
}

@end
