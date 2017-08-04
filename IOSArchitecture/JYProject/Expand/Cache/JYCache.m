//
//  JYCache.m
//  JYProject
//
//  Created by dayou on 2017/8/2.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JYCache.h"
#import <YYCache/YYCache.h>
//缓存用户
static NSString *const JYUsersCache = @"JYUsersCache";
//缓存用户数据
static NSString *const JYUsersResponseCache = @"JYUsersResponseCache";
//磁盘最大缓存开销 10M
static NSInteger const JYNetworkResponseCacheCostLimit = 10*1024;
//内存最大缓存数据个数 50条数据
static NSInteger const JYNetworkResponseCacheCountLimit = 50;
//磁盘缓存时间 2天
static int const JYNetworkResponseCacheOverdueTime = 2;

@interface JYCache()
/* 缓存名 */
@property (nonatomic ,copy)NSString *cacheUserInfoName;
@property (nonatomic ,strong) YYCache *cache;

@end

@implementation JYCache

#pragma mark ---------- Life Cycle ----------
+(JYCache*)sharedInstance{
    static JYCache *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[JYCache alloc]init];
    });
    return __sharedInstance;
}

#pragma mark ---------- Private Methods ----------
#pragma mark 缓存数据
+(void)cacheResponseData:(id)responseData Url:(NSString*)url parameters:(NSDictionary*)parameters
{
    NSString * keyName = [self getCacheKeyWith:url parameters:parameters];
    [[self sharedInstance].cache setObject:responseData forKey:keyName];
}

#pragma mark 获取缓存数据
+(id)getCacheResponseDataForUrl:(NSString*)url parameters:(NSDictionary*)parameters
{
    NSString * keyName = [self getCacheKeyWith:url parameters:parameters];
    return [[self sharedInstance].cache objectForKey:keyName];
}

#pragma mark 删除所有缓存数据
+(void)removeAllCacheResponse
{
    [[self sharedInstance].cache.diskCache removeAllObjects];
}

#pragma mark 用户登录检测数据是否过期
+(void)userLoginCheckResponseOverdue
{
    NSString * userKey = nil;
    NSDate * currentDate = [NSDate date];
    NSMutableDictionary * usersDic = [[NSMutableDictionary alloc]init];
    /* 获取所有用户信息 */
    YYCache * userCache = [YYCache cacheWithName:JYUsersCache];
    id users = [userCache objectForKey:JYUsersCache];
    /* 过期用户移除所有数据 */
    if ([users isKindOfClass:[NSDictionary class]]) {
        [usersDic setDictionary:users];
        for (userKey in usersDic) {
            id userLastTime = users[userKey];
            if ([userLastTime isKindOfClass:[NSDate class]]) {
                NSTimeInterval time = [userLastTime timeIntervalSinceDate:currentDate];
                int days = abs(((int)time)/24*3600);
                if (days>JYNetworkResponseCacheOverdueTime) {
                    YYCache *userInfoCache = [YYCache cacheWithName:userKey];
                    [userInfoCache removeAllObjects];
                };
            }
        }
    }
    /* 最新登录用户数据更新 这里可以存用户根据自己的需求来 */
    userKey = [[JYCache sharedInstance] getCacheUserCacheKey:JY_User.userCacheKey];
    usersDic[userKey] = currentDate;
    [userCache setObject:usersDic forKey:JYUsersCache];
}

#pragma mark 获取所有缓存数据大小
+(NSInteger)getAllCacheResponseSize
{
    return [[self sharedInstance].cache.diskCache totalCost];
}

#pragma mark 获取API接口缓存Key
+(NSString*)getCacheKeyWith:(NSString*)url parameters:(NSDictionary*)parameters{
    NSMutableDictionary*paramtersDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [paramtersDic setObject:url forKey:url];
    [paramtersDic setObject:JY_User.userCacheKey forKey:JY_User.userCacheKey];
    NSData * data = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
#pragma mark 获取用户的缓存地址
-(NSString*)getCacheUserCacheKey:(NSString*)userCacheKey{
    NSString * cacheName = [NSString stringWithFormat:@"%@%@",JYUsersResponseCache,userCacheKey];
    return cacheName;
}

#pragma mark 初始化YYCache
-(YYCache*)getCacheWithCacheName:(NSString*)cacheName
{
    YYCache *cache = [[YYCache alloc]initWithName:cacheName];
    [cache.diskCache setCostLimit:JYNetworkResponseCacheCostLimit];
    [cache.memoryCache setCountLimit:JYNetworkResponseCacheCountLimit];
    return cache;
}
#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------
-(YYCache *)cache
{
    NSString * cacheUserInfoName = [self getCacheUserCacheKey:JY_User.userCacheKey];
    if (!_cache) {
        _cache = [self getCacheWithCacheName:cacheUserInfoName];
    }
    else{
        /* 切换用户 */
        if (![self.cacheUserInfoName isEqualToString:cacheUserInfoName]) {
            _cache = [self getCacheWithCacheName:cacheUserInfoName];
        }
    }
    self.cacheUserInfoName = cacheUserInfoName;
    return _cache;
}

@end
