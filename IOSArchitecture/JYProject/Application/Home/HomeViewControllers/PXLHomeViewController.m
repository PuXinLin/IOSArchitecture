//
//  PXLHomeViewController.m
//  JYProject
//
//  Created by dayou on 2017/7/25.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "PXLHomeViewController.h"

@interface PXLHomeViewController ()

@end

@implementation PXLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configurationController];
    [self loadRequestData];
    [self resizeCustomView];
}

#pragma mark ---------- Methods ----------
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
