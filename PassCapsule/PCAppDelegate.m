//
//  AppDelegate.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/4/16.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCAppDelegate.h"
#import "IQKeyboardManager.h"
#import <objc/runtime.h>
#import "PCKeyChainCapsule.h"

@implementation UIView (testSwizzling)

- (void)myAddSubview:(UIView *)view{
    NSLog(@"加了一个view了,%@",view);
    [self myAddSubview:view];
}

@end

@interface PCAppDelegate ()

@end

@implementation PCAppDelegate
+(void)load{
    //!!!:尝试method swizzling，记得删掉
//    Method origin = class_getInstanceMethod([UIView class], @selector(addSubview:));
//    Method swizzling = class_getInstanceMethod([UIView class], @selector(myAddSubview:));
//    method_exchangeImplementations(origin, swizzling);
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
//    

//    
//    BOOL isFirst = YES;
//    BOOL isLogin = NO;
//    
//    if (isFirst) {
//        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
//        [self.window makeKeyAndVisible];
//    } else if(!isLogin){
//        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        [self.window makeKeyAndVisible];
//    }
    

//    [[IQKeyboardManager sharedManager] setEnable:YES];
//    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:50];

    [self setUserDefaults];

    return YES;
}

- (void)setUserDefaults{
    NSUserDefaults *userDefault= [NSUserDefaults standardUserDefaults];
    [userDefault registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:@YES,@"isFirstLaunch", @NO,@"isCreateDatabase" ,nil]];
    
    NSString *lastVersion = [userDefault stringForKey:@"lastVersion"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!lastVersion) {
        [userDefault registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:currentVersion,@"lastVersion", nil]];
    } else if(![lastVersion isEqualToString:currentVersion]){
        [userDefault setBool:YES forKey:@"isFirstLaunch"];
        [userDefault setObject:currentVersion forKey:@"lastVersion"];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstLaunch"];
    }
//    [PCKeyChainCapsule deleteStringForKey:KEYCHAIN_PASSWORD andServiceName:KEYCHAIN_PASSWORD_SERVICE];
}

@end
