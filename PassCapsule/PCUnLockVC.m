//
//  LockViewController.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/4/23.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCUnLockVC.h"
#import "PCKeyChainCapsule.h"
#import "PCPassword.h"

@interface PCUnLockVC ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *txField;
@property (strong, nonatomic) UITextField *backTx;
@property (strong, nonatomic) UIButton *unlockBtn;
@end

@implementation PCUnLockVC

//void (^handleUnlockBlock)() = nil;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.txField                 = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, 44)];
    self.txField.center          = CGPointMake(self.view.bounds.size.width/2,
                                      self.view.bounds.size.height/2);
    self.txField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0];
    self.txField.delegate        = self;
    self.txField.layer.cornerRadius = 7;
    [self.txField setSecureTextEntry:YES];

    self.unlockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.unlockBtn setOpaque:NO];
    self.unlockBtn.center = CGPointMake(self.txField.center.x + self.txField.frame.size.width/2 + 0, self.txField.center.y);
    [self.unlockBtn setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
    [self.unlockBtn addTarget:self action:@selector(toMainView:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.txField];
    [self.view addSubview:self.unlockBtn];
    //     NSLog(@"%@",[[self.view.subviews objectAtIndex:2] description]);

    self.backTx                     = [[UITextField alloc] initWithFrame:self.txField.frame];
    self.backTx.layer.cornerRadius  = 7;
    self.backTx.backgroundColor     = [UIColor whiteColor];
    self.backTx.frame               = CGRectMake(self.backTx.frame.origin.x + self.backTx.frame.size.width, self.backTx.frame.origin.y, 0, self.backTx.frame.size.height);

    //关于view的位置，有空要学习。
    [self.view insertSubview:self.backTx belowSubview:self.unlockBtn];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self toMainView:self.unlockBtn];
}

-(void)toMainView:(UIButton *)sender{
    NSString *password  = self.txField.text;
    BOOL isTruePassword = NO;
    if ([password length] == 0) {
        NSLog(@"password can't be empty");
        return;
    }
    
    //valid password for test

    NSString *encryptedString = [PCKeyChainCapsule stringForKey:KEYCHAIN_PASSWORD andServiceName:KEYCHAIN_PASSWORD_SERVICE];
    NSLog(@"pass from keychain = %@",encryptedString);
    if ([password isEqualToString:[PCPassword decryptedStringWithPassword:encryptedString]]) {
        isTruePassword = YES;
    }
    [self unlockAnimation:isTruePassword WithDirctionToLef:YES WithBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [PCKeyChainCapsule setString:self.txField.text forKey:KEYCHAIN_PASSWORD andServiceName:KEYCHAIN_PASSWORD_SERVICE];
            [self performSegueWithIdentifier:@"showMainView" sender:self];
        } else {
            NSLog(@"password is wrong");
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
    NSTimeInterval delay = 0;
    if (toLeft) {
        unLockButtonNewCenterX  = self.unlockBtn.center.x - self.txField.frame.size.width;
        backTextFieldNewOriginX = self.txField.frame.origin.x;
        backTextFieldNewWidth   = self.txField.frame.size.width;
        self.backTx.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
    } else {
        delay = 0.25;
        unLockButtonNewCenterX  = self.unlockBtn.center.x + self.txField.frame.size.width;
        backTextFieldNewOriginX = self.txField.frame.origin.x + self.txField.frame.size.width;
        backTextFieldNewWidth   = 0;
        self.backTx.backgroundColor = [UIColor redColor];
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
                                              self.backTx.frame     = CGRectMake(backTextFieldNewOriginX, self.txField.frame.origin.y, backTextFieldNewWidth, self.txField.frame.size.height);
                                              
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
