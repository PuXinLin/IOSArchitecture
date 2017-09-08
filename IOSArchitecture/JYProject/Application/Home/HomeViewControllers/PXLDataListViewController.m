//
//  PXLDataListViewController.m
//  JYProject
//
//  Created by dayou on 2017/9/5.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "PXLDataListViewController.h"
#import "PXLHomeModel.h"
@interface PXLDataListViewController ()<UITableViewDelegate,UITableViewDataSource>

/* API Manage */
@property (nonatomic ,strong)JY_HttpRequestListManager *httpRequestListManager;

/* 数据列表 */
@property (nonatomic ,strong)UITableView *dataListTableView;

@end

@implementation PXLDataListViewController
#pragma mark ---------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configurationController];
    [self resizeCustomView];
}

#pragma mark ---------- Private Methods ----------
#pragma mark 配置Controller
-(void)configurationController
{
    self.title = @"数据列表";
    self.view.backgroundColor = JY_APP_ViewBackgroundColor;
    
//    [self.httpRequestListManager reload];
}

#pragma mark 页面初始化
-(void)resizeCustomView
{
    /* 列表 */
    [self.dataListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark 获取 HttpRequestManager
-(JY_HttpRequestManager*)getHttpRequestManager
{
    JY_HttpRequestManager *requestManager = [JY_HttpRequestManager loadDataRequestManagerWithView:self.view];
    requestManager.openCache = NO;
    requestManager.notResendResquest = NO;
    requestManager.netWorkChangeRestoreRequest = YES;
    requestManager.requestShowType = JYRequestShowType_RequestAndResponseViewShow;
    [requestManager requestWithURLString:JY_Url_Home_List method:JYRequestMethod_POST parameters:@{@"postType":@"1",@"pagenum":@"1",@"eqMy":@"2"} imageListBlack:nil];
    return requestManager;
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------
#pragma mark TableView Delegate And DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.httpRequestListManager.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark ---------- Lazy Load ----------
-(JY_HttpRequestListManager *)httpRequestListManager{
    if (!_httpRequestListManager) {
        JY_HttpRequestManager *requestManager = [self getHttpRequestManager];
        _httpRequestListManager = [[JY_HttpRequestListManager alloc]initConfigurationListManagerWithPageString:@"pagenum" listView:self.dataListTableView requestManager:requestManager dataClass:PXLHomeModel.class];
    }
    return _httpRequestListManager;
}

-(UITableView *)dataListTableView{
    if (!_dataListTableView) {
        _dataListTableView = [[UITableView alloc]init];
        _dataListTableView.delegate = self;
        _dataListTableView.dataSource = self;
        _dataListTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self.httpRequestListManager refreshingAction:@selector(reload)];
        _dataListTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self.httpRequestListManager refreshingAction:@selector(loadNextPageData)];
        [_dataListTableView.mj_header beginRefreshing];
        [self.view addSubview:_dataListTableView];
    }
    return _dataListTableView;
}

@end
