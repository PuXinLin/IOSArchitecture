//
//  JY_BaseResponseModel.m
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_BaseResponseModel.h"

@implementation JY_BaseResponseModel

-(instancetype)init{
    self = [super init];
    if (self) {
        [self configurationModel];
    }
    return self;
}


#pragma mark ---------- Public Methods ----------
#pragma mark ---------- Private Methods ----------
#pragma mark 配置Model
-(void)configurationModel{}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
