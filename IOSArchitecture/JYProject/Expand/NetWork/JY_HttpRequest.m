//
//  JY_HttpRequest.m
//  JYProject
//
//  Created by dayou on 2017/7/27.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpRequest.h"

@implementation JY_HttpRequest


#pragma mark ---------- Methods ----------
#pragma mark 数据请求
+ (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (MethodState)method
                    callBack: (ITFinishedBlock)finishedBlock{
    if (method == Method_POST) {
        
    }
    else if (method == Method_GET){
        
    }
}
#pragma mark 关闭所有数据请求
+ (void)cancleAllRequest{
    
}

+(void)netWorkStateDetection{
    
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
