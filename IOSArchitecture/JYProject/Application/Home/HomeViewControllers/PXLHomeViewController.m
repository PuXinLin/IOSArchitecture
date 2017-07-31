//
//  PXLHomeViewController.m
//  JYProject
//
//  Created by dayou on 2017/7/25.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "PXLHomeViewController.h"

@interface PXLHomeViewController ()<JY_HttpRequestCallBackDelegate>
/* test API */
@property (nonatomic ,strong)JY_HttpRequest *httpRequestModel;

/* 发起请求按钮 */
@property (nonatomic ,strong)UIButton *sendButton;

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
-(void)configurationController{
    self.view.backgroundColor = UIColor.whiteColor;
}

#pragma mark 数据请求
-(void)loadRequestData{
    _httpRequestModel = [JY_HttpRequest loadDataHUDwithView:self.view];
    _httpRequestModel.delegate = self;
    [_httpRequestModel requestWithURLString:@"/app/postlist.do" method:JYRequestMethod_POST parameters:@{@"postType":@"1",@"pagenum":@"1",@"eqMy":@"2"} imageListBlack:nil];
}

#pragma mark 页面初始化
-(void)resizeCustomView{
    [self.view addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------
-(void)managerCallAPIDidSuccess:(JY_HttpRequest *)request{
    JY_Log(@"%@", request.message);
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
        [button addTarget:self action:@selector(loadRequestData) forControlEvents:UIControlEventTouchUpInside];
        _sendButton = button;
    }
    return _sendButton;
}
@end
