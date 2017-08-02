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
@property (nonatomic, assign, readwrite)id responseData;
@property (nonatomic, copy,   readwrite)NSString *message;
/* 提示框 */
@property (nonatomic ,strong)UIView *superViewHUB;
@end

@implementation JY_HttpRequest

#pragma mark ---------- Public Methods ----------
+(instancetype)loadDataHUDwithView:(UIView*)view
{
    /* 网络请求失败 可以把view替换 */
    JY_HttpRequest * request = [[JY_HttpRequest alloc]init];
    request.superViewHUB = view;
    return request;
}

#pragma mark 数据请求
- (void)requestWithURLString: (NSString *)URLString
                      method: (JYRequestMethodType)method
                  parameters: (NSDictionary *)parameters
              imageListBlack:(NetWorkUpload)imageListBlack
{
    JY_HttpProxy *proxy = [JY_HttpProxy sharedRequestInstance];
    /* 这里可以检验是否发起请求 和 加密 */
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
    
    [self showPromptWithRequest:YES];
}

#pragma mark 取消所有数据请求
- (void)cancleAllRequest{
    [[JY_HttpProxy sharedRequestInstance] cancleAllRequest];
}

#pragma mark ---------- Private Methods ----------
#pragma mark 请求成功回调
-(void)successedOnCallingAPI:(JY_HttpResponse*)response{
    self.baseResponseModel = [JY_BaseResponseModel yy_modelWithJSON:response.responseData];
    if (response.responseErrorType == JYResponseErrorTypeNoContent) {
        [self failedOnCallingAPI:response];
        return;
    }
    self.responseData = response.responseData;
    self.message = response.message;
    self.errorType = response.responseErrorType;
    [self.delegate managerCallAPIDidSuccess:self];
    [self showPromptWithRequest:NO];
}

#pragma mark 请求失败回调
-(void)failedOnCallingAPI:(JY_HttpResponse*)response{
    
    switch (response.responseErrorType) {
        case JYResponseErrorTypeDefault:{
            self.message = JY_RequestError;
            JY_Log(@"*************httpStatusCode = %ld*************", response.httpStatusCode);
        }
            break;
        case JYResponseErrorTypeSuccess:{
            
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
    self.errorType = response.responseErrorType;
    [self showPromptWithRequest:NO];
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

#pragma mark 提示框显示
-(void)showPromptWithRequest:(BOOL)request{
    if (request) {
        switch (self.requestShowType) {
            case JYRequestShowType_RequestViewShow:
            {
                [JYProgressHUD showMessageJY:JY_RequestLoading onView:self.superViewHUB progressType:JYProgress_TextAndLoading];
            }
                break;
            case JYRequestShowType_RequestAndResponseViewShow:
            {
                [JYProgressHUD showMessageJY:JY_RequestLoading onView:self.superViewHUB progressType:JYProgress_TextAndLoading];
            }
                break;
            case JYRequestShowType_RequestWindowShow:
            {
                [JYProgressHUD showMessageJY:JY_RequestLoading progressType:JYProgress_TextAndLoading];
            }
                break;
            case JYRequestShowType_RequestAndResponseWindowShow:
            {
                [JYProgressHUD showMessageJY:JY_RequestLoading progressType:JYProgress_TextAndLoading];
            }
                break;
            default:
                break;
        }
    }
    else
    {
        [JYProgressHUD hideProgressJY:self.superViewHUB];
        [JYProgressHUD hideProgressJY:JY_APP_KeyWindow];
        switch (self.requestShowType) {
            case JYRequestShowType_ResponseViewShow:
            {
                [JYProgressHUD showMessageJY:self.message onView:self.superViewHUB progressType:JYProgress_RequestError];
            }
                break;
            case JYRequestShowType_RequestAndResponseViewShow:
            {
                [JYProgressHUD showMessageJY:self.message onView:self.superViewHUB progressType:JYProgress_RequestError];
            }
                break;
            case JYRequestShowType_ResponseWindowShow:
            {
                if (self.errorType != JYResponseErrorTypeSuccess) {
                    [JYProgressHUD showMessageJY:self.message  progressType:JYProgress_Text];
                }
            }
                break;
            case JYRequestShowType_RequestAndResponseWindowShow:
            {
                if (self.errorType != JYResponseErrorTypeSuccess) {
                    [JYProgressHUD showMessageJY:self.message  progressType:JYProgress_Text];
                }
            }
                break;
            default:
                break;
        }

    }
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
