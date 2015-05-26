//
//  PCRegistVC.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/26.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCRegistVC.h"
#import "AFNetworking.h"

@interface PCRegistVC ()

@end

@implementation PCRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)registCommit:(UIButton *)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"username":@"aaaaaaaa",@"challengekey":@"12345",@"userid":@"2009"};
    
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //    NSLog(@"%@",parameters);
    [manager POST:@"http://10.16.23.25:5555/useradd" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON:%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ERROR: %@",error);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
