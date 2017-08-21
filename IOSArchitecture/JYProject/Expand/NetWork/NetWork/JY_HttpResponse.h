//
//  JY_HttpResponse.h
//  JYProject
//
//  Created by dayou on 2017/7/30.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JY_BaseResponseModel.h"

@interface JY_HttpResponse : NSObject

/* 网络请求返回过来的状态 */
@property (nonatomic, strong, readonly)JY_BaseResponseModel *baseResponseModel;

/* 开始请求 */
- (instancetype)initWithRequestId:(NSNumber*)requestId api:(NSString*)api parameters:(NSDictionary*)parameters;

/* 请求成功响应 */
- (void)requestWithResponseObject:(id)responseObject urlResponse:(NSHTTPURLResponse *)urlResponse;

/* 请求失败响应 */
- (void)requestWithUrlResponse:(NSHTTPURLResponse *)urlResponse error:(NSError *)error;

@end
