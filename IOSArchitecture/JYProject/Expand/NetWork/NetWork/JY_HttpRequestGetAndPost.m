//
//  JY_HttpRequestGetAndPost.m
//  JYProject
//
//  Created by dayou on 2017/7/28.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpRequestGetAndPost.h"

@implementation JY_HttpRequestGetAndPost

-(instancetype)init{
    self = [super init];
    if (self) {
        [self configurationModel];
    }
    return self;
}


#pragma mark ---------- Public Methods ----------
#pragma mark -- 数据请求
+ (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (MethodState)method
                    callBack: (ITFinishedBlock)finishedBlock{
    if (method==Method_GET) {
        [JY_HttpRequestGetAndPost netRequestGETWithRequestURL:URLString WithParameter:parameters WithReturnValeuBlock:finishedBlock];
    }
    else{
        [JY_HttpRequestGetAndPost netRequestPOSTWithRequestURL:URLString WithParameter:parameters WithReturnValeuBlock:finishedBlock];
    }
}
#pragma mark ---------- Private Methods ----------
#pragma mark GET请求
+ (void) netRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ITFinishedBlock) finishedBlock {
    NSString * stringUrl = [NSString stringWithFormat:@"%@%@",JY_APP_URL,requestURLString]; // 拼接请求url
    
    [[JY_HTTPSessionManager sharedRequestInstance] GET:stringUrl parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        finishedBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning 弹框提示请检查网络
        JY_Log(@"弹框提示请检查网络");
    }];
}

#pragma mark POST请求
+ (void) netRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ITFinishedBlock) finishedBlock {
    
    AFHTTPSessionManager *manager = [JY_HTTPSessionManager sharedRequestInstance];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    /* 请求时间设置 */
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager.operationQueue cancelAllOperations];
    
    NSString * stringUrl = [NSString stringWithFormat:@"%@%@",JY_APP_URL,requestURLString]; // 拼接请求url
    
    [manager POST:stringUrl parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finishedBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning 弹框提示请检查网络
        JY_Log(@"弹框提示请检查网络");
    }];
}


#pragma mark 配置Model
-(void)configurationModel{}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
