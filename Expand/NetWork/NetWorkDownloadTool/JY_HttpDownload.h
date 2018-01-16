//
//  JY_HttpDownload.h
//  JYProject
//
//  Created by dayou on 2017/8/9.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jy_BaseDownloadModel.h"

@protocol JY_HttpDownloadDelegate <NSObject>
@required
/* 下载成功回调 */
- (void)managerCallAPIDownloadDidSuccess:(Jy_BaseDownloadModel*)successResponse;
/* 下载失败回调 */
- (void)managerCallAPIDownloadDidFailed:(Jy_BaseDownloadModel*)failureResponse;
@optional
/* 下载文件进度 */
- (void)managerCallAPIDownloadProgressWithCompleteProgressResponse:(Jy_BaseDownloadModel*)completeProgressResponse;
@end

/*********************** JY_HttpDownload ***********************/

@interface JY_HttpDownload : NSObject

@property (nonatomic ,weak)id<JY_HttpDownloadDelegate> delegate;

/**
 * 数据下载
 *
 * @param  URLString      下载地址
 * @param  parameters     请求参数集合
 * @param  savePath       保存路径 (只要路径一致 支持断点下载)
 *
 * @return 下载任务id（可用于取消下载）
 */
- (NSNumber*)starDownloadTaskWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                    savePath: (NSString *)savePath;
/**
 * 取消单个下载
 */
- (void)cancleDownloadWithRequestId:(NSNumber*)requestId;
/**
 * 取消所有下载
 */
- (void)cancleAllDownload;

/**
 * 删除下载文件
 *
 *@ param filePath      文件路径
 */
-(BOOL)removeFileWithFilePath:(NSString*)filePath;

@end
