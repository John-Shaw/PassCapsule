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

@implementation IntroViewController

-(void)viewDidLoad{
    // basic
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"test1";
    page1.bgImage = [UIImage imageNamed:@"intro1" ];
    // custom
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
    page2.titlePositionY = 220;
    page2.desc = @"test2";
    page2.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
    page2.descPositionY = 200;
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    page2.titleIconPositionY = 100;
    page2.bgImage= [UIImage imageNamed:@"intro2"];
    
    // custom view from nib
    //    EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage"];
    //    page3.bgImage = [UIImage imageNamed:@"bg2"];
    
    NSArray *pages= @[page1,page2];
    
    [self.introView setPages:pages];
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

@end
