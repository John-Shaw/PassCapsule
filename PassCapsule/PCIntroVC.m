//
//  IntroViewController.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/4/20.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCIntroVC.h"
#import "EAIntroView.h"
#import "PCXMLParser.h"


@interface PCIntroVC()
@property (weak, nonatomic) IBOutlet EAIntroView *introView;
@end

@implementation PCIntroVC
-(void)viewDidLoad{

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
    [self.introView setUseMotionEffects:YES];
    

}



@end
