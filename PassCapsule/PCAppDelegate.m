//
//  AppDelegate.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/4/16.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCAppDelegate.h"
#import "IQKeyboardManager.h"
#import "PCKeyChainUtils.h"
#import "PCDocumentManager.h"
#import "PCCloudManager.h"


static NSString * const USERDEFAULT_LAUNCH_FIRST = @"isFirstLaunch";

@implementation PCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUserDefaults];
    
    
    //!!!: leanCloud 需要注册子类，才能自动生成setter，getter
    [PCCloudDatabase registerSubclass];
    [PCCloudEntry registerSubclass];
    [PCCloudGroup registerSubclass];
    
    // leanCloud 服务
    [AVOSCloud setApplicationId:@"o50yd5db8ue6a14o5hl1ct5x97htfpo4n7tkeblp4nenv9w3"
                      clientKey:@"qlo1yfui14w8pcdpynu2ja4sqejq4no7ekxxkw9efcskwu0w"];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;

    BOOL isDataBaseCreate = [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_DATABASE_CREATE];
    if (isDataBaseCreate) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"UnlockViewController"];
        [self.window makeKeyAndVisible];
    }
    
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser) {
        NSString *cloudID = [currentUser objectForKey:CLOUD_DATABASE_ID];
        if (cloudID) {
            [PCDocumentDatabase sharedDocumentDatabase].cloudID = cloudID;
            PCCloudManager *manager = [PCCloudManager sharedCloudManager];
            manager.cloudDatabase = [manager queryCloudDatabaseByID:cloudID];
        }
    }
    
//    NSString *path = [PCDocumentDatabase documentPath];
//    NSData *xmlData = [NSData dataWithContentsOfFile:path];
//    [[PCDocumentManager sharedDocumentManager] preLoadDocunent:xmlData];
//    
    return YES;
}

- (void)setUserDefaults{
    NSUserDefaults *userDefault= [NSUserDefaults standardUserDefaults];
    [userDefault registerDefaults:@{USERDEFAULT_LAUNCH_FIRST:@YES, USERDEFAULT_DATABASE_CREATE:@NO }];

    NSString *lastVersion = [userDefault stringForKey:@"lastVersion"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!lastVersion) {
        [userDefault registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:currentVersion,@"lastVersion", nil]];
    } else if(![lastVersion isEqualToString:currentVersion]){
        [userDefault setBool:YES forKey:USERDEFAULT_LAUNCH_FIRST];
        [userDefault setObject:currentVersion forKey:@"lastVersion"];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[PCDocumentManager sharedDocumentManager] saveDocument];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[PCDocumentManager sharedDocumentManager] saveDocument];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_LAUNCH_FIRST]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:USERDEFAULT_LAUNCH_FIRST];
    }
    
    [[PCDocumentManager sharedDocumentManager] saveDocument];
    [PCKeyChainUtils deleteStringForKey:KEYCHAIN_KEY andServiceName:KEYCHAIN_KEY_SERVICE];
}

@end
