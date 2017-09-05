//
//  JY_HttpDownloadProxy.h
//  JYProject
//
//  Created by dayou on 2017/8/9.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jy_BaseDownloadModel.h"
/* 回调 */
typedef void(^JYCallbackAPIDownloadCallback)(Jy_BaseDownloadModel *completeDownload);

/************************************** JY_DownloadModel **************************************/

@interface JY_DownloadModel : NSObject
@property (nonatomic ,weak)NSURLSessionDataTask *SaveTask;
@property (nonatomic ,strong)Jy_BaseDownloadModel *baseDownloadModel;
@property (nonatomic ,strong)NSOutputStream *outputStream;
@end

/************************************** JY_HttpDownloadProxy **************************************/
@interface JY_HttpDownloadProxy : NSObject

+ (instancetype)sharedRequestInstance;
/**
 * 数据请求
 *
 * @param URLString      数据接口
 * @param parameters     请求参数集合
 * @param filePath       保存文件路径
 * @param progressBlock  下载文件进度
 * @param finishedBlock  下载完成回调
 *
 * @return 请求分派的id
 */
- (NSNumber*)requestWithURLString:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                        filePath:(NSString*)filePath
                    progressBlock:(JYCallbackAPIDownloadCallback)progressBlock
                    finishedBlock:(JYCallbackAPIDownloadCallback)finishedBlock;
/**
 * 取消单个下载
 */
- (void)cancleDownloadWithTaskId:(NSNumber*)taskId;

/**
 * 删除下载文件
 *
 *@ param filePath      文件路径
 */
-(BOOL)removeFileWithFilePath:(NSString*)filePath;

@end

