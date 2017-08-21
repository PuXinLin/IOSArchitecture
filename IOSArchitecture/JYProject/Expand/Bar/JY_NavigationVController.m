//
//  JY_NavigationVController.m
//  JYProject
//
//  Created by dayou on 2017/8/14.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_NavigationVController.h"

@interface JY_NavigationVController ()

@end

@implementation JY_NavigationVController

#pragma mark ---------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configurationController];
    [self loadRequestData];
    [self resizeCustomView];
}

#pragma mark ---------- Private Methods ----------
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}
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
