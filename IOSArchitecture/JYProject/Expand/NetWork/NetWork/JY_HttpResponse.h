//
//  JY_HttpResponse.h
//  JYProject
//
//  Created by dayou on 2017/7/30.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 响应状态状态 */
typedef NS_ENUM (NSUInteger, JYResponseErrorType){
    JYResponseErrorTypeDefault,  //没有产生过API请求，这个是manager的默认状态。
    JYResponseErrorTypeSuccess,  //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    JYResponseErrorTypeNoContent, //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    JYResponseErrorTypeTimeout,  //请求超时。JY_HttpProxy设置的是20秒超时，具体超时时间的设置请自己去看JY_HttpProxy的相关代码。
    JYResponseErrorTypeNoNetWork,//网络不通。在调用API之前会判断一下当前网络是否通畅，没有产生过API请求
};

@interface JY_HttpResponse : NSObject

/* 提示文字 */
@property (nonatomic ,copy)NSString * message;

/* 返回结果类型 */
@property (nonatomic ,assign ,readonly)JYResponseErrorType responseErrorType;

/* 返回数据 */
@property (nonatomic ,strong ,readonly)id responseData;

/* 网络请求返回过来的状态 一般用来判断是否请求超时 */
@property (nonatomic, assign, readonly)NSInteger httpStatusCode;

/* 请求成功响应 */
- (instancetype)initWithResponseObject:(id)responseObject urlResponse:(NSHTTPURLResponse *)urlResponse;

/* 请求失败响应 */
- (instancetype)initWithUrlResponse:(NSHTTPURLResponse *)urlResponse error:(NSError *)error;

@end
