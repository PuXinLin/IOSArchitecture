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
/* 恢复请求数据 */
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
+(instancetype)loadDataRequestManager
{
    JY_HttpRequestManager * requestManager = [[JY_HttpRequestManager alloc]init];
    return requestManager;
}

+(instancetype)loadDataRequestManagerWithView:(UIView*)view
{
    /* 网络请求失败 可以把view替换 */
    JY_HttpRequestManager * request = [JY_HttpRequestManager loadDataRequestManager];
    request.superViewHUB = view;
    return request;
}

#pragma mark 数据请求配置
- (void)requestWithURLString: (NSString *)URLString
                      method: (JYRequestMethodType)method
                  parameters: (NSDictionary *)parameters
              imageListBlack:(NetWorkUpload)imageListBlack
{
    /* api信息 */
    _requestResend = [JY_HttpRequestResend createRequestResendWithAPI:URLString method:method parameters:parameters imageListBlack:imageListBlack];
    _apiDetails = _requestResend.apiDetails;
    self.request.notResendResquest = self.notResendResquest;
}

#pragma mark 开始数据请求
- (void)startRequest
{
    /* 提示框 */
    [self showPromptWithRequest:YES message:nil responseErrorType:0];
    /* 获取缓存 */
    if (self.openCache) {
        id responseData = [self readCache];
        if (responseData) {
            JY_BaseResponseModel *responseModel = [[JY_BaseResponseModel alloc]init];
            responseModel.responseData = responseData;
            responseModel.api = _apiDetails.api;
            responseModel.responseErrorType = JYResponseErrorTypeDataCache;
            [self managerCallAPIDidSuccess:responseModel];
        }
    }
    /* 发起请求 */
    [self.request requestWithURLString:_apiDetails.api method:_apiDetails.method parameters:_apiDetails.parameters imageListBlack:_apiDetails.imageListBlack];
}
#pragma mark 取消数据请求
- (void)cancleRequest{
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
-(void)showPromptWithRequest:(BOOL)starRequest message:(NSString*)message responseErrorType:(JYResponseErrorType)responseErrorType
{
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
                [JYProgressHUD showMessageJY:message onView:self.superViewHUB progressType:JYProgress_RequestError];
            }
                break;
            case JYRequestShowType_RequestAndResponseViewShow:
            {
                if (responseErrorType != JYResponseErrorTypeSuccess &&self.requestResend.resendRequest) {
                    MBProgressHUD *progressHUD = [JYProgressHUD showMessageJY:message onView:self.superViewHUB progressType:JYProgress_RequestError];
                    if (progressHUD) {
                        ((JYNoNetWorkView*)progressHUD.customView).delegate = self;
                    }
                }
            }
                break;
            case JYRequestShowType_ResponseWindowShow:
            {
                if (responseErrorType != JYResponseErrorTypeSuccess) {
                    [JYProgressHUD showMessageJY:message  progressType:JYProgress_Text];
                }
            }
                break;
            case JYRequestShowType_RequestAndResponseWindowShow:
            {
                if (responseErrorType != JYResponseErrorTypeSuccess) {
                    [JYProgressHUD showMessageJY:message  progressType:JYProgress_Text];
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark 读取缓存数据
-(id)readCache{
    return [JYCache getCacheResponseDataForUrl:_apiDetails.api parameters:_apiDetails.parameters];;
}
#pragma mark 缓存数据
-(void)wirteCacheWithResponse:(id)response{
    [JYCache cacheResponseData:response Url:_apiDetails.api parameters:_apiDetails.parameters];
}
#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark JY_HttpRequestCallBackDelegate
- (void)managerCallAPIDidSuccess:(JY_BaseResponseModel *)response
{
    /* 隐藏提升框 */
    [self showPromptWithRequest:NO message:response.message responseErrorType:response.responseErrorType];
    /* 缓存 */
    if (self.openCache&&response.responseErrorType == JYResponseErrorTypeSuccess) {
        [self wirteCacheWithResponse:response.responseData];
        
    }
    /* 关闭网络改变恢复请求 */
    if (self.netWorkChangeRestoreRequest) {
        self.requestResend.resendRequest = NO;
    }
    [self.delegate managerCallAPIDidSuccess:response];
}

- (void)managerCallAPIDidFailed:(JY_BaseResponseModel *)response
{
    /* 隐藏提升框 */
    [self showPromptWithRequest:NO message:response.message responseErrorType:response.responseErrorType];
    /* 手动取消任务 不需要回调 */
    if (response.httpStatusCode == -999) {
        return;
    }
    /* 开启网络状态改变 恢复失败请求 */
    if (self.netWorkChangeRestoreRequest&&self.requestResend.resendRequest) {
        self.netWorkChangeRestoreRequest = NO;
        [self restroeRequestWithRequestResend:_requestResend];
    }
    /* 请求失败回调 */
    [self.delegate managerCallAPIDidFailed:response];
}
- (void)managerCallAPIUploadProgressWithCurrentProgress:(CGFloat)currentProgress{
    [self.delegate managerCallAPIUploadProgressWithCurrentProgress:currentProgress];
}

#pragma mark JYNoNetWorkViewDelegate
-(void)reloadRequest
{
    [self startRequest];
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
