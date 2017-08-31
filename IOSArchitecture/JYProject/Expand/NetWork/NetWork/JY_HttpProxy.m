//
//  JY_HttpProxy.m
//  JYProject
//
//  Created by dayou on 2017/7/30.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpProxy.h"

static CGFloat const timeoutIntervalRequest2G = 10.f; // 请求超时时间2G

static CGFloat const timeoutIntervalRequest3G = 7.5f; // 请求超时时间3G

static CGFloat const timeoutIntervalRequest4GOrWIFI = 5.0f; // 请求超时时间4G或者WIFI

static CGFloat const timeoutIntervalRequestUpload = 20.f; // 上传超时时间

static NSInteger const tcpConnectionMaxCount2G = 1; // 最多连接通道2G

static NSInteger const tcpConnectionMaxCount3G = 2; // 最多连接通道3G

static NSInteger const tcpConnectionMaxCount4GOrWIFI = 3; // 最多连接通道4G或者WIFI

@interface JY_HttpProxy()
/* 分配管理id */
@property (nonatomic ,strong)NSNumber *dispatchId;
/* 负责记录所有派的请求id */
@property (nonatomic ,strong)NSMutableDictionary *dispatchTable;
/* AFHTTPSessionManager 数组 */
@property (nonatomic ,strong)NSMutableArray *sessionManagerList;
/* 负责监控网络变化 */
@property (nonatomic ,strong)JY_MonitorNewWork *monitorNewWork;
@end

@implementation JY_HttpProxy

#pragma mark ---------- Public Methods ----------
+ (instancetype)sharedRequestInstance {
    static JY_HttpProxy *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[JY_HttpProxy alloc]init];
    });
    return __sharedInstance;
}

#pragma mark 拼接接口
- (NSNumber*)requestWithURLString: (NSString *)URLString method: (JYRequestMethodType)method parameters: (NSDictionary *)parameters imageListBlack:(NetWorkUpload)imageListBlack progressBlock:(JYCallbackAPIProgressCallback)progressBlock finishedBlock: (JYCallbackAPICallback)finishedBlock failureBlock: (JYCallbackAPICallback)failureBlock
{
    NSNumber *requestId = [self request:URLString method:method parameters:parameters imageListBlack:imageListBlack progressBlock:progressBlock finishedBlock:finishedBlock failureBlock:failureBlock];
    return requestId;
}

#pragma mark 取消所有数据请求
- (void)cancleAllRequestWithArrayList:(NSArray*)arrayList{
    for (NSNumber* requestId in arrayList) {
        [self cancleRequestWithRequestId:requestId];
    }
}
#pragma mark 取消单个数据请求
- (void)cancleRequestWithRequestId:(NSNumber*)requestId{
    NSURLSessionDataTask * task = self.dispatchTable[requestId][@"Task"];
    [task cancel];
}

#pragma mark ---------- Private Methods ----------
#pragma mark 发起请求
- (NSNumber*)request:(NSString *)URLString method: (JYRequestMethodType)method parameters: (NSDictionary *)parameters imageListBlack:(NetWorkUpload)imageListBlack progressBlock:(JYCallbackAPIProgressCallback)progressBlock finishedBlock: (JYCallbackAPICallback)finishedBlock failureBlock: (JYCallbackAPICallback)failureBlock
{
    NSString * stringUrl = [NSString stringWithFormat:@"%@%@",JY_APP_URL,URLString];
    NSURLSessionDataTask * task = nil;
    /* 分配管理id */
    _dispatchId = [self getdispatchId];
    NSNumber *dispatchId = [_dispatchId copy];
    /* 配置请求 */
    AFHTTPSessionManager *sessionManager = [self getBestSessionManager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.requestSerializer.timeoutInterval = [self getBestTimeOutTime];
    /* 发起请求 */
    switch (method) {
        case JYRequestMethod_GET:{
            task = [sessionManager GET:stringUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequstWithTask:task responseObject:responseObject finishedBlock:finishedBlock dispatchId:dispatchId];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handelFailureRequstWithTask:task error:error failureBlock:failureBlock dispatchId:dispatchId];
            }];
        }
            break;
        case JYRequestMethod_POST:{
            task = [sessionManager POST:stringUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequstWithTask:task responseObject:responseObject finishedBlock:finishedBlock dispatchId:dispatchId];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [self handelFailureRequstWithTask:task error:error failureBlock:failureBlock dispatchId:dispatchId];
            }];
        }
            break;
        case JYRequestMethod_Upload:{
            sessionManager.requestSerializer.timeoutInterval = timeoutIntervalRequestUpload; //上传文件时间
            task = [sessionManager POST:stringUrl parameters:parameters constructingBodyWithBlock:imageListBlack progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progressBlock) {
                    CGFloat progress = uploadProgress.completedUnitCount/(uploadProgress.totalUnitCount+0.0);
                    progressBlock(progress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequstWithTask:task responseObject:responseObject finishedBlock:finishedBlock dispatchId:dispatchId];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handelFailureRequstWithTask:task error:error failureBlock:failureBlock dispatchId:dispatchId];
            }];
        }
            break;
        default:
            break;
    }
    /* 保存请求信息 */
    JY_HttpResponse * response = [[JY_HttpResponse alloc]initWithRequestId:_dispatchId api:URLString parameters:parameters];
    self.dispatchTable[_dispatchId] = @{@"JY_HttpResponse":response,@"Task":task};
    return _dispatchId;
}
#pragma mark 请求成功处理
-(void)handelSuccessRequstWithTask:(NSURLSessionDataTask * )task
                    responseObject:(id)responseObject
                     finishedBlock: (JYCallbackAPICallback)finishedBlock
                        dispatchId:(NSNumber*)dispatchId
{
    JY_HttpResponse * response = self.dispatchTable[dispatchId][@"JY_HttpResponse"];
    [self.dispatchTable removeObjectForKey:dispatchId];
    [response requestWithResponseObject:responseObject urlResponse:(NSHTTPURLResponse *)task.response];
    finishedBlock(response);
}

