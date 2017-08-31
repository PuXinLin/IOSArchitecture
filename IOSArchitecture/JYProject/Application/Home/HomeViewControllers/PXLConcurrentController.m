//
//  PXLConcurrentController.m
//  JYProject
//
//  Created by dayou on 2017/8/30.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "PXLConcurrentController.h"

@interface PXLConcurrentController ()

/* 发起请求按钮 */
@property (nonatomic ,strong)UIButton *sendButton;
/* 分配管理id */
@property (nonatomic ,strong)NSNumber *dispatchId;
/* 队列 */
@property (nonatomic ,strong)NSOperationQueue *operationQueue;
@end

@implementation PXLConcurrentController

#pragma mark ---------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configurationController];
    [self loadRequestData];
    [self resizeCustomView];
}

#pragma mark ---------- Private Methods ----------
#pragma mark 配置Controller
-(void)configurationController
{
    self.view.backgroundColor = UIColor.whiteColor;
}

#pragma mark 数据请求
-(void)loadRequestData{}

#pragma mark 页面初始化
-(void)resizeCustomView
{
    /* 点击按钮 */
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(100);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];
}
-(void)run
{
    
}
#pragma mark 获取分配ID
-(NSNumber*)getdispatchId
{
    if (_dispatchId == nil) {
        _dispatchId = @(1);
    } else {
        if ([_dispatchId integerValue] == NSIntegerMax) {
            _dispatchId = @(1);
        } else {
            _dispatchId = @([_dispatchId integerValue] + 1);
        }
    }
    return _dispatchId;
}
#pragma mark ---------- Click Event ----------
-(void)sendClick:(UIButton*)sender
{
    for (int i=0; i<50; i++) {
        self.dispatchId = [self getdispatchId];
        NSUInteger dispatchId = [self.dispatchId integerValue];
        [self.operationQueue addOperationWithBlock:^{
            JY_Log(@"%lu", (unsigned long)dispatchId);
        }];
    }
}
#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

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
-(NSOperationQueue *)operationQueue{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc]init];
    }
    return _operationQueue;
}
@end
