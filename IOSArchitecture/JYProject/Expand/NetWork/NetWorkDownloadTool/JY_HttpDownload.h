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
 * @param method         请求方式 (通过JYRequestMethodType枚举判断请求类型)
 * @param parameters     请求参数集合
 * @param savePath       保存路径
 */
- (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                    savePath: (NSString *)savePath;
/**
 * 开始下载
 */
-(void)starDownloadTask;
/**
 * 断点下载
 */
-(void)starDownloadTasks;
/**
 * 取消单个下载
 */
- (void)cancleDownloadWithRequestId:(NSNumber*)requestId;

/**
 * 取消所有下载
 */
- (void)cancleAllDownloadWithArrayList:(NSArray*)arrayList;


@end