#pragma mark 请求失败处理
-(void)handelFailureRequstWithTask:(NSURLSessionDataTask * )task
                             error:(NSError *)error
                       failureBlock: (JYCallbackAPICallback)failureBlock
                        dispatchId:(NSNumber*)dispatchId
{
    JY_HttpResponse * response = self.dispatchTable[dispatchId][@"JY_HttpResponse"];
    [self.dispatchTable removeObjectForKey:dispatchId];
    [response requestWithUrlResponse:(NSHTTPURLResponse *)task.response error:error];
    failureBlock?failureBlock(response):nil;
}

#pragma mark 获取最佳请求时间
-(CGFloat)getBestTimeOutTime
{
    switch ([self.monitorNewWork getNetworkType]) {
        case DetectionNetworkTypeNoNetwork:
            return 0.f;
            break;
        case DetectionNetworkTypeOneselfGNetwork:
        {
            switch ([self.monitorNewWork getNetworkReachableViaWWANType]) {
                case DetectionNetworkReachableViaWWANType2G:
                    return timeoutIntervalRequest2G;
                    break;
                case DetectionNetworkReachableViaWWANType3G:
                    return timeoutIntervalRequest3G;
                    break;
                case DetectionNetworkReachableViaWWANType4G:
                    return timeoutIntervalRequest4GOrWIFI;
                    break;
                default:
                    break;
            }
        }
            break;
        case DetectionNetworkTypeWIFINetwork:
            return timeoutIntervalRequest4GOrWIFI;
            break;
        default:
            break;
    }
    return 0.f;
}

#pragma mark 获取最佳SessionManager
-(AFHTTPSessionManager*)getBestSessionManager
{
    AFHTTPSessionManager *sessionManager  = self.sessionManagerList[0];
    switch ([self.monitorNewWork getNetworkType]) {
        case DetectionNetworkTypeOneselfGNetwork:
        {
            switch ([self.monitorNewWork getNetworkReachableViaWWANType]) {
                case DetectionNetworkReachableViaWWANType2G:
                    sessionManager = [self getSessionManagerWithMaxConnection:tcpConnectionMaxCount2G];
                    break;
                case DetectionNetworkReachableViaWWANType3G:
                     sessionManager = [self getSessionManagerWithMaxConnection:tcpConnectionMaxCount3G];
                    break;
                case DetectionNetworkReachableViaWWANType4G:
                     sessionManager = [self getSessionManagerWithMaxConnection:tcpConnectionMaxCount4GOrWIFI];
                    break;
                default:
                    break;
            }
        }
            break;
        case DetectionNetworkTypeWIFINetwork:
             sessionManager = [self getSessionManagerWithMaxConnection:tcpConnectionMaxCount4GOrWIFI];
            break;
        default:
            break;
    }
    return sessionManager;
}
#pragma mark 获取SessionManager
-(AFHTTPSessionManager*)getSessionManagerWithMaxConnection:(NSInteger)maxConnection
{
    AFHTTPSessionManager *sessionManager = self.sessionManagerList[0];
    for (NSInteger i = 1; i<maxConnection; i++) {
        if (i>=self.sessionManagerList.count) break;
        AFHTTPSessionManager *sessionManagerItem = self.sessionManagerList[i];
        if (sessionManager.tasks.count>sessionManagerItem.tasks.count) {
            sessionManager = sessionManagerItem;
        }
    }
    return sessionManager;
}
#pragma mark 初始化SessionManager
-(AFHTTPSessionManager*)createSessionManager
{
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:nil];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil]; // 默认支持类型
    return sessionManager;
}
#pragma mark 获取分配ID
-(NSNumber*)getdispatchId
{
    if (_dispatchId == nil) {
        _dispatchId = @(1);
    } else {
        if ([_dispatchId integerValue] == NSIntegerMax) {
            _dispatchId = @(1);
        } else {
            _dispatchId = @([_dispatchId integerValue] + 1);
        }
    }
    return _dispatchId;
}
#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

-(NSMutableDictionary *)dispatchTable{
    if (!_dispatchTable) {
        _dispatchTable = [[NSMutableDictionary alloc]init];
    }
    return _dispatchTable;
}
-(JY_MonitorNewWork *)monitorNewWork{
    if (!_monitorNewWork) {
        _monitorNewWork = [JY_MonitorNewWork sharedRequestInstance];
    }
    return _monitorNewWork;
}
-(NSMutableArray *)sessionManagerList{
    if (!_sessionManagerList) {
        _sessionManagerList = [[NSMutableArray alloc]init];
        for (int i=0; i<tcpConnectionMaxCount4GOrWIFI; i++) {
            [_sessionManagerList addObject:[self createSessionManager]];
        }
    }
    return _sessionManagerList;
}
@end

