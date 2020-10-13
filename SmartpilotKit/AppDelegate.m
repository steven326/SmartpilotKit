//
//  AppDelegate.m
//  SmartpilotKit
//
//  Created by 王泽平 on 2020/9/30.
//

#import "AppDelegate.h"
#import "SPMomentListViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[SPMomentListViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
