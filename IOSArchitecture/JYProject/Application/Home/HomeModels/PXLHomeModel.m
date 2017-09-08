//
//  PXLHomeModel.m
//  JYProject
//
//  Created by dayou on 2017/7/26.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "PXLHomeModel.h"

@implementation PXLHomeModel
#pragma mark ---------- Life Cycle ----------
-(instancetype)init{
    self = [super init];
    if (self) {
        [self configurationModel];
    }
    return self;
}

#pragma mark ---------- Private Methods ----------
#pragma mark 配置Model
-(void)configurationModel{}
#pragma mark 包含
+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
             @"dataListModel":@"PXLDataListModel"
             };
}
#pragma mark 白名单 (模型属性 转换 key)
+ (NSArray *)modelPropertyWhitelist {
    return @[@"appUserForMyCircleDto",
             @"dataListModel"];
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
