//
//  JY_HttpRequest.h
//  JYProject
//
//  Created by dayou on 2017/7/27.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 网络状态 */
typedef NS_ENUM(NSInteger, DetectionNetworkState) {
    knownNetwork,
    NoNetwork,
    OneselfGNetwork,
    WIFINetwork,
};
/* 请求状态 */
typedef NS_ENUM(NSInteger, MethodState) {
    Method_GET,
    Method_POST,
};

/* 请求完成回调块 */
typedef void(^ITFinishedBlock)(id responseObject);

/* ---------------------JY_HttpRequest--------------------- */

@interface JY_HttpRequest : NSObject

/**
 * 数据请求
 *
 * @param URLString 数据接口
 * @param parameters 请求参数集合
 * @param method 请求方式 (get or post)
 * @param finishedBlock 请求完成回调
 */
+ (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (MethodState)method
                    callBack: (ITFinishedBlock)finishedBlock;
/**
 * 取消所有数据请求
 */
+ (void)cancleAllRequest;

/**
 * 监听网络状态
 */
+(void)netWorkStateDetection;

@end
