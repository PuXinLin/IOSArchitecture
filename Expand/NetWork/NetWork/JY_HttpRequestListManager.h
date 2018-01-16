//
//  JY_HttpRequestListManager.h
//  JYProject
//
//  Created by dayou on 2017/9/5.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpRequestManager.h"

@interface JY_HttpRequestListManager : NSObject
/* 当前页码 */
@property (nonatomic ,assign)NSUInteger currentPage;
/* 数据源 */
@property (nonatomic ,strong, readonly)NSMutableArray *dataArray;
/**
 * 管理配置 (执行数据请求前 先执行管理配置)
 *
 * @param pageString            参数集合里分页字段名
 * @param listView              (UITableView or UICollectionView)
 * @param requestManager        JY_HttpRequestManager
 * @param dataClass             数据模型
 */
-(instancetype)initConfigurationListManagerWithPageString:(NSString*)pageString
                                                 listView:(id)listView
                                           requestManager:(JY_HttpRequestManager*)requestManager
                                                dataClass:(Class)dataClass;

/* 请求第一页数据 currentPage = 1 数据清空 */
-(void)reload;

/* 请求下一页数据 currentPage + 1 */
-(void)loadNextPageData;

@end
