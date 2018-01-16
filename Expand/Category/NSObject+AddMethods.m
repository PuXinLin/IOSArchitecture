//
//  NSObject+AddMethods.m
//  JYProject
//
//  Created by dayou on 2017/7/30.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "NSObject+AddMethods.h"

@implementation NSObject (AddMethods)

NSString* jy_safeString(id obj) {
    return [obj isKindOfClass:[NSObject class]]?[NSString stringWithFormat:@"%@",obj]:@"";
}

NSNumber* jy_safeNumber(id obj) {
    NSNumber *result=[NSNumber numberWithInt:0];
    if([obj isKindOfClass:[NSNumber class]])
    {
        result = obj;
        
    } else if ([obj isKindOfClass:[NSString class]]) {
        result = @(((NSString *)obj).doubleValue);
    }
    return result;
}

@end
