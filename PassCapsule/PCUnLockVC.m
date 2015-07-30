//
//  LockViewController.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/4/23.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCUnLockVC.h"
#import "PCKeyChainUtils.h"
#import "PCPassword.h"
#import "PCGroupTableVC.h"
#import "PCDocumentDatabase.h"
#import <AVOSCloud/AVOSCloud.h>
#import "PCDocumentManager.h"
#import "PCCloudManager.h"

@interface PCUnLockVC ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *backgroundTextField;
@property (strong, nonatomic) UIButton *unlockBtn;
@end

@implementation PCUnLockVC

//void (^handleUnlockBlock)() = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
//    [[PCCloudManager sharedCloudManager] shouldSyncBy:[PCDocumentDatabase lastModifyDate]];
    [[PCDocumentManager sharedDocumentManager] syncDocumentFormCloudWithUser:[AVUser currentUser]];
}


- (void)setUI{
    self.passwordTextField                 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, 44)];
    self.passwordTextField.center          = CGPointMake(self.view.bounds.size.width/2,
                                                         self.view.bounds.size.height/2);
    self.passwordTextField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0];
    self.passwordTextField.delegate        = self;
    self.passwordTextField.layer.cornerRadius = 7;
    [self.passwordTextField setSecureTextEntry:YES];
    
    self.unlockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.unlockBtn setOpaque:NO];
    self.unlockBtn.center = CGPointMake(self.passwordTextField.center.x + self.passwordTextField.frame.size.width/2 + 0, self.passwordTextField.center.y);
    [self.unlockBtn setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
    [self.unlockBtn addTarget:self action:@selector(toMainView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.unlockBtn];
    //     NSLog(@"%@",[[self.view.subviews objectAtIndex:2] description]);
    
    self.backgroundTextField                     = [[UITextField alloc] initWithFrame:self.passwordTextField.frame];
    self.backgroundTextField.layer.cornerRadius  = 7;
    self.backgroundTextField.backgroundColor     = [UIColor whiteColor];
    self.backgroundTextField.frame               = CGRectMake(self.backgroundTextField.frame.origin.x + self.backgroundTextField.frame.size.width, self.backgroundTextField.frame.origin.y, 0, self.backgroundTextField.frame.size.height);
    
    //关于view的位置，有空要学习。
    [self.view insertSubview:self.backgroundTextField belowSubview:self.unlockBtn];
}



-(void)toMainView:(UIButton *)sender{
    [self.passwordTextField resignFirstResponder];
    
    NSString *password  = self.passwordTextField.text;
    BOOL isTruePassword = NO;
    if ([password length] == 0) {
        NSLog(@"password can't be empty");
        return;
    }
    
    //valid password
    NSString *basePassowrd = [PCKeyChainUtils stringForKey:KEYCHAIN_PASSWORD andServiceName:KEYCHAIN_PASSWORD_SERVICE];
    NSString *hashPasswprd = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:basePassowrd options:NSDataBase64DecodingIgnoreUnknownCharacters] encoding:NSUTF8StringEncoding];
    NSLog(@"base pass = %@",basePassowrd);
    NSLog(@"hash pass = %@",hashPasswprd);
    
    if ([PCPassword validatePassword:password againstHash:hashPasswprd]) {
        isTruePassword = YES;
    }
    [self unlockAnimation:isTruePassword WithDirctionToLef:YES WithBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [PCPassword setPassword:password];
            [self performSegueWithIdentifier:@"showMainView" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入密码"
                                                            message:@"输入密码错误"
                                                           delegate:nil
                                                  cancelButtonTitle:@"好"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
}

/**
 *  解锁动画
 *
 *  @param isSuccess         输入密码是否正确
 *  @param toLeft            移动方向
 *  @param handleUnlockBlock 解锁后的回调函数
 */
- (void)unlockAnimation:(BOOL)isSuccess WithDirctionToLef:(BOOL)toLeft WithBlock:(void (^)(BOOL isSuccess)) handleUnlockBlock {
    //动画完全是靠想象力啊
    //一个纯粹用来遮盖元textfield的有色textfield，用来模拟颜色填充效果
    CGFloat unLockButtonNewCenterX = 0;
    CGFloat backTextFieldNewOriginX = 0;
    CGFloat backTextFieldNewWidth = 0;
    NSTimeInterval delay = 0.25;
    if (toLeft) {
        unLockButtonNewCenterX  = self.unlockBtn.center.x - self.passwordTextField.frame.size.width;
        backTextFieldNewOriginX = self.passwordTextField.frame.origin.x;
        backTextFieldNewWidth   = self.passwordTextField.frame.size.width;
        self.backgroundTextField.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
    } else {
        delay = 0.5;
        unLockButtonNewCenterX  = self.unlockBtn.center.x + self.passwordTextField.frame.size.width;
        backTextFieldNewOriginX = self.passwordTextField.frame.origin.x + self.passwordTextField.frame.size.width;
        backTextFieldNewWidth   = 0;
        self.backgroundTextField.backgroundColor = [UIColor redColor];
    }
    //FIXME:想复用代码，然后装逼失败，各种magic number和奇技淫巧，还是乖乖写两个动画的好，诶
    [UIView animateWithDuration:0.75
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.unlockBtn.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.75f
                                               delay:delay
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.unlockBtn.center = CGPointMake(unLockButtonNewCenterX, self.unlockBtn.center.y);
                                              self.backgroundTextField.frame     = CGRectMake(backTextFieldNewOriginX, self.passwordTextField.frame.origin.y, backTextFieldNewWidth, self.passwordTextField.frame.size.height);
                                              
                                          } completion:^(BOOL finished) {
                                              if(isSuccess){
                                                  handleUnlockBlock(isSuccess);
                                              } else {
                                                  //密码错误时的动画，先和密码真确时一样解锁，然后再返回
                                                  [self unlockAnimation:YES WithDirctionToLef:NO WithBlock:^(BOOL isSuccess){}];
                                              }
                                          }];
                     }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showMainView"]) {
//        PCDocumentParser *aParser = [PCDocumentParser new];
//        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//        NSLog(@"path = %@",documentsPath);
//        NSString *path = [documentsPath stringByAppendingPathComponent:@"tttt.pcdb"];
//        NSLog(@"path = %@",path);
//        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"capsules" ofType:@"xml"];
//        NSData *xmlData = [NSData dataWithContentsOfFile:path1];
//        [aParser parser:xmlData];
//        PCDocumentDatabase *datebase = [PCDocumentDatabase sharedDocumentDatabase];
//        UITabBarController *tabBarC = segue.destinationViewController;
//        UINavigationController *naviC = tabBarC.viewControllers[0];
//        
//        PCCategoryTableVC *tableVC = naviC.viewControllers[0];
//        
//        tableVC.entryArray = datebase.entries;
    }

}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self toMainView:self.unlockBtn];
}




@end
