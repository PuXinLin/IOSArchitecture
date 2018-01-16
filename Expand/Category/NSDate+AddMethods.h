//
//  NSDate+AddMethods.h
//  JYProject
//
//  Created by dayou on 2017/7/26.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AddMethods)

/**
 * 获得当前的是几号
 */
+ (NSInteger)jy_day:(NSDate *)date;

/**
 * 获得当前的年份
 */
+ (NSInteger)jy_year:(NSDate *)date;

/**
 * 获得当前的月份
 */
+ (NSInteger)jy_month:(NSDate *)date;

/**
 * 获得当前星期几
 */
+ (NSInteger)jy_weekDay:(NSDate *)date;

/**
 * 获得当前月份有几天
 */
+ (NSInteger)jy_totaldaysInMonth:(NSDate *)date;

/**
 * 获得前个月份有几天
 */
+ (NSDate *)jy_lastMonth:(NSDate *)date;

/**
 * 获得下个月份有几天
 */
+ (NSDate *)jy_nextMonth:(NSDate *)date;

/**
 * 获得两个日期之间的天数
 */
+ (NSInteger)jy_calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate;

/**
 * 获得多少天之后的日期
 */
+ (NSDate *)jy_calcDaysFromBegin:(NSDate *)date intervalDay:(NSInteger)day;

/**
 * 日期转string
 */
+ (NSString *)jy_dateConversionString:(NSDate *)date;

/**
 * string转date
 */
+ (NSDate *)jy_stringConversionDate:(NSString *)string;

@end
