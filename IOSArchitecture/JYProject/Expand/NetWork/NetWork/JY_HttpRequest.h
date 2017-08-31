//
//  JY_HttpRequest.h
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JY_HttpProxy.h"
#import "JY_BaseResponseModel.h"
#import "JY_HttpRequestResend.h"

@class JY_HttpRequest;

/*********************** JY_HttpRequest ***********************/

/*---------------------API回调-----------------------*/
@protocol JY_HttpRequestCallBackDelegate <NSObject>
@required
/* 请求成功回调 */
- (void)managerCallAPIDidSuccess:(JY_BaseResponseModel *)response;
/* 请求失败回调 */
- (void)managerCallAPIDidFailed:(JY_BaseResponseModel *)response;
@optional
/* 上传文件进度 */
- (void)managerCallAPIUploadProgressWithCurrentProgress:(CGFloat)currentProgress;
@end

@interface JY_HttpRequest : NSObject

/* 针对特殊业务不允许重发 */
@property (nonatomic ,assign)BOOL notResendResquest;

/* 回调代理 */
@property (nonatomic ,weak)id<JY_HttpRequestCallBackDelegate> delegate;

/**
 * 数据请求
 *
 * @param URLString      数据接口
 * @param method         请求方式 (通过JYRequestMethodType枚举判断请求类型)
 * @param parameters     请求参数集合
 * @param imageListBlack 要上传的文件 如果不是上传JYRequestMethodType请求 可以不传
 */
- (void)requestWithURLString: (NSString *)URLString
                      method: (JYRequestMethodType)method
                  parameters: (NSDictionary *)parameters
              imageListBlack:(NetWorkUpload)imageListBlack;

/**
 * 取消所有数据请求
 */
- (void)cancleAllRequest;

@end

