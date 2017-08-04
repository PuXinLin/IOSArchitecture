//
//  JYMD5.h
//  JYProject
//
//  Created by dayou on 2017/8/4.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYMD5 : NSObject
/**
 * 字符串MD5加密
 *
 * @param string 字符串加密
 * @param return 加密字符串
 */
+(NSString *)md5WithString:(NSString *)string;

@end
