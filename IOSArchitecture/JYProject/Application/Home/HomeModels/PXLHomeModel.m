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

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------
+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    
    return @{
             @"appUserForMyCircleDto":@"PXLHomeSubModel"
             };
}

#pragma mark ---------- Lazy Load ----------

@end
