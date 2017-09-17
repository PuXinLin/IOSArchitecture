//
//  Jy_BaseDownloadModel.h
//  JYProject
//
//  Created by dayou on 2017/8/9.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Jy_BaseDownloadModel : NSObject
/* 任务id */
@property (nonatomic ,strong)NSNumber *taskId;
/* 保存路径 */
@property (nonatomic ,strong)NSString *savePath;
/* 当前下载 */
@property (nonatomic ,assign)NSInteger currentDownloadSize;
/* 总下载 */
@property (nonatomic ,assign)NSInteger totalSize;

@end
