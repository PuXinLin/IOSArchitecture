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

@interface PXLHomeViewController ()<JY_HttpRequestCallBackDelegate>
/* test API */
@property (nonatomic ,strong)JY_HttpRequest *httpRequestModel;

/* 发起请求按钮 */
@property (nonatomic ,strong)UIButton *sendButton;

/* 弹框按钮 */
@property (nonatomic ,strong)UIButton *showButton;

/* 下一页按钮 */
@property (nonatomic ,strong)UIButton *pushControllerButton;

@end

@implementation PXLHomeViewController

#pragma mark ---------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configurationController];
    [self loadRequestData];
    [self resizeCustomView];
}

#pragma mark ---------- Methods ----------
#pragma mark 配置Controller
-(void)configurationController{
    self.view.backgroundColor = UIColor.whiteColor;
}

#pragma mark 数据请求
-(void)loadRequestData{
    _httpRequestModel = [JY_HttpRequest loadDataHUDwithView:self.view];
    _httpRequestModel.delegate = self;
    _httpRequestModel.requestShowType = JYRequestShowType_RequestViewShow;
    [_httpRequestModel requestWithURLString:@"/app/postlist.doa" method:JYRequestMethod_POST parameters:@{@"postType":@"1",@"pagenum":@"1",@"eqMy":@"2"} imageListBlack:nil];
}

#pragma mark 页面初始化
-(void)resizeCustomView{
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(100);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(100);
        make.top.equalTo(self.view.mas_top).offset(200);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.pushControllerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(100);
        make.top.equalTo(self.view.mas_top).offset(300);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
}

#pragma mark ---------- Click Event ----------
-(void)sendClick:(UIButton*)sender{
    [JYProgressHUD showMessageJY:@"哈哈" onView:self.view progressType:JYProgress_Text];
    [self loadRequestData];
}
-(void)showClick:(UIButton*)sender{
    [JYProgressHUD showMessageJY:JY_RequestLoading onView:self.view progressType:JYProgress_RequestError];
}
-(void)pushControllerClick:(UIButton*)sender{
    
     JYModelViewController * ctr = [[JYModelViewController alloc]init];
     ctr.jystring = @"哈哈";
     [self.navigationController pushViewController:ctr animated:YES];
}

#pragma mark ---------- Delegate ----------
-(void)managerCallAPIDidSuccess:(JY_HttpRequest *)request{
//    PXLHomeModel * model = [PXLHomeModel yy_modelWithJSON:request.responseData[@"data"][@"items"][0]];
//    NSArray *array = [NSArray yy_modelArrayWithClass:PXLHomeModel.class json:request.responseData[@"data"][@"items"]];
//    JY_Log(@"%@,%@", array,model);
//    NSArray *array = [NSMutableArray yy_modelWithJSON:request.responseData[@"data"][@"items"][0]];
    
}
-(void)managerCallAPIDidFailed:(JY_HttpRequest *)request{
    JY_Log(@"%@", request.message);
}

#pragma mark ---------- Lazy Load ----------
-(UIButton *)sendButton{
    if (!_sendButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"按钮" forState:UIControlStateNormal];
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
        [button setTitle:@"弹框" forState:UIControlStateNormal];
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
        [button setTitle:@"下一页" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pushControllerClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        _pushControllerButton = button;
    }
    return _pushControllerButton;
}

@end
