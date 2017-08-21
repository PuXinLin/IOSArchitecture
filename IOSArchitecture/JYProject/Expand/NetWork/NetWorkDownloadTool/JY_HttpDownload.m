//
//  JY_HttpDownload.m
//  JYProject
//
//  Created by dayou on 2017/8/9.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpDownload.h"
#import "JY_HttpDownloadProxy.h"

@interface JY_HttpDownload()

@property (nonatomic ,strong)JY_HttpDownloadProxy *downloadProxy;
/* 分派的taskId */
@property (nonatomic ,strong, readwrite)NSMutableArray *taskIdList;
@end

@implementation JY_HttpDownload

#pragma mark ---------- Life Cycle ----------

#pragma mark ---------- Private Methods ----------
#pragma mark 数据下载
- (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                    savePath: (NSString *)savePath
{
    NSUInteger taskId = [self.downloadProxy requestWithURLString:URLString parameters:parameters filePath:savePath progressBlock:^(Jy_BaseDownloadModel *completeProgressResponse) {
        [self.delegate managerCallAPIDownloadProgressWithCompleteProgressResponse:completeProgressResponse];
    } finishedBlock:^(Jy_BaseDownloadModel *completeResponse) {
        [self.delegate managerCallAPIDownloadDidSuccess:completeResponse];
    }];
    [self.taskIdList addObject:@(taskId)];
}

#pragma mark 开始下载
-(void)starDownloadTask
{
    
}

#pragma mark 断点下载
-(void)starDownloadTasks
{
    
}

#pragma mark 取消单个下载
- (void)cancleDownloadWithRequestId:(NSNumber*)requestId
{
    
}

#pragma mark 取消所有下载
- (void)cancleAllDownloadWithArrayList:(NSArray*)arrayList
{
    
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------
-(JY_HttpDownloadProxy *)downloadProxy{
    if (!_downloadProxy) {
        _downloadProxy = [[JY_HttpDownloadProxy alloc]init];
    }
    return _downloadProxy;
}
-(NSMutableArray *)taskIdList{
    if (!_taskIdList) {
        _taskIdList = [[NSMutableArray alloc]init];
    }
    return _taskIdList;
}

@end
