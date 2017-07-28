//
//  JY_HttpRequestConfiguration.h
//  JYProject
//
//  Created by dayou on 2017/7/28.
//  Copyright © 2017年 dayou. All rights reserved.
//
#import <Foundation/Foundation.h>

/* 网络状态 */
typedef NS_ENUM(NSInteger, DetectionNetworkState) {
    knownNetwork = -1, // 未知
    NoNetwork, // 无连接
    OneselfGNetwork, // 数据流量
    WIFINetwork, // 局域网络
};
/* 请求状态 */
typedef NS_ENUM(NSInteger, MethodState) {
    Method_GET,
    Method_POST,
};

/********************** 公共回调块 **********************/
/* 请求完成回调函数 */
typedef void(^ITFinishedBlock)(id responseObject);

/* 网络改变状态回调函数 */
typedef void (^NetWorkStateBlock)(DetectionNetworkState statue);
