//
//  PXLDataListViewController.m
//  JYProject
//
//  Created by dayou on 2017/9/5.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "PXLDataListViewController.h"

@interface PXLDataListViewController ()<JY_HttpRequestManagerCallBackDelegate,UITableViewDelegate,UITableViewDataSource>

/* API Manage */
@property (nonatomic ,strong)JY_HttpRequestManager *httpRequestManager;

/* 数据列表 */
@property (nonatomic ,strong)UITableView *dataTableView;

/* 数据列表 */
@property (nonatomic ,strong)NSArray *dataList;

@end

@implementation PXLDataListViewController
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
-(void)configurationController{
    self.title = @"数据列表";
    self.view.backgroundColor = JY_APP_ViewBackgroundColor;
}

#pragma mark 数据请求
-(void)loadRequestData{}

#pragma mark 页面初始化
-(void)resizeCustomView{}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark JY_HttpRequestManagerCallBackDelegate
-(void)managerCallAPIDidSuccess:(JY_BaseResponseModel *)response{
    JY_Log(@"%@", response.url);
}
-(void)managerCallAPIDidFailed:(JY_BaseResponseModel *)response{
    JY_Log(@"%@", response.url);
}

#pragma mark TableView Delegate And DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    cell.textLabel.text = _dataList[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark ---------- Lazy Load ----------
-(JY_HttpRequestManager *)httpRequestManager{
    if (!_httpRequestManager) {
        _httpRequestManager = [JY_HttpRequestManager loadDataHUDwithView:self.view];
        _httpRequestManager.delegate = self;
        _httpRequestManager.starCache = NO;
        _httpRequestManager.notResendResquest = NO;
        _httpRequestManager.netWorkChangeRestoreRequest = YES;
        _httpRequestManager.requestShowType = JYRequestShowType_RequestAndResponseViewShow;
    }
    return _httpRequestManager;
}

-(UITableView *)homeTableView{
    if (!_dataTableView) {
        _dataTableView = [[UITableView alloc]init];
        _dataTableView.delegate = self;
        _dataTableView.dataSource = self;
        [self.view addSubview:_dataTableView];
    }
    return _dataTableView;
}

@end
