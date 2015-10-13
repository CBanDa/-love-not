//
//  AppDelegate.m
//  爱普笔记
//
//  Created by ldci on 14-1-2.
//  Copyright (c) 2014年 CC. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "HomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    BOOL check = [[NSUserDefaults standardUserDefaults] boolForKey:@"firstTime"];
    if (check == NO){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTime"];
        [NSUserDefaults resetStandardUserDefaults];
        MainViewController *main = [[MainViewController alloc]init];
        self.window.rootViewController =main;
    }else{
        HomeViewController *home = [[HomeViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:home];
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

// 程序接受本地消息
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIApplicationState state = application.applicationState;
    
    if (state == UIApplicationStateActive) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertAction message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
        if (application.applicationIconBadgeNumber > 0) {
            
            application.applicationIconBadgeNumber -= 1;
            
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
