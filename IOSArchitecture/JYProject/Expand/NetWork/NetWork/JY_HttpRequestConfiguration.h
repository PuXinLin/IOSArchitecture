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


/* 请求状态 */
typedef NS_ENUM(NSInteger, JYRequestMethodType) {
    JYRequestMethod_GET = 0,
    JYRequestMethod_POST,
    JYRequestMethod_Upload,
};

/********************** 公共块 **********************/
/* 请求完成回调函数 */
typedef void(^ITFinishedBlock)(id _Nullable responseObject);

/* 请求失败回调函数 */
typedef void(^ITFailureBlock)(id _Nullable responseObject);

/**
 * 上传图片的块
 *
 * @param formData AFNetWorking上传文件的代码块 
 *
 */
typedef void (^NetWorkUpload)(id<AFMultipartFormData>  _Nonnull formData);
