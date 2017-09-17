//
//  JY_HttpResponse.m
//  JYProject
//
//  Created by dayou on 2017/7/30.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpResponse.h"
#import "NSObject+AddMethods.h"

@interface JY_HttpResponse()
@property (nonatomic, strong, readwrite)JY_BaseResponseModel *baseResponseModel;
@end

@implementation JY_HttpResponse
#pragma mark ---------- Life Cycle ----------

#pragma mark ---------- Public Methods ----------
#pragma mark 开始请求
- (instancetype)initWithRequestId:(NSNumber*)requestId api:(NSString*)api parameters:(NSDictionary*)parameters{
    self = [super init];
    if (self) {
        self.baseResponseModel.requestId = requestId;
        self.baseResponseModel.api = api;
        self.baseResponseModel.parameters = parameters;
    }
    return self;
}

#pragma mark 请求成功响应
- (void)requestWithResponseObject:(id)responseObject urlResponse:(NSHTTPURLResponse *)urlResponse{
    self.baseResponseModel.responseData = responseObject;
    [self setResponseModelWithUrlResponse:urlResponse];
    [self checkResponseData:self.baseResponseModel];
}

#pragma mark 请求失败响应 
- (void)requestWithUrlResponse:(NSHTTPURLResponse *)urlResponse error:(NSError *)error{
    [self handelError:error];
    [self setResponseModelWithUrlResponse:urlResponse];
}

#pragma mark ---------- Private Methods ----------
#pragma mark 获取响应状态
-(void)setResponseModelWithUrlResponse:(NSHTTPURLResponse *)urlResponse
{
    if (!urlResponse) {
        self.baseResponseModel.descr = @"服务器没有响应 请检查网址和网络";
        return;
    }
    self.baseResponseModel.descr = [NSString stringWithFormat:@"%@%zd",@"httpStatusCode = ",urlResponse.statusCode];
    self.baseResponseModel.httpStatusCode = urlResponse.statusCode;
    self.baseResponseModel.url = urlResponse.URL.absoluteString;
}

#pragma mark 获取错误信息
-(void)handelError:(NSError *)error{
    self.baseResponseModel.responseErrorType = JYResponseErrorTypeDefault;
    if (error) {
        if (jy_safeNumber(error.userInfo[@"_kCFStreamErrorCodeKey"]).integerValue == -2102) {
            self.baseResponseModel.responseErrorType = JYResponseErrorTypeTimeout;
        }
        self.baseResponseModel.httpStatusCode = error.code;
        self.baseResponseModel.url = error.userInfo[@"NSErrorFailingURLStringKey"];
    }
}

#pragma mark 检验response是否合格
-(void)checkResponseData:(JY_BaseResponseModel*)response
{
    if ([response.responseData[@"status"] integerValue] == 1) {
        response.responseErrorType = JYResponseErrorTypeSuccess;
    }
    else{
        response.responseErrorType = JYResponseErrorTypeNoContent;
    }
}
#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

-(JY_BaseResponseModel *)baseResponseModel{
    if (!_baseResponseModel) {
        _baseResponseModel = [[JY_BaseResponseModel alloc]init];
    }
    return _baseResponseModel;
}

@end
