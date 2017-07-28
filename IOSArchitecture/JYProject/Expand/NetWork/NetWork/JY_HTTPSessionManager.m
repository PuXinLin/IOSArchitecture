//
//  JY_HTTPSessionManager.m
//  JYProject
//
//  Created by dayou on 2017/7/28.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HTTPSessionManager.h"

@implementation JY_HTTPSessionManager

#pragma mark ---------- Public Methods ----------
+ (instancetype)sharedRequestInstance {
    static JY_HTTPSessionManager *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[JY_HTTPSessionManager alloc]init];
        __sharedInstance.requestSerializer.timeoutInterval = 10.f; // 默认10秒
        __sharedInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil]; // 默认支持类型
        
    });
    return __sharedInstance;
}

+ (void)cancleAllRequest{
    [[JY_HTTPSessionManager sharedRequestInstance].operationQueue cancelAllOperations];
}
#pragma mark ---------- Private Methods ----------

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

-(void)setJy_timeoutInterval:(NSInteger)jy_timeoutInterval{
    self.requestSerializer.timeoutInterval = jy_timeoutInterval;
}

@end
