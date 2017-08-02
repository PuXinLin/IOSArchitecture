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

@class JY_HttpRequest;

/*---------------------API回调-----------------------*/
@protocol JY_HttpRequestCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(JY_HttpRequest *)request;
- (void)managerCallAPIDidFailed:(JY_HttpRequest *)request;
@end

@interface JY_HttpRequest : NSObject

/* 回调代理 */
@property (nonatomic ,weak)id<JY_HttpRequestCallBackDelegate> delegate;

/* 响应类型 */
@property (nonatomic, assign, readonly)JYResponseErrorType errorType;

/* 返回数据 */
@property (nonatomic, assign, readonly)id responseData;

/* 错误提示 */
@property (nonatomic, copy, readonly) NSString *message;

/* 服务器返回的信息 */
@property (nonatomic ,strong)JY_BaseResponseModel *baseResponseModel;

/* 请求提示 (看枚举) */
@property (nonatomic ,assign)JYRequestShowType requestShowType;

/**
 * 初始化方法
 *
 * @param view 加载HUDView提示框的父View
 */
+(instancetype)loadDataHUDwithView:(UIView*)view;

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
