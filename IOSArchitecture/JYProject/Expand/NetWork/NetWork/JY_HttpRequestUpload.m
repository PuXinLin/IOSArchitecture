//
//  JY_HttpRequestUpload.m
//  JYProject
//
//  Created by dayou on 2017/7/28.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpRequestUpload.h"

@implementation JY_HttpRequestUpload



#pragma mark ---------- Public Methods ----------
+ (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
              imageListBlack:(NetWorkUpload)imageListBlack
                    callBack: (ITFinishedBlock)finishedBlock{
    [JY_HttpRequestUpload netRequestPOSTWithRequestURL:URLString WithParameter:parameters imageListBlack:imageListBlack WithReturnValeuBlock:finishedBlock];
}
#pragma mark ---------- Private Methods ----------

#pragma mark POST上传
+ (void) netRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                       imageListBlack:(NetWorkUpload)imageListBlack
                 WithReturnValeuBlock: (ITFinishedBlock) finishedBlock {
    
    NSString * stringUrl = [NSString stringWithFormat:@"%@%@",JY_APP_URL,requestURLString]; // 拼接请求url
    [[JY_HTTPSessionManager sharedRequestInstance]POST:stringUrl parameters:parameter constructingBodyWithBlock:imageListBlack progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finishedBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#warning 弹框提示请检查网络
        JY_Log(@"弹框提示请检查网络");
    }];
}
#pragma mark 配置Model
-(void)configurationModel{}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
