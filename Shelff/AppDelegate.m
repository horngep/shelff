//
//  AppDelegate.m
//  Shelff
//
//  Created by I-Horng Huang on 29/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <Parse/PFSubclassing.h>
#import "PFCustomer.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    [FBProfilePictureView class];
    
    [PFCustomer registerSubclass]; // this PFCustomer exist only for using "currentCustomer" method (in PFCustomer.h)

    [Parse setApplicationId:@"kNZxe4XdPZqq9ep6lb45tZ4Ht4A3wH2HBbDI08xJ"
                  clientKey:@"GvOR5KkqmRg1BFzOYu3lGEtUA0O2zbKGxGkfMxKe"];

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions]; //for tracking statisticv

    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.19 green:0.14 blue:0.2 alpha:1]];

    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:1.0 alpha:1.0]];

    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return YES;
}

#pragma mark - Handling the Response from the Facebook app
//overiding
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];

    // You can add your app-specific url handling code here if needed

    return wasHandled;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];

}

#pragma mark - unrelated
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





@end
