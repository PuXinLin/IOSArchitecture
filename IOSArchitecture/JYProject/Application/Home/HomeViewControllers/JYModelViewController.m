//
//  JYModelViewController.m
//  JYProject
//
//  Created by dayou on 2017/8/1.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JYModelViewController.h"

@interface JYModelViewController ()

@end

@implementation JYModelViewController

#pragma mark ---------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configurationController];
    [self loadRequestData];
    [self resizeCustomView];
    JY_Log(@"%@",self.jystring);
}

#pragma mark ---------- Private Methods ----------
#pragma mark 配置Controller
-(void)configurationController{}

#pragma mark 数据请求
-(void)loadRequestData{}

#pragma mark 页面初始化
-(void)resizeCustomView{}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
