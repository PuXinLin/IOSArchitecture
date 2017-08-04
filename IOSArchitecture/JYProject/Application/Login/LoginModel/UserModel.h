//
//  UserModel.h
//  JYProject
//
//  Created by dayou on 2017/8/3.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, assign) NSInteger userId;     //id
@property (nonatomic, copy) NSString *userName;     //用户名
@property (nonatomic, copy) NSString *password;     //密码
@property (nonatomic, copy) NSString *userCacheKey; //用户缓存key 每个用户都不一样

+ (instancetype)sharedRequestInstance;

@end
