//
//  JY_HttpDownloadProxy.m
//  JYProject
//
//  Created by dayou on 2017/8/9.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JY_HttpDownloadProxy.h"

@interface JY_HttpDownloadProxy()
/* 负责管理所有的网络请求 */
@property (nonatomic ,strong)AFURLSessionManager *sessionManager;
/* 负责记录所有派的请求id */
@property (nonatomic ,strong)NSMutableDictionary *dispatchTable;
/* 文件管理 */
@property (nonatomic ,strong)NSFileManager *fileManage;
@end

@implementation JY_HttpDownloadProxy

#pragma mark ---------- Public Methods ----------
+ (instancetype)sharedRequestInstance {
    static JY_HttpDownloadProxy *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[JY_HttpDownloadProxy alloc]init];
    });
    return __sharedInstance;
}

#pragma mark 取消单个数据请求
- (void)cancleDownloadWithTaskId:(NSNumber*)taskId
{
    NSURLSessionDataTask * task = self.dispatchTable[taskId];
    [task cancel];
    [self.dispatchTable removeObjectForKey:taskId];
}

#pragma mark 删除下载文件
-(BOOL)removeFileWithFilePath:(NSString*)filePath
{
    if ([self.fileManage fileExistsAtPath:filePath]) {
        return [self.fileManage removeItemAtPath:filePath error:nil];
    }
    else{
        JY_Log(@"没有%@文件",filePath);
    }
    return NO;
}
#pragma mark ---------- Private Methods ----------
#pragma mark 发起请求
- (NSNumber*)requestWithURLString: (NSString *)URLString
                       parameters: (NSDictionary *)parameters
                         filePath:(NSString*)filePath
                    progressBlock:(JYCallbackAPIDownloadCallback)progressBlock
                    finishedBlock: (JYCallbackAPIDownloadCallback)finishedBlock
{
    /* 配置请求 断点下载 */
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSInteger range = [self getLastDownloadSizeWithFilePath:filePath];
    NSString *rangeString = [NSString stringWithFormat:@"bytes=%zd-",range];
    [request setValue:rangeString forHTTPHeaderField:@"Range"];
    __weak JY_HttpDownloadProxy * weakSelf = self;
    NSURLSessionDataTask * saveTask = [self.sessionManager dataTaskWithRequest:request completionHandler:nil];
    
    /************************************** 接收服务器响应 **************************************/
    [self.sessionManager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        JY_DownloadModel *model = weakSelf.dispatchTable[@(dataTask.taskIdentifier)];
        [model.outputStream open];
        model.baseDownloadModel.totalSize = response.expectedContentLength;
        return NSURLSessionResponseAllow;
    }];
    
    /************************************** 接收数据,分批次进来 **************************************/
    [self.sessionManager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        JY_DownloadModel *model = weakSelf.dispatchTable[@(dataTask.taskIdentifier)];
        [model.outputStream write:data.bytes maxLength:data.length];
        model.baseDownloadModel.currentDownloadSize +=data.length;
        progressBlock(model.baseDownloadModel);
    }];
    
    /************************************** 下载完成 **************************************/
    [self.sessionManager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
        JY_DownloadModel *model = weakSelf.dispatchTable[@(task.taskIdentifier)];
        if (!error) {
            finishedBlock(model.baseDownloadModel);
        }
        [model.outputStream close];
        [weakSelf.dispatchTable removeObjectForKey:@(task.taskIdentifier)];
    }];
    
    self.dispatchTable[@(saveTask.taskIdentifier)] = [self setDownloadTaskWithSessionTask:saveTask filePath:filePath];
    [saveTask resume];
    return @(saveTask.taskIdentifier);
}

#pragma mark 多任务下载配置
-(JY_DownloadModel*)setDownloadTaskWithSessionTask:(NSURLSessionDataTask*)dataTask filePath:(NSString*)filePath
{
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    
    Jy_BaseDownloadModel *downloadModel = [[Jy_BaseDownloadModel alloc]init];
    downloadModel.taskId = @(dataTask.taskIdentifier);
    downloadModel.savePath = filePath;
    
    JY_DownloadModel * model = [[JY_DownloadModel alloc]init];
    model.SaveTask = dataTask;
    model.outputStream = outputStream;
    model.baseDownloadModel = downloadModel;
    return model;
}

#pragma mark 获取开始下载位置
-(NSInteger)getLastDownloadSizeWithFilePath:(NSString*)filePath
{
    NSDictionary *dic = [self.fileManage attributesOfItemAtPath:filePath error:nil];
    if ([dic[@"NSFileSize"] integerValue]<=0 ||[dic[@"NSFileSize"] integerValue] == NSIntegerMax) {
        [self generateFilePath:filePath];
        return 0;
    }
    return [dic[@"NSFileSize"] integerValue];
}

#pragma mark 生成文件路径
-(void)generateFilePath:(NSString*)filePath
{
    if (![self.fileManage isExecutableFileAtPath:filePath]) {
        NSString *fileName = [[filePath componentsSeparatedByString:@"/"] lastObject];
        NSString *filePath2 = [filePath stringByReplacingOccurrencesOfString:fileName withString:@""];
        [self.fileManage createDirectoryAtPath:filePath2 withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

-(AFURLSessionManager *)sessionManager{
    if (!_sessionManager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    }
    return _sessionManager;
}
-(NSMutableDictionary *)dispatchTable{
    if (!_dispatchTable) {
        _dispatchTable = [[NSMutableDictionary alloc]init];
    }
    return _dispatchTable;
}
-(NSFileManager*)fileManage{
    if (!_fileManage) {
        _fileManage = [NSFileManager defaultManager];
    }
    return _fileManage;
}
@end

@implementation JY_DownloadModel
@end
