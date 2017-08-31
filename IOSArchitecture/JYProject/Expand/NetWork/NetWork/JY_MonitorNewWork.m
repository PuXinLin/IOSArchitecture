//
//  JY_MonitorNewWork.m
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_MonitorNewWork.h"

@interface JY_MonitorNewWork()
@property (nonatomic, assign, readwrite) BOOL isNetwork;
@property (nonatomic ,assign, readwrite)DetectionNetworkType currentNetworkType;
@property (nonatomic ,assign, readwrite)DetectionNetworkReachableViaWWANType currentReachableViaWWANType ;
@end

@implementation JY_MonitorNewWork

+ (instancetype)sharedRequestInstance
{
    static JY_MonitorNewWork *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[JY_MonitorNewWork alloc]init];
    });
    return __sharedInstance;
}


#pragma mark ---------- Public Methods ----------
#pragma mark 监听网络状态
+ (void)starNetWorkStateDetection
{
    JY_MonitorNewWork *monitorNewWork = [JY_MonitorNewWork sharedRequestInstance];
    /* 获取网络状态 */
    monitorNewWork.currentNetworkType = [monitorNewWork getNetworkType];
    if (monitorNewWork.currentNetworkType == DetectionNetworkTypeNoNetwork) {
        monitorNewWork.isNetwork = NO;
    }
    else{
        monitorNewWork.isNetwork = YES;
    }
    /* 开始监听 */
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DetectionNetworkType networkType;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkType = DetectionNetworkTypeNoNetwork;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkType = DetectionNetworkTypeNoNetwork;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkType = DetectionNetworkTypeOneselfGNetwork;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkType = DetectionNetworkTypeWIFINetwork;
                break;
            default:
                break;
        }
        if (networkType != DetectionNetworkTypeNoNetwork) {
            monitorNewWork.isNetwork = YES;
        }
        else{
            monitorNewWork.isNetwork = NO;
        }
        /* 通知 网络状态改变 */
        if (networkType != monitorNewWork.currentNetworkType) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NetWorkStateChangeName object:@(networkType)];
            monitorNewWork.currentNetworkType = networkType;
        }
    }];
    [manger startMonitoring];
}

#pragma mark 关闭监听网络状态
+(void)cancleNetWorkStateDetection
{
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    [manger stopMonitoring];
}

#pragma mark ---------- Private Methods ----------
#pragma mark 获取网络状态
-(DetectionNetworkType)getNetworkType
{
    int state = [self getStatusBarNetWorkStates];
    DetectionNetworkType type = DetectionNetworkTypeNoNetwork;
    switch (state) {
        case 0:
            type = DetectionNetworkTypeNoNetwork;
            break;
        case 1:case 2:case 3:
            type = DetectionNetworkTypeOneselfGNetwork;
            break;
        case 5:
            type =  DetectionNetworkTypeWIFINetwork;
            break;
    }
    return type;
}
#pragma mark 获取移动数据网络状态
-(DetectionNetworkReachableViaWWANType)getNetworkReachableViaWWANType
{
    int state = [self getStatusBarNetWorkStates];
    DetectionNetworkReachableViaWWANType type = DetectionNetworkReachableViaWWANType4G;
    switch (state) {
        case 1:
            type = DetectionNetworkReachableViaWWANType2G;
            break;
        case 2:
            type = DetectionNetworkReachableViaWWANType3G;
            break;
        case 3:
            type = DetectionNetworkReachableViaWWANType4G;
            break;
        default:
            break;
    }
    return type;
}
#pragma mark 获取状态栏网络状态 导航栏隐藏无法获取
- (int)getStatusBarNetWorkStates
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    int state = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            state = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    return state;
}
#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
