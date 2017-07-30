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
- (instancetype)initWithResponseObject:(id)responseObject urlResponse:(NSHTTPURLResponse *)urlResponse{
    if (!self) {
        self = [[JY_HttpResponse alloc]init];
        self.responseData = responseObject;
        self.httpStatusCode = urlResponse.statusCode;
    }
    return self;
}

/* 请求失败响应 */
- (instancetype)initWithUrlResponse:(NSHTTPURLResponse *)urlResponse error:(NSError *)error{
    if (!self) {
        self = [[JY_HttpResponse alloc]init];
        self.httpStatusCode = urlResponse.statusCode;
        self.message = [self handelError:error];
        if (self.httpStatusCode == 11010) { // 请求超时
            self.responseErrorType = JYResponseErrorTypeDefault;
        }
    }
    return self;
}
#pragma mark ---------- Private Methods ----------
-(NSString*)handelError:(NSError *)error{
    NSString *errorMsg = JY_RequestError;
    if (error) {
        NSData *responseData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (responseData) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
            if ([response isKindOfClass:[NSDictionary class]]) {
#warning msg 后台控制提醒内容字段
                errorMsg = jy_safeString(response[@"msg"]);
                return errorMsg;
            }
        }
        if (jy_safeNumber(error.userInfo[@"_kCFStreamErrorCodeKey"]).integerValue == -2102) {
            errorMsg = JY_RequestOutTime;
        }
    }
    return errorMsg;

}
#pragma mark 配置Model
-(void)configurationModel{}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
