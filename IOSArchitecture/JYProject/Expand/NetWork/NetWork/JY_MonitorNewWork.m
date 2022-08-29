//
//  JY_MonitorNewWork.m
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_MonitorNewWork.h"
#import <CoreTelephony/CoreTelephonyDefines.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

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
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        return 5;
    } else if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi){
        NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                                   CTRadioAccessTechnologyGPRS,
                                   CTRadioAccessTechnologyCDMA1x];
     
        NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                                   CTRadioAccessTechnologyWCDMA,
                                   CTRadioAccessTechnologyHSUPA,
                                   CTRadioAccessTechnologyCDMAEVDORev0,
                                   CTRadioAccessTechnologyCDMAEVDORevA,
                                   CTRadioAccessTechnologyCDMAEVDORevB,
                                   CTRadioAccessTechnologyeHRPD];
        
        NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE];
        
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([typeStrings4G containsObject:accessString]) {
            // @"4G";
            return 3;
        } else if ([typeStrings3G containsObject:accessString]) {
            // @"3G";
            return 2;
        } else if ([typeStrings2G containsObject:accessString]) {
            // @"2G";
            return 1;
        } else {
            // @"无网络";
            return 0;
        }
    } else {
        return 0;
    }
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
