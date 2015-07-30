//
//  PCRegistVC.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/26.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCRegistVC.h"
//#import "AFNetworking.h"
#import "PCCloudManager.h"

@interface PCRegistVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation PCRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)regist:(UIBarButtonItem *)sender {
    if ([self validInput]) {
        NSString *name = self.nameTextField.text;
        NSString *password = self.passwordTextField.text;
        [PCCloudUser registerUserWithUserName:name Password:password andOtherOptions:nil];
        BOOL success = YES;
        if (success) {
            [self performSegueWithIdentifier:@"toCreateDatabaseView" sender:self];
        }
    }
}


- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (BOOL)validInput{
    if ([self.nameTextField.text length] == 0
        || [self.passwordTextField.text length] == 0
        || [self.confirmPasswordTextField.text length] == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册新用户"
                                                        message:@"该项不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册新用户"
                                                        message:@"密码不一致"
                                                       delegate:nil
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil];
        [alert show];

        return NO;
    }
    return YES;
}




- (IBAction)registCommit:(UIButton *)sender {
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    NSDictionary *parameters = @{@"username":@"aaaaaaaa",@"challengekey":@"12345",@"userid":@"2009"};
//    
//    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
//    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    //    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    manager.requestSerializer = serializer;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    //    NSLog(@"%@",parameters);
//    [manager POST:@"http://10.16.23.25:5555/useradd" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"JSON:%@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"ERROR: %@",error);
//    }];

}


@end
