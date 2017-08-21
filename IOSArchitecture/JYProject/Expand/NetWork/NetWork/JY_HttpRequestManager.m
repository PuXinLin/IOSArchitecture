//
//  JY_HttpRequestManager.m
//  JYProject
//
//  Created by dayou on 2017/8/3.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpRequestManager.h"

@interface JY_HttpRequestManager()<JY_HttpRequestCallBackDelegate>
/* 请求 */
@property (nonatomic ,strong)JY_HttpRequest *request;
/* 提示框 */
@property (nonatomic ,strong)UIView *superViewHUB;

@end

@implementation JY_HttpRequestManager

#pragma mark ---------- Life Cycle ----------

#pragma mark ---------- Private Methods ----------
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
    /* 可以根据参赛和Token 生成验收字段 根据需求来 */
    [self showPromptWithRequest:YES response:nil];
    [self.request requestWithURLString:URLString method:method parameters:parameters imageListBlack:imageListBlack];
}

#pragma mark 取消所有数据请求
- (void)cancleAllRequest{
    [self.request cancleAllRequest];
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
                if (response.responseErrorType != JYResponseErrorTypeSuccess) {
                    [JYProgressHUD showMessageJY:response.message onView:self.superViewHUB progressType:JYProgress_RequestError];
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
- (void)managerCallAPIDidSuccess:(JY_BaseResponseModel *)response{
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
    [self.delegate managerCallAPIDidSuccess:response];
}

- (void)managerCallAPIDidFailed:(JY_BaseResponseModel *)response{
    if (self.starCache) { //获取缓存
        id responseData = [JYCache getCacheResponseDataForUrl:response.api parameters:response.parameters];
        if (responseData) {
            response.responseData = responseData;
            return [self managerCallAPIDidSuccess:response];
        }
    }
    [self showPromptWithRequest:NO response:response];
    [self.delegate managerCallAPIDidFailed:response];
}

- (void)managerCallAPIUploadProgressWithCurrentProgress:(CGFloat)currentProgress{
    [self.delegate managerCallAPIUploadProgressWithCurrentProgress:currentProgress];
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
