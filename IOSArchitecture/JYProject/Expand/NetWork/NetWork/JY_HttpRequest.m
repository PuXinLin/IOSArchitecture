//
//  JY_HttpRequest.m
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpRequest.h"

@interface JY_HttpRequest()
/* 分派的请求id */
@property (nonatomic ,strong, readwrite)NSMutableArray *requestIdList;
@end

@implementation JY_HttpRequest
#pragma mark ---------- Life Cycle ----------
#pragma mark 取消所有请求 避免不必要的消耗
-(void)dealloc{
    [self cancleAllRequest];
    self.requestIdList = nil;
}

#pragma mark ---------- Public Methods ----------
#pragma mark 数据请求
- (void)requestWithURLString: (NSString *)URLString
                      method: (JYRequestMethodType)method
                  parameters: (NSDictionary *)parameters
              imageListBlack:(NetWorkUpload)imageListBlack
{
    /* 这里可以检验是否发起请求 */
    JY_HttpResponse *errorResponse = [self checkRequestInfoWithURLString:URLString method:method parameters:parameters imageListBlack:imageListBlack];
    if (errorResponse) {
        [self failedOnCallingAPI:errorResponse];
        return;
    }
    JY_HttpProxy *proxy = [JY_HttpProxy sharedRequestInstance];
    JY_HttpRequest __weak *__self = self;
    NSNumber *requestId = [proxy requestWithURLString:URLString method:method parameters:parameters imageListBlack:imageListBlack progressBlock:^(CGFloat currentProgress){
        [__self.delegate managerCallAPIUploadProgressWithCurrentProgress:currentProgress];
    }finishedBlock:^(JY_HttpResponse *response)
    {
        [__self successedOnCallingAPI:response];
    } failureBlock:^(JY_HttpResponse *response) {
        [__self failedOnCallingAPI:response];
    }];
    [self.requestIdList addObject:requestId];
}

#pragma mark 取消所有数据请求
- (void)cancleAllRequest{
    [[JY_HttpProxy sharedRequestInstance] cancleAllRequestWithArrayList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

#pragma mark ---------- Private Methods ----------
#pragma mark 请求成功回调
-(void)successedOnCallingAPI:(JY_HttpResponse*)response{
    [self failedOnCallingAPI:response];
}

#pragma mark 请求失败回调
-(void)failedOnCallingAPI:(JY_HttpResponse*)response{
    switch (response.baseResponseModel.responseErrorType) {
        case JYResponseErrorTypeDefault:{
            response.baseResponseModel.message = JY_RequestError;
        }
            break;
        case JYResponseErrorTypeSuccess:{
            response.baseResponseModel.responseData = response.baseResponseModel.responseData;
            if ([response.baseResponseModel.responseData isKindOfClass:[NSDictionary class]]) {
                response.baseResponseModel.message = response.baseResponseModel.responseData[@"message"];
            }
            return [self.delegate managerCallAPIDidSuccess:response.baseResponseModel];
        }
            break;
        case JYResponseErrorTypeNoContent:{
            response.baseResponseModel.message = JY_RequestError;
        }
            break;
        case JYResponseErrorTypeTimeout:{
            response.baseResponseModel.message = JY_RequestOutTime;
        }
            break;
        case JYResponseErrorTypeNoNetWork:{
            response.baseResponseModel.message = JY_RequestNoNetwork;
        }
            break;
        case JYResponseErrorTypeParamsError:{
            response.baseResponseModel.message = JY_RequestError;
        }
            break;
        default:
            break;
    }
    [self.delegate managerCallAPIDidFailed:response.baseResponseModel];
}
#pragma mark 检验请求是否合格
-(JY_HttpResponse*)checkRequestInfoWithURLString:(NSString*)URLString method:(JYRequestMethodType)method parameters: (NSDictionary *)parameters imageListBlack:(NetWorkUpload)imageListBlack{
    JY_HttpResponse *errorResponse = nil;
    switch (method) {
        case JYRequestMethod_Upload:{
            if (imageListBlack==nil) {
                errorResponse = [[JY_HttpResponse alloc]initWithRequestId:nil api:URLString parameters:parameters];
                errorResponse.baseResponseModel.responseErrorType = JYResponseErrorTypeParamsError;
                return errorResponse;
            }
        }
            break;
            
        default:
            break;
    }
    if (!errorResponse) {
        errorResponse = [self checkNetWrok];
    }
    if (errorResponse) {
        errorResponse.baseResponseModel.url = [NSString stringWithFormat:@"%@%@",JY_APP_URL,URLString];
    }
    return errorResponse;
}

#pragma mark 检验网络是否合格
-(JY_HttpResponse*)checkNetWrok{
    JY_HttpResponse *errorResponse = nil;
    DetectionNetworkType networkState = [JY_MonitorNewWork sharedRequestInstance].currentNetworkType;
    if (networkState==knownNetwork || networkState ==NoNetwork) {
        errorResponse = [[JY_HttpResponse alloc]init];
        errorResponse.baseResponseModel.responseErrorType = JYResponseErrorTypeNoNetWork;
    }
    return errorResponse;
}


#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

-(NSMutableArray *)requestIdList{
    if (!_requestIdList) {
        _requestIdList  = [[NSMutableArray alloc]init];
    }
    return _requestIdList;
}

@end
