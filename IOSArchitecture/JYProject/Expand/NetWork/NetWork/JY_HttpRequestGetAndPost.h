//
//  JY_HttpRequestGetAndPost.h
//  JYProject
//
//  Created by dayou on 2017/7/28.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JY_HttpRequestGetAndPost : NSObject

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
@end
