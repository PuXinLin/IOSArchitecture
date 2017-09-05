//
//  JY_TabBarController.m
//  JYProject
//
//  Created by dayou on 2017/8/14.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_TabBarController.h"
#import "JY_NavigationVController.h"

@interface JY_TabBarController ()

@end

@implementation JY_TabBarController

#pragma mark ---------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resizeCustomView];
}

#pragma mark ---------- Private Methods ----------

#pragma mark 页面初始化
-(void)resizeCustomView{
    /* 背景  阴影 必须一起设置才能隐藏 */
    UIImage *backgroundImage = [UIImage jy_createImageWithColor:[UIColor clearColor] frame:(CGRect){{0, 0},self.tabBar.size} Radius:0];
    UIImage *shadowImage = [UIImage jy_createImageWithColor:[UIColor clearColor] frame:(CGRect){{0, 0},{JY_IPHONE_Width,1}} Radius:0];
    [self.tabBar setBackgroundImage:backgroundImage];
    [self.tabBar setShadowImage:shadowImage];
    
    /* 项 */
    [self addSubController];
}

#pragma mark 添加子控制器
-(void)addSubController
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"TabBarInfo" ofType:@"plist"];
    NSArray *tabbarInfo = [NSDictionary dictionaryWithContentsOfFile:path][@"TabBarInfo"];
    
    for (NSDictionary*tabbarInfoItem in tabbarInfo) {
        UIViewController *viewController = [NSClassFromString(tabbarInfoItem[@"ViewControllerName"]) new];
        viewController.title = tabbarInfoItem[@"TabBarButtonTitle"];
        JY_NavigationVController *navigationController = [[JY_NavigationVController alloc]initWithRootViewController:viewController];
        navigationController.tabBarItem = [self getTabbarItemWithTabbarInfo:tabbarInfoItem];
        [self addChildViewController:navigationController];
    }
}

#pragma mark 初始化TabBarItem
-(UITabBarItem*)getTabbarItemWithTabbarInfo:(NSDictionary*)tabbarInfoItem
{
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]init];

    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:10.f]} forState:UIControlStateNormal];
    tabBarItem.title = tabbarInfoItem[@"TabBarButtonTitle"];
    
    UIImage *defaultImage = [UIImage imageNamed:tabbarInfoItem[@"TabBarButtonDefaultImage"]];
    defaultImage = [defaultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.image = defaultImage;
    
    UIImage *selectImage = [UIImage imageNamed:tabbarInfoItem[@"TabBarButtonSelectImage"]];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.selectedImage = selectImage;
    
    return tabBarItem;
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end
