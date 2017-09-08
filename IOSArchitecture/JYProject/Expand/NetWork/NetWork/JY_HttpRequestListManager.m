//
//  JY_HttpRequestListManager.m
//  JYProject
//
//  Created by dayou on 2017/9/5.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpRequestListManager.h"

static NSInteger const pageMaxCount = 10; // 每页最多展示数据

@interface JY_HttpRequestListManager()<JY_HttpRequestManagerCallBackDelegate>

@property (nonatomic ,strong, readwrite)NSMutableArray *dataArray;
/* 页码字段 */
@property (nonatomic ,strong)NSString *pageString;
/* 数据模型 */
@property (nonatomic ,strong, readwrite)Class dataClass;
/* 只缓存第一页 */
@property (nonatomic ,assign)BOOL onlyCacheFirstPage;
/* JY_HttpRequestManager */
@property (nonatomic ,strong)JY_HttpRequestManager *requestManager;
/* tableView */
@property (nonatomic ,weak)UITableView *tableView;
/* collectionView */
@property (nonatomic ,weak)UICollectionView *collectionView;

@end

@implementation JY_HttpRequestListManager

#pragma mark ---------- Life Cycle ----------
#pragma mark 管理配置 (执行数据请求前 先执行管理配置)
-(instancetype)initConfigurationListManagerWithPageString:(NSString*)pageString
                                                 listView:(id)listView
                                           requestManager:(JY_HttpRequestManager*)requestManager
                                                dataClass:(Class)dataClass
{
    self = [super init];
    if (self) {
        self.pageString = pageString;
        if ([listView isKindOfClass:UITableView.class]) {
            self.tableView = listView;
        }
        if ([listView isKindOfClass:UICollectionView.class]) {
            self.collectionView = listView;
        }
        self.requestManager = requestManager;
        self.onlyCacheFirstPage = requestManager.openCache;
        self.dataClass = dataClass;
        requestManager.delegate = self;
    }
    return self;
}
#pragma mark ---------- Private Methods ----------

#pragma mark 请求第一页数据 currentPage = 1 数据清空
-(void)reload
{
    self.currentPage = 1;
    if (self.onlyCacheFirstPage) self.requestManager.openCache = YES;
    self.requestManager.apiDetails.parameters = [self getParameters];
    [self.requestManager startRequest];
}
#pragma mark 请求下一页数据 currentPage + 1
-(void)loadNextPageData
{
    self.currentPage ++;
    self.requestManager.apiDetails.parameters = [self getParameters];
    if (self.onlyCacheFirstPage) self.requestManager.openCache = NO;
    [self.requestManager startRequest];
}
#pragma mark 检查是否还有数据
-(BOOL)checkedMoreData{
    BOOL moreData;
    if (self.dataArray.count%pageMaxCount) {
        moreData = NO;
    }
    else{
        moreData = YES;
    }
    return moreData;
}
#pragma mark 关闭刷新动画
-(void)endRefreshing{
    if (self.tableView) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }
    if (self.collectionView) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }
}
#pragma mark 刷新UI
-(void)refreshingUI{
    if (self.tableView) {
        [self.tableView reloadData];
    }
    if (self.collectionView) {
        [self.collectionView reloadData];
    }
}
#pragma mark 获取参数
-(NSMutableDictionary*)getParameters{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:self.requestManager.apiDetails.parameters];
    parameters[_pageString] = [NSString stringWithFormat:@"%ld",self.currentPage];
    return parameters;
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------
#pragma mark JY_HttpRequestManagerCallBackDelegate
-(void)managerCallAPIDidSuccess:(JY_BaseResponseModel *)response
{
    NSArray *dataArray = [NSArray yy_modelArrayWithClass:self.dataClass json:response.responseData[@"data"][@"items"]];
    /* 防止数据混乱 */
    if ([response.parameters[self.pageString] integerValue] == 1) {
        [self.dataArray removeAllObjects];
    }
    if (dataArray.count) {
        [self.dataArray addObjectsFromArray:dataArray];
        [self refreshingUI];
    }
    [self endRefreshing];
}

-(void)managerCallAPIDidFailed:(JY_BaseResponseModel *)response{
    [self endRefreshing];
}

#pragma mark ---------- Lazy Load ----------
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
