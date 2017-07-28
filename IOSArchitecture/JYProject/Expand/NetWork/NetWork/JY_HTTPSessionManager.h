//
//  JY_HTTPSessionManager.h
//  JYProject
//
//  Created by dayou on 2017/7/28.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JY_HTTPSessionManager : AFHTTPSessionManager

/* 超时时间最大值 */
@property (nonatomic ,assign)NSInteger jy_timeoutInterval;

+ (instancetype)sharedRequestInstance;

+ (void)cancleAllRequest;

@end
