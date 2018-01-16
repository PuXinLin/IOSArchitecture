//
//  JY_MonitorNewWork.h
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JY_NetWork.h"

static NSString * const NetWorkStateChangeName = @"NetWorkStateChangeName"; // 网络改变通知

/* 网络改变函数 */
typedef void (^NetWorkStateBlock)(DetectionNetworkType statue);

@interface JY_MonitorNewWork : NSObject

/* 当前网络是否可用 */
@property (nonatomic, assign, readonly) BOOL isNetwork;
/* 当前网络状态 */
@property (nonatomic ,assign, readonly)DetectionNetworkType currentNetworkType;
/* 移动数据网络状态 */
@property (nonatomic ,assign, readonly)DetectionNetworkReachableViaWWANType currentReachableViaWWANType ;

/**
 * 初始化
 */
+ (instancetype)sharedRequestInstance;

/**
 * 开启监听网络状态
 */
+ (void)starNetWorkStateDetection;

/**
 * 关闭监听网络状态 (建议在程序将要进入后台时调用)
 */
+ (void)cancleNetWorkStateDetection;

/**
 * 获取网络状态
 */
-(DetectionNetworkType)getNetworkType;
/**
 * 获取移动数据网络状态
 */
-(DetectionNetworkReachableViaWWANType)getNetworkReachableViaWWANType;

@end
