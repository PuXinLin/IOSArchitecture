//
//  AppDelegate.m
//  App
//
//  Created by Mihaela Mihaljević Jakić on 03/02/15.
//  Copyright (c) 2015 Mihaela Mihaljević Jakić. All rights reserved.
//

#import "AppDelegate.h"
/* 成员一 导入 */
#import "PXLHomeViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation AppDelegate


#pragma mark ---------- Life Cycle ----------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)askForLocalNotifications:(UIApplication *)application;
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
    [application registerUserNotificationSettings:settings];
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    /* 关闭网络监听 */
    [JY_MonitorNewWork cancleNetWorkStateDetection];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /* 开启网络改变监听 */
    [JY_MonitorNewWork starNetWorkStateDetection:^(DetectionNetworkType statue) {
        switch (statue) {
            case knownNetwork:
                JY_Log(@"未知网络");
                break;
            case NoNetwork:
                JY_Log(@"无数据连接");
                break;
            case OneselfGNetwork:
                JY_Log(@"已切换至数据流量");
                break;
            case WIFINetwork:
                JY_Log(@"已切换至WIF环境");
                break;
            default:
                break;
        }

    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark ---------- Private Methods ----------

#pragma mark ---------- Lazy Load ----------

- (UINavigationController *)navigationController
{
    if (!_navigationController) {
        _navigationController = [[UINavigationController alloc] initWithRootViewController:[[PXLHomeViewController alloc] init]];
    }
    
    return _navigationController;
}

@end
