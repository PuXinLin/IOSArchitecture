//
//  JY_HttpRequestConfiguration.h
//  JYProject
//
//  Created by dayou on 2017/7/28.
//  Copyright © 2017年 dayou. All rights reserved.
//
#import <Foundation/Foundation.h>

#define JY_RequestError       @"网络请求错误，请重试"
#define JY_RequestOutTime     @"请求超时"
#define JY_RequestNoNetwork   @"暂无网络，请稍后再试"
#define JY_RequestLoading     @"正在加载，请稍后..."

/* 请求状态 */
typedef NS_ENUM(NSInteger, JYRequestMethodType) {
    JYRequestMethod_GET = 0,
    JYRequestMethod_POST,
    JYRequestMethod_Upload,
};

/* 响应状态状态 */
typedef NS_ENUM (NSUInteger, JYResponseErrorType){
    JYResponseErrorTypeDefault,    //API请求失败的默认状态。
    JYResponseErrorTypeDataCache,  //数据缓存
    JYResponseErrorTypeSuccess,    //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    JYResponseErrorTypeNoContent,  //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    JYResponseErrorTypeTimeout,    //请求超时。JY_HttpProxy设置的是10秒超时，具体超时时间的设置请自己去看JY_HttpProxy的相关代码。
    JYResponseErrorTypeNoNetWork,  //网络不通。在调用API之前会判断一下当前网络是否通畅，没有产生过API请求
    JYResponseErrorTypeParamsError,//参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的
};

/* 网络提示 */
typedef NS_ENUM(NSInteger, JYRequestShowType) {
    JYRequestShowType_RequestViewShow = 1,              // 请求时提示 for View
    JYRequestShowType_ResponseViewShow,                 // 请求完毕后提示 for View
    JYRequestShowType_RequestAndResponseViewShow,       // 请求时请求完毕时都提示 for View
    JYRequestShowType_RequestWindowShow,                // 请求时提示 for Window
    JYRequestShowType_ResponseWindowShow,               // 请求完毕后提示 for Window
    JYRequestShowType_RequestAndResponseWindowShow,     // 请求时请求完毕时都提示 for Window
};

/* 网络状态 */
typedef NS_ENUM(NSInteger, DetectionNetworkType) {
    DetectionNetworkTypeNoNetwork,          //无网络
    DetectionNetworkTypeOneselfGNetwork,    //数据流量
    DetectionNetworkTypeWIFINetwork,        //局域网络
};

/* 移动数据网络状态 */
typedef NS_ENUM(NSInteger, DetectionNetworkReachableViaWWANType) {
    DetectionNetworkReachableViaWWANType2G,  //数据流量2G
    DetectionNetworkReachableViaWWANType3G,  //数据流量3G
    DetectionNetworkReachableViaWWANType4G,  //数据流量4G
};
