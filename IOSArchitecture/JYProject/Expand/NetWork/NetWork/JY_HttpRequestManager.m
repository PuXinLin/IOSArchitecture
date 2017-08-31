//
//  JY_HttpRequestManager.m
//  JYProject
//
//  Created by dayou on 2017/8/3.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpRequestManager.h"
#import "JYNoNetWorkView.h"

@interface JY_HttpRequestManager()<JY_HttpRequestCallBackDelegate,JYNoNetWorkViewDelegate>
/* 请求 */
@property (nonatomic ,strong)JY_HttpRequest *request;
/* 提示框 */
@property (nonatomic ,strong)UIView *superViewHUB;
/* 重新请求数据 */
@property (nonatomic ,strong)JY_HttpRequestResend *requestResend;

@end

@implementation JY_HttpRequestManager

#pragma mark ---------- Life Cycle ----------
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NetWorkStateChangeName object:nil];
}

#pragma mark ---------- Private Methods ----------
#pragma mark 初始化方法
+(instancetype)loadDataHUDwithView:(UIView*)view
{
    /* 网络请求失败 可以把view替换 */
    JY_HttpRequestManager * request = [[JY_HttpRequestManager alloc]init];
    request.superViewHUB = view;
    return request;
}

#pragma mark 数据请求
- (void)requestWithURLString: (NSString *)URLString
                      method: (JYRequestMethodType)method
                  parameters: (NSDictionary *)parameters
              imageListBlack:(NetWorkUpload)imageListBlack
{
    if (!_requestResend) {
        _requestResend = [JY_HttpRequestResend createRequestResendWithAPI:URLString method:method parameters:parameters imageListBlack:imageListBlack];
    }
    /* 提示框 */
    [self showPromptWithRequest:YES response:nil];
    
    /* 请求 */
    self.request.notResendResquest = self.notResendResquest;
    [self.request requestWithURLString:URLString method:method parameters:parameters imageListBlack:imageListBlack];
}

#pragma mark 取消所有数据请求
- (void)cancleAllRequest{
    [self.request cancleAllRequest];
}

#pragma mark 网络改变 恢复加载失败的页面
-(void)restroeRequestWithRequestResend:(JY_HttpRequestResend*)requestResend
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetWorkStateChange:) name:NetWorkStateChangeName object:nil];
}
#pragma mark 网络改变监听
-(void)NetWorkStateChange:(NSNotification*)notification
{
    if ([JY_MonitorNewWork sharedRequestInstance].isNetwork) {
        if (self.requestResend.resendRequest) {
            [self reloadRequest];
        }
    }
}

#pragma mark 提示框显示
-(void)showPromptWithRequest:(BOOL)starRequest response:(JY_BaseResponseModel*)response{
    [JYProgressHUD hideProgressJY:self.superViewHUB];
    [JYProgressHUD hideProgressJY:JY_APP_KeyWindow];
    if (starRequest) {
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
        switch (self.requestShowType) {
            case JYRequestShowType_ResponseViewShow:
            {
                [JYProgressHUD showMessageJY:response.message onView:self.superViewHUB progressType:JYProgress_RequestError];
            }
                break;
            case JYRequestShowType_RequestAndResponseViewShow:
            {
                if (response.responseErrorType != JYResponseErrorTypeSuccess &&self.requestResend.resendRequest) {
                    MBProgressHUD *progressHUD = [JYProgressHUD showMessageJY:response.message onView:self.superViewHUB progressType:JYProgress_RequestError];
                    if (progressHUD) {
                        ((JYNoNetWorkView*)progressHUD.customView).delegate = self;
                    }
                }
            }
                break;
            case JYRequestShowType_ResponseWindowShow:
            {
                if (response.responseErrorType != JYResponseErrorTypeSuccess) {
                    [JYProgressHUD showMessageJY:response.message  progressType:JYProgress_Text];
                }
            }
                break;
            case JYRequestShowType_RequestAndResponseWindowShow:
            {
                if (response.responseErrorType != JYResponseErrorTypeSuccess) {
                    [JYProgressHUD showMessageJY:response.message  progressType:JYProgress_Text];
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

#pragma mark JY_HttpRequestCallBackDelegate
- (void)managerCallAPIDidSuccess:(JY_BaseResponseModel *)response
{
    if (self.starCache) { //缓存
        if (response.responseErrorType == JYResponseErrorTypeSuccess) {
            [JYCache cacheResponseData:response.responseData Url:response.api parameters:response.parameters];
            [self showPromptWithRequest:NO response:response];
        }
        else{ //获取的缓存
            [JYProgressHUD hideProgressJY:self.superViewHUB];
            [JYProgressHUD hideProgressJY:JY_APP_KeyWindow];
        }
    }
    else{
        [self showPromptWithRequest:NO response:response];
    }
    self.requestResend.resendRequest = NO;
    [self.delegate managerCallAPIDidSuccess:response];
}
- (void)managerCallAPIDidFailed:(JY_BaseResponseModel *)response
{
    [self showPromptWithRequest:NO response:response];
    if (response.httpStatusCode == -999) { // 手动取消
        return;
    }
    if (self.starCache) { //获取缓存
        id responseData = [JYCache getCacheResponseDataForUrl:response.api parameters:response.parameters];
        if (responseData) {
            response.responseData = responseData;
            return [self managerCallAPIDidSuccess:response];
        }
    }
    /* 网络状态改变 恢复失败请求 */
    if (self.netWorkChangeRestoreRequest&&self.requestResend.resendRequest) {
        self.netWorkChangeRestoreRequest = NO;
        [self restroeRequestWithRequestResend:_requestResend];
    }
    [self.delegate managerCallAPIDidFailed:response];
}
- (void)managerCallAPIUploadProgressWithCurrentProgress:(CGFloat)currentProgress{
    [self.delegate managerCallAPIUploadProgressWithCurrentProgress:currentProgress];
}

#pragma mark JYNoNetWorkViewDelegate
-(void)reloadRequest
{
    [self requestWithURLString:_requestResend.api method:_requestResend.method parameters:_requestResend.parameters imageListBlack:_requestResend.imageListBlack];
}

#pragma mark ---------- Lazy Load ----------
-(JY_HttpRequest *)request{
    if (!_request) {
        _request = [[JY_HttpRequest alloc]init];
        _request.delegate = self;
    }
    return _request;
}

@end
