//
//  JY_BaseResponseModel.h
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@property (nonatomic ,assign)JYResponseErrorType responseErrorType;

@end
