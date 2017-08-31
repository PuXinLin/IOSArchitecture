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
+(JY_HttpRequestResend*)createRequestResendWithAPI:(NSString*)api method: (JYRequestMethodType)method parameters:(NSDictionary*)parameters imageListBlack:(NetWorkUpload)imageListBlack
{
    JY_HttpRequestResend *resend = [[JY_HttpRequestResend alloc]init];
    resend.api = api;
    resend.parameters = parameters;
    resend.method = method;
    resend.imageListBlack = imageListBlack;
    resend.resendResquestCount = 1;
    resend.resendRequest = YES;
    return resend;
}

#pragma mark ---------- Private Methods ----------

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
