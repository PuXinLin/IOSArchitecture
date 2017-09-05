//
//  PXLHomeViewController.m
//  JYProject
//
//  Created by dayou on 2017/7/25.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "PXLHomeViewController.h"
#import "PXLHomeModel.h"
#import "PXLDownLoadViewController.h"
#import "PXLDataListViewController.h"

@interface PXLHomeViewController ()<JY_HttpRequestManagerCallBackDelegate,UITableViewDelegate,UITableViewDataSource>
/* API Manage */
@property (nonatomic ,strong)JY_HttpRequestManager *httpRequestManager;

/* 数据列表 */
@property (nonatomic ,strong)UITableView *homeTableView;

/* 数据列表 */
@property (nonatomic ,strong)NSArray *homeList;

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
-(void)configurationController
{
    self.view.backgroundColor = UIColor.whiteColor;
    _homeList = @[@"切换用户",@"发起请求",@"数据列表Controller",@"数据下载Controller"];
    
    /* 模拟用户登录 */
    UserModel * user = JY_User;
    user.userCacheKey = @"UserOne";
}

#pragma mark 页面初始化
-(void)resizeCustomView
{
    /* 列表 */
    [self.homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, JY_IPHONE_TabBarHeight, 0));
    }];
}
#pragma mark 用户切换
-(void)userChange{
    if ([JY_User.userCacheKey isEqualToString:@"UserTwo"]) {
        JY_User.userCacheKey = @"UserOne";
    }
    else{
        JY_User.userCacheKey = @"UserTwo";
    }
    JY_Log(@"用户切换成功!");
}
#pragma mark 数据请求
-(void)loadRequestData{
    [self.httpRequestManager requestWithURLString:JY_Url_Home_List method:JYRequestMethod_POST parameters:@{@"postType":@"1",@"pagenum":@"1",@"eqMy":@"2"} imageListBlack:nil];
}
#pragma mark 跳转下载页面
-(void)pushDownloadController{
    [self.navigationController pushViewController:[[PXLDownLoadViewController alloc]init] animated:YES];
}

#pragma mark 跳转数据列表页面
-(void)pushDataListController{
    [self.navigationController pushViewController:[[PXLDataListViewController alloc]init] animated:YES];
}

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
    return _homeList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    cell.textLabel.text = _homeList[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self userChange];
            break;
        case 1:
            [self loadRequestData];
            break;
        case 2:
            [self pushDataListController];
            break;
        case 3:
            [self pushDownloadController];
            break;
        default:
            break;
    }
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
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc]init];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        [self.view addSubview:_homeTableView];
    }
    return _homeTableView;
}

@end
