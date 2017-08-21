//
//  JY_BaseResponseModel.h
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 响应状态状态 */
typedef NS_ENUM (NSUInteger, JYResponseErrorType){
    JYResponseErrorTypeDefault,    //API请求失败的默认状态。
    
    JYResponseErrorTypeSuccess,    //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    JYResponseErrorTypeNoContent,  //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    JYResponseErrorTypeTimeout,    //请求超时。JY_HttpProxy设置的是10秒超时，具体超时时间的设置请自己去看JY_HttpProxy的相关代码。
    JYResponseErrorTypeNoNetWork,  //网络不通。在调用API之前会判断一下当前网络是否通畅，没有产生过API请求
    JYResponseErrorTypeParamsError,//参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的
};

@interface JY_BaseResponseModel : NSObject<NSCopying>
//任务id
@property (nonatomic ,strong)NSNumber *requestId;
//网络请求URL
@property (nonatomic, strong)NSString *url;
//返回数据
@property (nonatomic, strong)id responseData;
//提示用户
@property (nonatomic, copy, readwrite)NSString *message;
//网络请求返回过来的状态
@property (nonatomic, assign)NSInteger httpStatusCode;
//错误描述
@property (nonatomic, strong)NSString *descr;
//API
@property (nonatomic ,strong)NSString *api;
//参数
@property (nonatomic ,strong)NSDictionary *parameters;
//错误类型类型
@property (nonatomic ,assign ,readwrite)JYResponseErrorType responseErrorType;

@end
