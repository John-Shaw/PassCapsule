//
//  IntroViewController.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/4/20.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "IntroViewController.h"
#import "EAIntroView.h"
#import "FirstViewController.h"

@interface IntroViewController()
@property (weak, nonatomic) IBOutlet EAIntroView *introView;

@end

@implementation IntroViewController{
    int xLength;
}

-(void)viewDidLoad{
//    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"];
    BOOL isFirst = NO;
    BOOL isLogin = YES;
    if ( isFirst) {
        // basic
        EAIntroPage *page1 = [EAIntroPage page];
        page1.title = @"安全的密码管家";
        page1.titlePositionY = self.view.frame.size.height - 200;
        page1.desc = @"";
        page1.descPositionY = 300;
        page1.bgImage = [UIImage imageNamed:@"bg1" ];
        // custom
        EAIntroPage *page2 = [EAIntroPage page];
        page2.title = @"多用户支持";
        page2.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
        page2.titlePositionY = 400;
        page2.desc = @"";
        page2.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
        page2.descPositionY = 300;
        //   page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
        page2.titleIconPositionY = 100;
        page2.bgImage= [UIImage imageNamed:@"bg2"];
        
        //    custom view from nib
        EAIntroPage *page3 = [EAIntroPage page];
        
        page3.bgImage = [UIImage imageNamed:@"bg3"];
        
        
        [self.introView  setSwipeToExit:NO];
        
        
        NSArray *pages= @[page1,page2,page3];
        self.introView.pageControlY = 60;
        self.introView.skipButton = nil;
        [self.introView setPages:pages];
        
    } else if (isLogin){
        [self.introView hideWithFadeOutDuration:0];
        NSLog(@"%@",self.introView);
      


    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
//    [self performSegueWithIdentifier:@"toLoginView" sender:self];

    
    UITextField *txField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 100, 44)];
    txField.center = CGPointMake(self.view.bounds.size.width/2,
                                 self.view.bounds.size.height/2);
    txField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0];
    txField.layer.cornerRadius = 7;
    [txField setSecureTextEntry:YES];
    xLength = txField.bounds.size.width;
    
    UIButton *unlockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [unlockBtn setOpaque:NO];
    unlockBtn.center = CGPointMake(txField.center.x + txField.frame.size.width/2 + 0, txField.center.y);
    [unlockBtn setBackgroundImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
    [unlockBtn addTarget:self action:@selector(toMainView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:txField];
    [self.view addSubview:unlockBtn];
}

-(void)toMainView:(UIButton *)sender{
    [UIView animateWithDuration:0.75f
                     animations:^{
                         sender.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.75f
                                          animations:^{
                                              sender.center = CGPointMake(sender.center.x - xLength, sender.center.y);
                                          } completion:^(BOOL finished) {
                                              [self performSegueWithIdentifier:@"showMainView" sender:self];
                                          }];
                     }];
    
}

- (IBAction)toRegistView:(UIButton *)sender {
}
- (IBAction)toLoginView:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toLoginView" sender:self];
}


@end
