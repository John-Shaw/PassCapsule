//
//  ZZCategoryTableViewController.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/4/26.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCGroupTableVC.h"
#import "PCXMLParser.h"
#import "PCCapsule.h"
#import "PCEntryViewController.h"

#import "PCDocumentManager.h"
#include "PCDocumentDatabase.h"


@interface PCGroupTableVC()

@property (nonatomic,strong) NSMutableArray *groups;
@property (nonatomic,strong) NSMutableArray *entries;
@property (nonatomic,strong) UIActivityIndicatorView *aSpinner;

@end

@implementation PCGroupTableVC


-(void)viewDidLoad{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didloadCellDataSource:) name:NOTIFICATION_SHOULD_RELOAD object:nil];
    
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.aSpinner = tempSpinner;
    
    [self.view addSubview:self.aSpinner];
    [self.aSpinner startAnimating];
    
    dispatch_queue_t loadDocumentQueue = dispatch_queue_create(LOAD_DOCUMENT_QUEUE, DISPATCH_QUEUE_SERIAL);
    dispatch_async(loadDocumentQueue, ^{
        PCDocumentManager *manager = [PCDocumentManager sharedDocumentManager];
        NSString *path = [PCDocumentDatabase documentPath];
        NSLog(@"path = %@",path);
        NSData *xmlData = [NSData dataWithContentsOfFile:path];
        NSLog(@"%@",[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding]);
        [manager parserDocument:xmlData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOULD_RELOAD object:nil];
        });
    });
    
//    //kvo
//    [[PCDocumentDatabase sharedDocumentDatabase]  addObserver:self
//                                                  forKeyPath:@"entries"
//                                                     options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
//                                                     context:@"this is a context"];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[PCDocumentDatabase sharedDocumentDatabase] removeObserver:self forKeyPath:@"entries"];
}

- (void)didloadCellDataSource: (NSNotification *)notification{
    PCDocumentDatabase *database = [PCDocumentDatabase sharedDocumentDatabase];
    self.groups = database.groups;
    self.entries = database.entries;
    
    [self.tableView reloadData];
    [self.aSpinner stopAnimating];
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


//暂时用 Notification 足够
//#pragma mark - kvo
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    NSLog(@"object is :%@",[object description]);
//    NSLog(@"old: %@", [change objectForKey:NSKeyValueChangeOldKey]);
//    NSLog(@"new: %@", [change objectForKey:NSKeyValueChangeNewKey]);
//    NSLog(@"context: %@", context);
//    [self.tableView reloadData];
//}

//#pragma mark - editing mode
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
//    [super setEditing:editing animated:animated];
//
//}

#pragma mark - tableview delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    if ([tableView isEqual:self.tableView]) {
        style = UITableViewCellEditingStyleDelete;
    }
    return style;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PCCapsuleGroup *group = self.groups[indexPath.section];
        PCCapsule *entry = group.groupEntries[indexPath.row];
        [[PCDocumentManager sharedDocumentManager] deleteEntry:entry];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
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
            if ([segue.destinationViewController isKindOfClass:[PCEntryViewController class]]){
                PCEntryViewController *cdvc = [segue destinationViewController];
                PCCapsuleGroup *group = self.groups[indexPath.section];
                PCCapsule *capsule = [group.groupEntries objectAtIndex:indexPath.row];
                cdvc.capsule = capsule;
            }
        }
    }
}

@end
