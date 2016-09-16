//
//  AppDelegate.m
//  DGLWebView
//
//  Created by 丁贵林 on 9/14/16.
//  Copyright © 2016 丁贵林. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    return YES;
}


@end
