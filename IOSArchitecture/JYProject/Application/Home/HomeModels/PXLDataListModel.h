//
//  PXLDataListModel.h
//  JYProject
//
//  Created by dayou on 2017/9/7.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXLDataListModel : NSObject

/* 用户ID */
@property (nonatomic ,strong)NSString *userid;

/* 用户名称 */
@property (nonatomic ,strong)NSString *nickName;

/* 用户头像 */
@property (nonatomic ,strong)NSString *imageUrl;

/* 用户孕周期 */
@property (nonatomic ,strong)NSString *imp;

/* 用户信息 */
@property (nonatomic ,assign)NSInteger shenFeng;

/* 登记时间 */
@property (nonatomic ,strong)NSString *enrollTime;

@end
