//
//  JY_HttpRequestResend.h
//  JYProject
//
//  Created by dayou on 2017/8/24.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JY_NetWork.h"
#import "JY_HttpProxy.h"

/*********************** JY_HttpAPIDetails ***********************/

@interface JY_HttpAPIDetails : NSObject
/* 请求接口 */
@property (nonatomic ,strong)NSString* api;

/* 请求参数 */
@property (nonatomic ,strong)NSDictionary *parameters;

/* 请求方式 */
@property (nonatomic ,assign)JYRequestMethodType method;

/* 上传文件Black */
@property (nonatomic ,copy)NetWorkUpload imageListBlack;

/**
 * 创建 APIDetails
 *
 * @param api            数据接口
 * @param method         请求方式 (通过JYRequestMethodType枚举判断请求类型)
 * @param parameters     请求参数集合
 * @param imageListBlack 要上传的文件 如果不是上传JYRequestMethodType请求 可以不传
 */
+(JY_HttpAPIDetails*)createAPIDetailsWithAPI:(NSString*)api method: (JYRequestMethodType)method parameters:(NSDictionary*)parameters imageListBlack:(NetWorkUpload)imageListBlack;

@end

/*********************** JY_HttpRequestResend ***********************/

@interface JY_HttpRequestResend : NSObject

/* 重发次数 */
@property (nonatomic ,assign)NSUInteger resendResquestCount;

/* 重发分配Id */
@property (nonatomic ,strong)NSNumber *resendId;

/* 任务id */
@property (nonatomic ,strong)NSNumber *requestId;

/* 接口详情 */
@property (nonatomic ,strong)JY_HttpAPIDetails *apiDetails;

/* 请求失败 重新请求 */
@property (nonatomic ,assign)BOOL resendRequest;

/**
 * 创建 RequestResend
 *
 * @param api            数据接口
 * @param method         请求方式 (通过JYRequestMethodType枚举判断请求类型)
 * @param parameters     请求参数集合
 * @param imageListBlack 要上传的文件 如果不是上传JYRequestMethodType请求 可以不传
 */
+(JY_HttpRequestResend*)createRequestResendWithAPI:(NSString*)api method: (JYRequestMethodType)method parameters:(NSDictionary*)parameters imageListBlack:(NetWorkUpload)imageListBlack;

@end
