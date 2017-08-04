//
//  JY_HttpProxy.m
//  JYProject
//
//  Created by dayou on 2017/7/30.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpProxy.h"

static CGFloat const timeoutIntervalRequest = 5.f; // 请求超时时间

static CGFloat const timeoutIntervalRequestUpload = 20.f; // 上传超时时间

@interface JY_HttpProxy()

@property (nonatomic ,strong)AFHTTPSessionManager *sessionManager;

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
- (void)requestWithURLString: (NSString *)URLString method: (JYRequestMethodType)method parameters: (NSDictionary *)parameters imageListBlack:(NetWorkUpload)imageListBlack finishedBlock: (JYCallbackAPICallback)finishedBlock failureBlock: (JYCallbackAPICallback)failureBlock{
    NSString * stringUrl = [NSString stringWithFormat:@"%@%@",JY_APP_URL,URLString];
    [self request:stringUrl method:method parameters:parameters imageListBlack:imageListBlack finishedBlock:finishedBlock failureBlock:failureBlock];
}

#pragma mark 取消所有数据请求
- (void)cancleAllRequest{
    [self.sessionManager.operationQueue cancelAllOperations];
}

#pragma mark ---------- Private Methods ----------
#pragma mark 发起请求
- (void)request:(NSString *)URLString method: (JYRequestMethodType)method parameters: (NSDictionary *)parameters imageListBlack:(NetWorkUpload)imageListBlack finishedBlock: (JYCallbackAPICallback)finishedBlock failureBlock: (JYCallbackAPICallback)failureBlock{
    /* 配置请求 */
    self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.sessionManager.requestSerializer.timeoutInterval = timeoutIntervalRequest;
    
    switch (method) {
        case JYRequestMethod_GET:{
            [self.sessionManager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequst:task responseObject:responseObject finishedBlock:finishedBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handelFailureRequst:task error:error failureBlock:failureBlock];
            }];
        }
            break;
        case JYRequestMethod_POST:{
            [self.sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequst:task responseObject:responseObject finishedBlock:finishedBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [self handelFailureRequst:task error:error failureBlock:failureBlock];
            }];

        }
            break;
        case JYRequestMethod_Upload:{
            self.sessionManager.requestSerializer.timeoutInterval = timeoutIntervalRequestUpload; //上传文件时间
            [self.sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:imageListBlack progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handelSuccessRequst:task responseObject:responseObject finishedBlock:finishedBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handelFailureRequst:task error:error failureBlock:failureBlock];
            }];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark 请求成功处理
-(void)handelSuccessRequst:(NSURLSessionDataTask * )task responseObject:(id)responseObject finishedBlock: (JYCallbackAPICallback)finishedBlock{
    JY_HttpResponse * responseModel = [[JY_HttpResponse alloc]initWithResponseObject:responseObject urlResponse:(NSHTTPURLResponse *)task.response];
    finishedBlock(responseModel);
}

#pragma mark 请求失败处理
-(void)handelFailureRequst:(NSURLSessionDataTask * )task error:(NSError *)error failureBlock: (JYCallbackAPICallback)failureBlock{
    if (task==nil) { // 手动取消的task不需要回调
        return;
    }
    JY_HttpResponse * responseModel = [[JY_HttpResponse alloc]initWithUrlResponse:(NSHTTPURLResponse *)task.response error:error];
    
    failureBlock?failureBlock(responseModel):nil;
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

@end
