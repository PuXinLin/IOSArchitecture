//
//  PXLHomeView.m
//  JYProject
//
//  Created by dayou on 2017/7/26.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "PXLHomeView.h"

@implementation PXLHomeView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self configurationView];
        [self loadRequestData];
        [self resizeCustomView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurationView];
        [self loadRequestData];
        [self resizeCustomView];
    }
    return self;
}

#pragma mark ---------- Methods ----------
#pragma mark 配置View
-(void)configurationView{}

#pragma mark 数据请求
-(void)loadRequestData{}

#pragma mark 页面初始化
-(void)resizeCustomView{}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
