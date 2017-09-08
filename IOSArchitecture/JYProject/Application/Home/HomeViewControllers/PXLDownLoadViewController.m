//
//  PXLDownLoadViewController.m
//  JYProject
//
//  Created by dayou on 2017/8/9.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "PXLDownLoadViewController.h"
#import "JY_HttpDownload.h"
#import "JY_HttpDownloadProxy.h"

static NSString * const url = @"http://120.25.226.186:32812/resources/videos/minion_02.mp4";

@interface PXLDownLoadViewController ()<JY_HttpDownloadDelegate>
/* 下载 */
@property (nonatomic ,strong)JY_HttpDownload *httpDownload;
/* 进度框 */
@property (nonatomic ,strong)MBProgressHUD * progressHUD ;
@end

@implementation PXLDownLoadViewController

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
    self.title = @"数据下载";
    self.view.backgroundColor = JY_APP_ViewBackgroundColor;
}

#pragma mark 数据请求
-(void)loadRequestData{
    NSString *filePath = [self getFilePtchWithFileName:@"/Film/minion_02.mp4"];
    NSString *firstTwoFilePath = [self getFilePtchWithFileName:@"/Film/minion_03.mp4"];
    [self.httpDownload removeFileWithFilePath:filePath];
    [self.httpDownload removeFileWithFilePath:firstTwoFilePath];
    [self.httpDownload starDownloadTaskWithURLString:url parameters:@{} savePath:filePath];
    [self.httpDownload starDownloadTaskWithURLString:url parameters:@{} savePath:firstTwoFilePath];
}

#pragma mark 页面初始化
-(void)resizeCustomView{
    [self.progressHUD show:YES];
}

#pragma mark 获取路径
-(NSString*)getFilePtchWithFileName:(NSString*)fileName
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [docPath stringByAppendingString:fileName];
}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------
#pragma mark JY_HttpDownloadDelegate
-(void)managerCallAPIDownloadDidSuccess:(Jy_BaseDownloadModel *)successResponse
{
    JY_Log(@"任务%ld下载完成", [successResponse.taskId integerValue]);
}
-(void)managerCallAPIDownloadDidFailed:(Jy_BaseDownloadModel *)failureResponse{
    
}
-(void)managerCallAPIDownloadProgressWithCompleteProgressResponse:(Jy_BaseDownloadModel *)completeProgressResponse
{
    if ([completeProgressResponse.taskId  isEqual: @(1)]) {
        CGFloat totalSize = completeProgressResponse.totalSize/1024/1024.0;
        CGFloat currentDownloadSize = completeProgressResponse.currentDownloadSize/1024/1024.0;
        _progressHUD.progress = currentDownloadSize/totalSize;
        _progressHUD.labelText = [NSString stringWithFormat:@"%.2f/%.2fM",currentDownloadSize,totalSize];
    }
}
#pragma mark ---------- Lazy Load ----------
-(JY_HttpDownload *)httpDownload{
    if (!_httpDownload) {
        _httpDownload = [[JY_HttpDownload alloc]init];
        _httpDownload.delegate = self;
    }
    return _httpDownload;
}
-(MBProgressHUD *)progressHUD{
    if (!_progressHUD) {
        _progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _progressHUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    }
    return _progressHUD;
}
@end
