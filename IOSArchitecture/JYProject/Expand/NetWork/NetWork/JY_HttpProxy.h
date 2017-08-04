//
//  JY_HttpProxy.h
//  JYProject
//
//  Created by dayou on 2017/7/30.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JY_HttpResponse.h"

@interface JY_HttpProxy : NSObject

/**
 * 上传图片的块
 *
 * @param formData AFNetWorking上传文件的代码块
 */
typedef void (^NetWorkUpload)(id<AFMultipartFormData> formData);

/* 请求回调 */
typedef void(^JYCallbackAPICallback)(JY_HttpResponse *response);

+ (instancetype)sharedRequestInstance;

/**
 * 数据请求
 *
 * @param URLString      数据接口
 * @param method         请求方式 (get or post)
 * @param parameters     请求参数集合
 * @param imageListBlack 要上传的图片
 * @param finishedBlock  请求完成回调
 * @param failureBlock   请求失败回调
 */
- (void)requestWithURLString: (NSString *)URLString
                      method: (JYRequestMethodType)method
                  parameters: (NSDictionary *)parameters
              imageListBlack:(NetWorkUpload)imageListBlack
                    finishedBlock: (JYCallbackAPICallback)finishedBlock
                    failureBlock: (JYCallbackAPICallback)failureBlock;
/**
 * 取消所有数据请求
 */
- (void)cancleAllRequest;

@end
