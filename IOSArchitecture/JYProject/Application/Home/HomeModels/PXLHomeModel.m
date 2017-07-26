//
//  PXLHomeModel.m
//  JYProject
//
//  Created by dayou on 2017/7/26.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "PXLHomeModel.h"

@implementation PXLHomeModel

-(instancetype)init{
    self = [super init];
    if (self) {
        [self configurationModel];
        [self loadRequestData];
    }
    return self;
}


#pragma mark ---------- Methods ----------
#pragma mark 配置Model
-(void)configurationModel{}

#pragma mark 数据请求
-(void)loadRequestData{}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
