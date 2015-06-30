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

#import "PCDocumentManager.h"
#include "PCDocumentDatabase.h"


@interface PCCategoryTableVC()

@property (nonatomic,strong) NSMutableArray *groups;
@property (nonatomic,strong) NSMutableArray *entries;

@end

@implementation PCCategoryTableVC


-(void)viewDidLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didloadCellDataSource:) name:NOTIFICATION_PARSER_DONE object:nil];
    
    PCDocumentManager *manager = [PCDocumentManager sharedDocumentManager];

    NSString *path = [PCDocumentDatabase documentPath];
    NSLog(@"path = %@",path);
    
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"capsules" ofType:@"xml"];
    
    NSData *xmlData = [NSData dataWithContentsOfFile:path];
    NSLog(@"%@",[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding]);
    [manager parserDocument:xmlData];
    
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didloadCellDataSource: (NSNotification *)notification{
    PCDocumentDatabase *database = [PCDocumentDatabase sharedDocumentDatabase];
    self.groups = database.groups;
    self.entries = database.entries;
    [self.tableView reloadData];
    NSLog(@"groups : %@",[self.groups description]);
    NSLog(@"notifi name : %@",notification.name);
}

- (NSMutableArray *)entries{
    if (!_entries) {
        _entries = [[NSMutableArray alloc] init];
    }
    return _entries;
}

- (NSMutableArray *)groups{
    if (!_groups) {
        _groups = [[NSMutableArray alloc] init];
    }
    return _groups;
}



#pragma mark - tableview date source delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groups count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PCCapsuleGroup *group = self.groups[section];
    return [group.groupEntries count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    PCCapsuleGroup *group = self.groups[section];
    
    if ([group.groupName length] > 0) {
        return group.groupName;
    }
    
    return @"unkonw";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"prototype";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    PCCapsuleGroup *group = self.groups[indexPath.section];
    PCCapsule *capsule = [group.groupEntries objectAtIndex:indexPath.row];
    
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
                PCCapsuleGroup *group = self.groups[indexPath.section];
                PCCapsule *capsule = [group.groupEntries objectAtIndex:indexPath.row];
                cdvc.capsule = capsule;
            }
        }
    }
}

@end
