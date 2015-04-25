//
//  LockViewController.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/4/23.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "LockViewController.h"

@interface LockViewController ()
@property (strong, nonatomic) UITextField *txField;
@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, 44)];
    self.txField.center = CGPointMake(self.view.bounds.size.width/2,
                                      self.view.bounds.size.height/2);
    self.txField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0];
    self.txField.layer.cornerRadius = 7;
    [self.txField setSecureTextEntry:YES];
    
    UIButton *unlockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [unlockBtn setOpaque:NO];
    unlockBtn.center = CGPointMake(self.txField.center.x + self.txField.frame.size.width/2 + 0, self.txField.center.y);
    [unlockBtn setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
    [unlockBtn addTarget:self action:@selector(toMainView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    UITextField *backTx = [[UITextField alloc] initWithFrame:self.txField.frame];
    //    backTx.layer.cornerRadius = 7;
    //    backTx.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0];
    //    [self.view addSubview:backTx];
    
    [self.view addSubview:self.txField];
    [self.view addSubview:unlockBtn];
    //     NSLog(@"%@",[[self.view.subviews objectAtIndex:2] description]);
    
}
-(void)toMainView:(UIButton *)sender{
    //动画完全是靠想象力啊
    UITextField *backTx = [[UITextField alloc] initWithFrame:self.txField.frame];
    backTx.layer.cornerRadius = 7;
    backTx.backgroundColor = [UIColor blueColor];
    backTx.frame = CGRectMake(backTx.frame.origin.x + backTx.frame.size.width, backTx.frame.origin.y, 0, backTx.frame.size.height);
    [self.view addSubview:backTx];
    
    //关于view的位置，有空要学习。
    [self.view insertSubview:backTx atIndex:3];
    //    NSLog(@"%lu",(unsigned long)[self.view.subviews indexOfObject:backTx]);
    
    [UIView animateWithDuration:0.75f
                     animations:^{
                         sender.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.75f
                                          animations:^{
                                              sender.center = CGPointMake(sender.center.x - self.txField.frame.size.width, sender.center.y);
                                              //                                              self.txField.backgroundColor = [UIColor greenColor];
                                              backTx.frame = CGRectMake(self.txField.frame.origin.x, self.txField.frame.origin.y, self.txField.frame.size.width, 44);
                                              
                                          } completion:^(BOOL finished) {
                                              [self performSegueWithIdentifier:@"showMainView" sender:self];
                                          }];
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
