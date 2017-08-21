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

/* 网络提示 */
typedef NS_ENUM(NSInteger, JYRequestShowType) {
    JYRequestShowType_RequestViewShow = 1,              // 请求时提示 for View
    JYRequestShowType_ResponseViewShow,                 // 请求完毕后提示 for View
    JYRequestShowType_RequestAndResponseViewShow,       // 请求时请求完毕都提示 for View
    JYRequestShowType_RequestWindowShow,                // 请求时提示 for Window
    JYRequestShowType_ResponseWindowShow,               // 请求完毕后提示 for Window
    JYRequestShowType_RequestAndResponseWindowShow,     // 请求时请求完毕都提示 for Window
};
