//
//  JY_BaseResponseModel.h
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JY_BaseResponseModel : NSObject

/* 返回数据提示 */
@property (nonatomic ,strong)NSString *message;

/* 服务器返回的状态码 */
@property (nonatomic ,assign)NSInteger status;

@end
