//
//  JY_HttpProxy.m
//  JYProject
//
//  Created by dayou on 2017/7/30.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpProxy.h"

static CGFloat const timeoutIntervalRequest = 10.f; // 请求超时时间

static CGFloat const timeoutIntervalRequestUpload = 20.f; // 上传超时时间

@interface JY_HttpProxy()
/* 负责管理所有的网络请求 */
@property (nonatomic ,strong)AFHTTPSessionManager *sessionManager;
/* 负责记录所有派的请求id */
@property (nonatomic ,strong)NSMutableDictionary *dispatchTable;
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
- (NSNumber*)requestWithURLString: (NSString *)URLString method: (JYRequestMethodType)method parameters: (NSDictionary *)parameters imageListBlack:(NetWorkUpload)imageListBlack progressBlock:(JYCallbackAPIProgressCallback)progressBlock finishedBlock: (JYCallbackAPICallback)finishedBlock failureBlock: (JYCallbackAPICallback)failureBlock{
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
    [self.dispatchTable removeObjectForKey:requestId];
}

#pragma mark ---------- Private Methods ----------
#pragma mark 发起请求
- (NSNumber*)request:(NSString *)URLString method: (JYRequestMethodType)method parameters: (NSDictionary *)parameters imageListBlack:(NetWorkUpload)imageListBlack progressBlock:(JYCallbackAPIProgressCallback)progressBlock finishedBlock: (JYCallbackAPICallback)finishedBlock failureBlock: (JYCallbackAPICallback)failureBlock
{
    NSString * stringUrl = [NSString stringWithFormat:@"%@%@",JY_APP_URL,URLString];
    NSURLSessionDataTask * task = nil;
    /* 配置请求 */
    self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.sessionManager.requestSerializer.timeoutInterval = timeoutIntervalRequest;
    switch (method) {
        case JYRequestMethod_GET:{
            task = [self.sessionManager GET:stringUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequstWithTask:task responseObject:responseObject finishedBlock:finishedBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handelFailureRequstWithTask:task error:error failureBlock:failureBlock];
            }];
        }
            break;
        case JYRequestMethod_POST:{
            task = [self.sessionManager POST:stringUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequstWithTask:task responseObject:responseObject finishedBlock:finishedBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [self handelFailureRequstWithTask:task error:error failureBlock:failureBlock];
            }];
        }
            break;
        case JYRequestMethod_Upload:{
            self.sessionManager.requestSerializer.timeoutInterval = timeoutIntervalRequestUpload; //上传文件时间
            task = [self.sessionManager POST:stringUrl parameters:parameters constructingBodyWithBlock:imageListBlack progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progressBlock) {
                    CGFloat progress = uploadProgress.completedUnitCount/(uploadProgress.totalUnitCount+0.0);
                    progressBlock(progress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequstWithTask:task responseObject:responseObject finishedBlock:finishedBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handelFailureRequstWithTask:task error:error failureBlock:failureBlock];
            }];
        }
            break;
            
        default:
            break;
    }
    NSNumber * requestId = @(task.taskIdentifier);
    JY_HttpResponse * response = [[JY_HttpResponse alloc]initWithRequestId:requestId api:URLString parameters:parameters];
    self.dispatchTable[requestId] = @{@"JY_HttpResponse":response,@"Task":task};
    return requestId;
}
#pragma mark 请求成功处理
-(void)handelSuccessRequstWithTask:(NSURLSessionDataTask * )task
                    responseObject:(id)responseObject
                     finishedBlock: (JYCallbackAPICallback)finishedBlock
{
    if (!task) { //手动取消的task不需要回调
        return;
    }
    NSNumber *requestId = @(task.taskIdentifier);
    JY_HttpResponse * response = self.dispatchTable[requestId][@"JY_HttpResponse"];
    [self.dispatchTable removeObjectForKey:requestId];
    [response requestWithResponseObject:responseObject urlResponse:(NSHTTPURLResponse *)task.response];
    finishedBlock(response);
}

#pragma mark 请求失败处理
-(void)handelFailureRequstWithTask:(NSURLSessionDataTask * )task
                             error:(NSError *)error
                       failureBlock: (JYCallbackAPICallback)failureBlock
{
    if (!task) { //手动取消的task不需要回调
        return;
    }
    NSNumber *requestId = @(task.taskIdentifier);
    JY_HttpResponse * response = self.dispatchTable[requestId][@"JY_HttpResponse"];
    [self.dispatchTable removeObjectForKey:requestId];
    [response requestWithUrlResponse:(NSHTTPURLResponse *)task.response error:error];
    failureBlock?failureBlock(response):nil;
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

-(AFHTTPSessionManager *)sessionManager{
    if (!_sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:nil];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil]; // 默认支持类型
    }
    return _sessionManager;
}
-(NSMutableDictionary *)dispatchTable{
    if (!_dispatchTable) {
        _dispatchTable = [[NSMutableDictionary alloc]init];
    }
    return _dispatchTable;
}

@end
