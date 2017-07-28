//
//  JY_HttpRequest.m
//  JYProject
//
//  Created by dayou on 2017/7/27.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpRequest.h"

#import <AFNetworking/AFNetworking.h>

@interface JY_HttpRequest()

/* AFHTTPSessionManager */
@property (nonatomic ,strong)AFHTTPSessionManager *manager;

/* 网络状态 */
@property (nonatomic ,assign)DetectionNetworkState networkState;

@end

@implementation JY_HttpRequest

#pragma mark 单例模式
+ (instancetype)sharedRequestInstance {
    static JY_HttpRequest *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[JY_HttpRequest alloc]init];
        __sharedInstance.manager = [[AFHTTPSessionManager alloc]init];
    });
    return __sharedInstance;
}

#pragma mark ----------Private Methods ----------

#pragma mark GET请求
+ (void) netRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ITFinishedBlock) finishedBlock {
    NSString * stringUrl = [NSString stringWithFormat:@"%@%@",JY_APP_URL,requestURLString]; // 拼接请求url
    
    [[JY_HttpRequest sharedRequestInstance].manager GET:stringUrl parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        finishedBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning 弹框提示请检查网络
        JY_Log(@"弹框提示请检查网络");
    }];
}

#pragma mark POST请求
+ (void) netRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ITFinishedBlock) block {
    
    AFHTTPSessionManager *manager = [JY_HttpRequest sharedRequestInstance].manager;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    /* 请求时间设置 */
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager.operationQueue cancelAllOperations];
    
    NSString * stringUrl = [NSString stringWithFormat:@"%@%@",JY_APP_URL,requestURLString]; // 拼接请求url
    
    [manager POST:stringUrl parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        block(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning 弹框提示请检查网络
        JY_Log(@"弹框提示请检查网络");
    }];
}

#pragma mark 是否发送请求
+(BOOL)checkRequestHttp{
    BOOL checkRequestHttp = YES;
    switch ([JY_HttpRequest sharedRequestInstance].networkState) {
        case knownNetwork:
            JY_Log(@"未知网络");
            checkRequestHttp = NO;
            break;
        case NoNetwork:
            JY_Log(@"无数据连接");
            checkRequestHttp = NO;
            break;
        case OneselfGNetwork:
            JY_Log(@"已切换至数据流量");
            checkRequestHttp = YES;
            break;
        case WIFINetwork:
            JY_Log(@"已切换至WIF环境");
            checkRequestHttp = YES;
            break;
        default:
            break;
    }
    return checkRequestHttp;
}

#pragma mark ----------Public Methods ----------
#pragma mark -- 数据请求
+ (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (MethodState)method
                    callBack: (ITFinishedBlock)finishedBlock{
    if ([JY_HttpRequest checkRequestHttp]) {
        JY_Log(@"当前网络不允许发送请求！");
        return;
    }
    if (method == Method_POST) {
        [JY_HttpRequest netRequestPOSTWithRequestURL:URLString WithParameter:parameters WithReturnValeuBlock:finishedBlock];
    }
    else if (method == Method_GET){
        [JY_HttpRequest netRequestGETWithRequestURL:URLString WithParameter:parameters WithReturnValeuBlock:finishedBlock];
    }
}

#pragma mark 关闭所有数据请求
+ (void)cancleAllRequest{
    [[JY_HttpRequest sharedRequestInstance].manager.operationQueue cancelAllOperations];
}

#pragma mark 监听网络状态
+ (void)netWorkStateDetection:(NetWorkStateBlock)state{
    __weak AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    [manger startMonitoring]; // 开始监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                state(knownNetwork);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                state(NoNetwork);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                state(OneselfGNetwork);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                state(WIFINetwork);
                break;
            default:
                break;
        }
        [JY_HttpRequest sharedRequestInstance].networkState = status+0; // 保存网络状态
    }];

}

#pragma mark 关闭监听网络状态
+(void)cancleNetWorkStateDetection{
    __weak AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    [manger stopMonitoring]; // 关闭监听改变
}
#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end