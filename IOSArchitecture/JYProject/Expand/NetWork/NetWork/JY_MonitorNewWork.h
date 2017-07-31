//
//  JY_MonitorNewWork.h
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 网络状态 */
typedef NS_ENUM(NSInteger, DetectionNetworkType) {
    knownNetwork = -1, // 未知
    NoNetwork, // 无连接
    OneselfGNetwork, // 数据流量
    WIFINetwork, // 局域网络
};

/* 网络改变函数 */
typedef void (^NetWorkStateBlock)(DetectionNetworkType statue);

@interface JY_MonitorNewWork : NSObject

+ (instancetype)sharedRequestInstance;

/**
 * 监听网络状态 (建议在程序进入前台时调用)
 *
 * @pram state 根据需求设置 传nil 单纯监听网络
 */
+ (void)starNetWorkStateDetection:(NetWorkStateBlock)state;

/**
 * 关闭监听网络状态 (建议在程序将要进入后台时调用)
 */
+ (void)cancleNetWorkStateDetection;

/* 当前网络状态 */
@property (nonatomic ,assign, readonly)DetectionNetworkType currentNetworkType;

@end
