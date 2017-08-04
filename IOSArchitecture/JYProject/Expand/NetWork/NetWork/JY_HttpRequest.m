//
//  JY_HttpRequest.m
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpRequest.h"

@interface JY_HttpRequest()
@property (nonatomic, assign, readwrite)JYResponseErrorType errorType;
@property (nonatomic, copy,   readwrite)NSString *message;
@property (nonatomic ,strong, readwrite)JY_BaseResponseModel *baseResponseModel;
@end

@implementation JY_HttpRequest

#pragma mark ---------- Public Methods ----------
#pragma mark 数据请求
- (void)requestWithURLString: (NSString *)URLString
                      method: (JYRequestMethodType)method
                  parameters: (NSDictionary *)parameters
              imageListBlack:(NetWorkUpload)imageListBlack
{
    JY_HttpProxy *proxy = [JY_HttpProxy sharedRequestInstance];
    /* 这里可以检验是否发起请求 */
    JY_HttpResponse *errorResponse = [self checkRequestInfo:method parameters:parameters imageListBlack:imageListBlack];
    if (errorResponse) {
        [self failedOnCallingAPI:errorResponse];
        return;
    }
    [proxy requestWithURLString:URLString method:method parameters:parameters imageListBlack:imageListBlack finishedBlock:^(JY_HttpResponse *response) {
        [self successedOnCallingAPI:response];
    } failureBlock:^(JY_HttpResponse *response) {
        [self failedOnCallingAPI:response];
    }];
}

#pragma mark 取消所有数据请求
- (void)cancleAllRequest{
    [[JY_HttpProxy sharedRequestInstance] cancleAllRequest];
}

#pragma mark ---------- Private Methods ----------
#pragma mark 请求成功回调
-(void)successedOnCallingAPI:(JY_HttpResponse*)response{
    [self failedOnCallingAPI:response];
}

#pragma mark 请求失败回调
-(void)failedOnCallingAPI:(JY_HttpResponse*)response{
    self.baseResponseModel = [JY_BaseResponseModel yy_modelWithJSON:response.responseData];
    self.errorType = response.responseErrorType;
    switch (response.responseErrorType) {
        case JYResponseErrorTypeDefault:{
            self.message = JY_RequestError;
            JY_Log(@"************************** \n httpStatusCode = %ld \n   **************************", response.httpStatusCode);
        }
            break;
        case JYResponseErrorTypeSuccess:{
            self.responseData = response.responseData;
            self.message = response.message;
            return [self.delegate managerCallAPIDidSuccess:self];
        }
            break;
        case JYResponseErrorTypeNoContent:{
            self.message = JY_RequestError;
        }
            break;
        case JYResponseErrorTypeTimeout:{
            self.message = JY_RequestOutTime;
        }
            break;
        case JYResponseErrorTypeNoNetWork:{
            self.message = JY_RequestNoNetwork;
        }
            break;
        case JYResponseErrorTypeParamsError:{
            self.message = JY_RequestError;
        }
            break;
        default:
            break;
    }
    [self.delegate managerCallAPIDidFailed:self];
}
#pragma mark 检验请求是否合格
-(JY_HttpResponse*)checkRequestInfo: (JYRequestMethodType)method parameters: (NSDictionary *)parameters imageListBlack:(NetWorkUpload)imageListBlack{
    JY_HttpResponse *errorResponse = nil;
    switch (method) {
        case JYRequestMethod_Upload:{
            if (imageListBlack==nil) {
                errorResponse = [[JY_HttpResponse alloc]initWithResponseErrorType:JYResponseErrorTypeParamsError];
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
    return errorResponse;
}

#pragma mark 检验网络是否合格
-(JY_HttpResponse*)checkNetWrok{
    JY_HttpResponse *errorResponse = nil;
    DetectionNetworkType networkState = [JY_MonitorNewWork sharedRequestInstance].currentNetworkType;
    if (networkState==knownNetwork || networkState ==NoNetwork) {
        errorResponse = [[JY_HttpResponse alloc]initWithResponseErrorType:JYResponseErrorTypeNoNetWork];
    }
    return errorResponse;
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------
-(JY_BaseResponseModel *)baseResponseModel{
    if (!_baseResponseModel) {
        _baseResponseModel  = [[JY_BaseResponseModel alloc]init];
    }
    return _baseResponseModel;
}


@end
