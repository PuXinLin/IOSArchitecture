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
#import "JY_TabBarController.h"

@interface AppDelegate ()

@property (nonatomic, strong)JY_TabBarController *tabbarController;

@end

@implementation AppDelegate


#pragma mark ---------- Life Cycle ----------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.window.rootViewController = self.tabbarController;
    [self.window makeKeyAndVisible];
    /* 网络监听 */
    [self starNetWorkStateDetection];
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

- (void)applicationDidBecomeActive:(UIApplication *)application{}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark ---------- Private Methods ----------
#pragma mark 网络监听
-(void)starNetWorkStateDetection
{
    [JY_MonitorNewWork starNetWorkStateDetection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetWorkStateChange:) name:NetWorkStateChangeName object:nil];
}
#pragma mark 网络改变监听
-(void)NetWorkStateChange:(NSNotification*)notification
{
    DetectionNetworkType statue = [notification.object integerValue];
    switch (statue) {
        case DetectionNetworkTypeNoNetwork:
            JY_Log(@"无数据连接");
            break;
        case DetectionNetworkTypeOneselfGNetwork:
            JY_Log(@"已切换至数据流量");
            break;
        case DetectionNetworkTypeWIFINetwork:
            JY_Log(@"已切换至WIF环境");
            break;
        default:
            break;
    }
}
#pragma mark ---------- Lazy Load ----------

- (JY_TabBarController *)tabbarController
{
    if (!_tabbarController) {
        _tabbarController = [[JY_TabBarController alloc]init];
    }
    return _tabbarController;
}

@end
