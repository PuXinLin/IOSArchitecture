//
//  JY_HttpResponse.m
//  JYProject
//
//  Created by dayou on 2017/7/30.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpResponse.h"

@interface JY_HttpResponse()
@property (nonatomic ,assign ,readwrite)JYResponseErrorType responseErrorType;
@property (nonatomic ,strong ,readwrite)id responseData;
@property (nonatomic, assign, readwrite)NSInteger httpStatusCode;
@end

@implementation JY_HttpResponse

#pragma mark ---------- Public Methods ----------
#pragma mark 请求成功响应
- (instancetype)initWithResponseObject:(id)responseObject urlResponse:(NSHTTPURLResponse *)urlResponse{
    self = [super init];
    if (self) {
        self.responseData = responseObject;
        self.httpStatusCode = urlResponse.statusCode;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.message = jy_safeString(responseObject[@"message"]);
        }
    
        /* 这里可以检验responseObject 根据自己需求来 */
        if ([self checkResponseData:responseObject]) {
            self.responseErrorType = JYResponseErrorTypeSuccess;
        }
        else{
            self.responseErrorType = JYResponseErrorTypeNoContent;
        }
    }
    return self;
}

#pragma mark 请求失败响应
- (instancetype)initWithUrlResponse:(NSHTTPURLResponse *)urlResponse error:(NSError *)error{
    self = [super init];
    if (self) {
        self.httpStatusCode = urlResponse.statusCode;
        self.message = [self handelError:error];
    }
    return self;
}

#pragma mark 直接失败 不走请求
- (instancetype)initWithResponseErrorType:(JYResponseErrorType)responseErrorType{
    self = [super init];
    if (self) {
        self.responseErrorType = responseErrorType==JYResponseErrorTypeSuccess?JYResponseErrorTypeDefault:responseErrorType; //不允许设置请求成功
    }
    return self;
}

#pragma mark ---------- Private Methods ----------
-(NSString*)handelError:(NSError *)error{
    NSString *errorMsg = JY_RequestError;
    self.responseErrorType = JYResponseErrorTypeDefault;
    if (error) {
        NSData *responseData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (responseData) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
            if ([response isKindOfClass:[NSDictionary class]]) {
                /* 请求失败 多半连不上服务器接口 那么这里不会有进来 */
                errorMsg = jy_safeString(response[@"message"]);
                return errorMsg;
            }
        }
        if (jy_safeNumber(error.userInfo[@"_kCFStreamErrorCodeKey"]).integerValue == -2102) {
            self.responseErrorType = JYResponseErrorTypeTimeout;
        }
    }
    return errorMsg;

}

#pragma mark 检验response是否合格
-(BOOL)checkResponseData:(id)responseObject{
    return [responseObject[@"status"] integerValue] == 1;
}
#pragma mark 配置Model
-(void)configurationModel{}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
