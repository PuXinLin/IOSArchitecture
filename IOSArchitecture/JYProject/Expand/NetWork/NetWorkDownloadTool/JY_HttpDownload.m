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
- (NSNumber*)starDownloadTaskWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                    savePath: (NSString *)savePath
{
    NSNumber *taskId = [self.downloadProxy requestWithURLString:URLString parameters:parameters filePath:savePath progressBlock:^(Jy_BaseDownloadModel *completeProgressResponse) {
        [self.delegate managerCallAPIDownloadProgressWithCompleteProgressResponse:completeProgressResponse];
    } finishedBlock:^(Jy_BaseDownloadModel *completeResponse) {
        [self.delegate managerCallAPIDownloadDidSuccess:completeResponse];
    }];
    [self.taskIdList addObject:taskId];
    return taskId;
}

#pragma mark 取消单个下载
- (void)cancleDownloadWithRequestId:(NSNumber*)requestId
{
    [self.taskIdList removeObject:requestId];
    [self.downloadProxy cancleDownloadWithTaskId:requestId];
}

#pragma mark 取消所有下载
- (void)cancleAllDownload
{
    for (NSNumber *taskIdItem in self.taskIdList) {
        [self cancleDownloadWithRequestId:taskIdItem];
    }
}

#pragma mark 删除下载文件
-(BOOL)removeFileWithFilePath:(NSString*)filePath
{
    return [self.downloadProxy removeFileWithFilePath:filePath];
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------
-(JY_HttpDownloadProxy *)downloadProxy{
    if (!_downloadProxy) {
        _downloadProxy = [JY_HttpDownloadProxy sharedRequestInstance];
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
