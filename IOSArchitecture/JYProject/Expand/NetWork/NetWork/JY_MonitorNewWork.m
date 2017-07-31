//
//  JY_MonitorNewWork.m
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_MonitorNewWork.h"

@interface JY_MonitorNewWork()
@property (nonatomic ,assign, readwrite)DetectionNetworkType currentNetworkType;
@end

@implementation JY_MonitorNewWork

+ (instancetype)sharedRequestInstance {
    static JY_MonitorNewWork *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[JY_MonitorNewWork alloc]init];
        __sharedInstance.currentNetworkType = OneselfGNetwork;
    });
    return __sharedInstance;
}


#pragma mark ---------- Public Methods ----------
#pragma mark 监听网络状态
+ (void)starNetWorkStateDetection:(NetWorkStateBlock)state{
    __weak AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    [manger startMonitoring]; // 开始监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DetectionNetworkType networkType;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkType = knownNetwork;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkType = NoNetwork;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkType = OneselfGNetwork;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkType = WIFINetwork;
                break;
            default:
                break;
        }
        if (state!=nil) {
            state(networkType);
        }
        [JY_MonitorNewWork sharedRequestInstance].currentNetworkType = networkType;
    }];
}

#pragma mark 关闭监听网络状态
+(void)cancleNetWorkStateDetection{
    __weak AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    [manger stopMonitoring]; // 关闭监听改变
}

#pragma mark ---------- Private Methods ----------
#pragma mark 配置Model
-(void)configurationModel{}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
