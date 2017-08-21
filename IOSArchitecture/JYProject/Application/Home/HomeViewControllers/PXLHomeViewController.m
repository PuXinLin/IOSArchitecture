//
//  PXLHomeViewController.m
//  JYProject
//
//  Created by dayou on 2017/7/25.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "PXLHomeViewController.h"
#import "PXLHomeModel.h"
#import "JYModelViewController.h"
#import "PXLDownLoadViewController.h"

@interface PXLHomeViewController ()<JY_HttpRequestManagerCallBackDelegate>
/* test API */
@property (nonatomic ,strong)JY_HttpRequestManager *httpRequestManager;

/* 发起请求按钮 */
@property (nonatomic ,strong)UIButton *sendButton;

/* 弹框按钮 */
@property (nonatomic ,strong)UIButton *showButton;

/* 下一页按钮 */
@property (nonatomic ,strong)UIButton *pushControllerButton;

/* 下一页按钮 */
@property (nonatomic ,strong)UIButton *pushDownloadControllerButton;

@end

@implementation PXLHomeViewController

#pragma mark ---------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configurationController];
    [self resizeCustomView];
}

#pragma mark ---------- Methods ----------
#pragma mark 配置Controller
-(void)configurationController{
    self.view.backgroundColor = UIColor.whiteColor;
    /* 模拟用户登录 */
    UserModel * user = JY_User;
    user.userCacheKey = @"UserOne";
}

#pragma mark 数据请求
-(void)loadRequestData{
    [self.httpRequestManager requestWithURLString:JY_Url_Home_List method:JYRequestMethod_POST parameters:@{@"postType":@"1",@"pagenum":@"1",@"eqMy":@"2"} imageListBlack:nil];
}

#pragma mark 页面初始化
-(void)resizeCustomView{
    /* 点击按钮 */
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(100);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    /* 请求按钮 */
    [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(100);
        make.top.equalTo(self.view.mas_top).offset(200);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    /* 跳转按钮 */
    [self.pushControllerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(100);
        make.top.equalTo(self.view.mas_top).offset(300);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
    
    /* 跳转按钮 */
    [self.pushDownloadControllerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(100);
        make.top.equalTo(self.view.mas_top).offset(400);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
}

#pragma mark ---------- Click Event ----------
-(void)sendClick:(UIButton*)sender
{
    /*
    [JYCache userLoginCheckResponseOverdue];
     */
    [self.httpRequestManager cancleAllRequest];
    [JYProgressHUD hideProgressJY:self.view];
}
-(void)showClick:(UIButton*)sender
{
    for (int i = 0 ; i<10; i++) {
        [self.httpRequestManager requestWithURLString:[NSString stringWithFormat:@"%@%d",JY_Url_Home_List,i] method:JYRequestMethod_POST parameters:@{@"postType":@"1",@"pagenum":@"1",@"eqMy":@"2"} imageListBlack:nil];
    }
    [self.httpRequestManager requestWithURLString:JY_Url_Home_List method:JYRequestMethod_POST parameters:@{@"postType":@"1",@"pagenum":@"1",@"eqMy":@"2"} imageListBlack:nil];
//    [self.httpRequestManager requestWithURLString:JY_Url_Home_List method:JYRequestMethod_POST parameters:@{@"postType":@"1",@"pagenum":@"1",@"eqMy":@"2"} imageListBlack:nil];
//    [self.httpRequestManager requestWithURLString:@"app/postlista.do" method:JYRequestMethod_POST parameters:@{@"postType":@"1",@"pagenum":@"1",@"eqMy":@"2"} imageListBlack:nil];
}
-(void)pushControllerClick:(UIButton*)sender
{
    if (sender.tag) {
        JY_User.userCacheKey = @"UserOne";
    }
    else{
        JY_User.userCacheKey = @"UserTwo";
    }
    sender.tag = !sender.tag;
    [self.navigationController pushViewController:[[JYModelViewController alloc]init] animated:YES];
}
-(void)pushDownloadControllerClick:(UIButton*)sender
{
    [self.navigationController pushViewController:[[PXLDownLoadViewController alloc]init] animated:YES];
//    [self.navigationController pushViewController:[[JYModelViewController alloc]init] animated:YES];
    
}

#pragma mark ---------- Delegate ----------
-(void)managerCallAPIDidSuccess:(JY_BaseResponseModel *)response
{
//    JY_Log(@"********************* PXLHomeViewController  有缓存");
    JY_Log(@"%@", response.url);
//    PXLHomeModel * model = [PXLHomeModel yy_modelWithJSON:request.responseData[@"data"][@"items"][0]];
//    NSArray *array = [NSArray yy_modelArrayWithClass:PXLHomeModel.class json:request.responseData[@"data"][@"items"]];
//    JY_Log(@"%@,%@", array,model);
//    NSArray *array = [NSMutableArray yy_modelWithJSON:request.responseData[@"data"][@"items"][0]];
}
-(void)managerCallAPIDidFailed:(JY_BaseResponseModel *)response{
//    JY_Log(@"********************* PXLHomeViewController 无缓存");
    JY_Log(@"%@", response.url);
//    JY_Log(@"%@", request.message);
}

#pragma mark ---------- Lazy Load ----------
-(JY_HttpRequestManager *)httpRequestManager{
    if (!_httpRequestManager) {
        _httpRequestManager = [JY_HttpRequestManager loadDataHUDwithView:self.view];
        _httpRequestManager.delegate = self;
        _httpRequestManager.starCache = NO;
        _httpRequestManager.requestShowType = JYRequestShowType_RequestAndResponseViewShow;
    }
    return _httpRequestManager;
}


-(UIButton *)sendButton{
    if (!_sendButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"检验数据过期" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        _sendButton = button;
    }
    return _sendButton;
}
-(UIButton *)showButton{
    if (!_showButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"发起请求" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        _showButton = button;
    }
    return _showButton;
}
-(UIButton *)pushControllerButton{
    if (!_pushControllerButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"切换用户" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pushControllerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        _pushControllerButton = button;
    }
    return _pushControllerButton;
}
-(UIButton *)pushDownloadControllerButton{
    if (!_pushDownloadControllerButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"下载页面" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pushDownloadControllerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        _pushDownloadControllerButton = button;
    }
    return _pushDownloadControllerButton;
}

@end
