//
//  JYCache.h
//  JYProject
//
//  Created by dayou on 2017/8/2.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYCache : NSObject
/**
 * 缓存数据
 *
 * @param responseData 需要缓存的数据 (根据请求 连接 和 参数 拼接出缓存的key)
 * @param url          请求连接
 * @param parameters   请求参数
 */
+(void)cacheResponseData:(id)responseData Url:(NSString*)url parameters:(NSDictionary*)parameters;

/**
 * 获取缓存数据
 *
 * @param url          请求连接 (根据请求 连接 和 参数 拼接出缓存的key)
 * @param parameters   请求参数
 */
+(id)getCacheResponseDataForUrl:(NSString*)url parameters:(NSDictionary*)parameters;

/* 删除当前用户所有缓存数据 */
+(void)removeAllCacheResponse;

/**
 * 用户登录检测数据是否过期 过期删除 (根据 UserModel 属性 userCacheKey 来查)
 */
+(void)userLoginCheckResponseOverdue;

/* 获取所有缓存数据大小 */
+(NSInteger)getAllCacheResponseSize;

@end
