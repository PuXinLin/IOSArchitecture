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

@interface JY_HttpDownloadProxy : NSObject

+ (instancetype)sharedRequestInstance;
/**
 * 数据请求
 *
 * @param URLString      数据接口
 * @param method         请求方式
 * @param parameters     请求参数集合
 * @param filePath       保存文件路径
 * @param progressBlock  下载文件进度
 * @param finishedBlock  请求完成回调
 * @param failureBlock   请求完成回调
 *
 * @return 请求分派的id
 */
- (NSUInteger)requestWithURLString:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                        filePath:(NSString*)filePath
                    progressBlock:(JYCallbackAPIDownloadCallback)progressBlock
                    finishedBlock:(JYCallbackAPIDownloadCallback)finishedBlock;
@end


/************************************** JY_DownloadModel **************************************/

@interface JY_DownloadModel : NSObject
@property (nonatomic ,weak)NSURLSessionDataTask *SaveTask;
@property (nonatomic ,strong)Jy_BaseDownloadModel *baseDownloadModel;
@property (nonatomic ,strong)NSOutputStream *outputStream;
@end
