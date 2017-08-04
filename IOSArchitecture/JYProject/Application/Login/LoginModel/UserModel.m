//
//  UserModel.m
//  JYProject
//
//  Created by dayou on 2017/8/3.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

#pragma mark ---------- Life Cycle ----------

#pragma mark ---------- Private Methods ----------
+ (instancetype)sharedRequestInstance
{
    static UserModel *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[UserModel alloc]init];
    });
    return __sharedInstance;
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
