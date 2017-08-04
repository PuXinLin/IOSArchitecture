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

@property (nonatomic ,strong)NSString *requestUrl;

@property (nonatomic ,strong)NSDictionary *requestParameters;

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
    self.requestUrl = URLString;
    self.requestParameters = parameters;
    [self showPromptWithRequest:YES];
    [self.request requestWithURLString:URLString method:method parameters:parameters imageListBlack:imageListBlack];
}

#pragma mark 取消所有数据请求
- (void)cancleAllRequest{
    [[JY_HttpProxy sharedRequestInstance] cancleAllRequest];
}

#pragma mark 提示框显示
-(void)showPromptWithRequest:(BOOL)starRequest{
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
        [JYProgressHUD hideProgressJY:self.superViewHUB];
        [JYProgressHUD hideProgressJY:JY_APP_KeyWindow];
        switch (self.requestShowType) {
            case JYRequestShowType_ResponseViewShow:
            {
                [JYProgressHUD showMessageJY:self.request.message onView:self.superViewHUB progressType:JYProgress_RequestError];
            }
                break;
            case JYRequestShowType_RequestAndResponseViewShow:
            {
                if (self.request.errorType != JYResponseErrorTypeSuccess) {
                    [JYProgressHUD showMessageJY:self.request.message onView:self.superViewHUB progressType:JYProgress_RequestError];
                }
            }
                break;
            case JYRequestShowType_ResponseWindowShow:
            {
                if (self.request.errorType != JYResponseErrorTypeSuccess) {
                    [JYProgressHUD showMessageJY:self.request.message  progressType:JYProgress_Text];
                }
            }
                break;
            case JYRequestShowType_RequestAndResponseWindowShow:
            {
                if (self.request.errorType != JYResponseErrorTypeSuccess) {
                    [JYProgressHUD showMessageJY:self.request.message  progressType:JYProgress_Text];
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
- (void)managerCallAPIDidSuccess:(JY_HttpRequest *)request{
    if (self.starCache) { //缓存
        if (request.errorType == JYResponseErrorTypeSuccess) {
            [JYCache cacheResponseData:request.responseData Url:self.requestUrl parameters:self.requestParameters];
            [self showPromptWithRequest:NO];
        }
        else{ //获取的缓存
            [JYProgressHUD hideProgressJY:self.superViewHUB];
            [JYProgressHUD hideProgressJY:JY_APP_KeyWindow];
        }
    }
    else{
        [self showPromptWithRequest:NO];
    }
    [self.delegate managerCallAPIDidSuccess:request];
}

- (void)managerCallAPIDidFailed:(JY_HttpRequest *)request{
    if (self.starCache) { //获取缓存
        id responseData = [JYCache getCacheResponseDataForUrl:self.requestUrl parameters:self.requestParameters];
        if (responseData) {
            request.responseData = responseData;
            return [self managerCallAPIDidSuccess:request];
        }
    }
    [self showPromptWithRequest:NO];
    [self.delegate managerCallAPIDidFailed:request];
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
