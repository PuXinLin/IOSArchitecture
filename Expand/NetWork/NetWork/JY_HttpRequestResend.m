//
//  JY_HttpRequestResend.m
//  JYProject
//
//  Created by dayou on 2017/8/24.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpRequestResend.h"

@implementation JY_HttpRequestResend

#pragma mark ---------- Life Cycle ----------

#pragma mark ---------- Private Methods ----------
+(JY_HttpRequestResend*)createRequestResendWithAPI:(NSString*)api method: (JYRequestMethodType)method parameters:(NSDictionary*)parameters imageListBlack:(NetWorkUpload)imageListBlack
{
    JY_HttpRequestResend *resend = [[JY_HttpRequestResend alloc]init];
    resend.apiDetails = [JY_HttpAPIDetails createAPIDetailsWithAPI:api method:method parameters:parameters imageListBlack:imageListBlack];
    resend.resendResquestCount = 1;
    resend.resendRequest = YES;
    return resend;
}
#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end

@implementation JY_HttpAPIDetails
+(JY_HttpAPIDetails*)createAPIDetailsWithAPI:(NSString*)api method: (JYRequestMethodType)method parameters:(NSDictionary*)parameters imageListBlack:(NetWorkUpload)imageListBlack{
    JY_HttpAPIDetails *apiDetails = [[JY_HttpAPIDetails alloc]init];
    apiDetails.api = api;
    apiDetails.parameters = parameters;
    apiDetails.method = method;
    apiDetails.imageListBlack = imageListBlack;
    return apiDetails;
}
@end
