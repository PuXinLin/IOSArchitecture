//
//  YMMethodMacro.h
//  JYProject
//
//  Created by dayou on 2017/7/25.
//  Copyright © 2017年 dayou. All rights reserved.
//

#ifndef YMMethodMacro_h
#define YMMethodMacro_h

/**
 * 输出
 * 缺省号代表一个可以变化的参数表。使用保留名 __VA_ARGS__ 把参数传递给宏。
 */
#ifdef DEBUG
#define JYLog(...) NSLog(@"方法:%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define JYLog(...)

#endif

/**
 * 获取颜色
 * @param : (red green blue)(0 - 255)   alpha(0 - 1)
 */
#define JY_ColorRgba(red,green,blue,alpha)\
    [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha]

/**
 * 获取颜色
 * @param : stringColor(例: "ffffff")   alpha(0 - 1)
 */
#define JY_ColorString(stringColor,alpha)\
    [UIColor jy_getColorWithHexNumber:stringColor alpha:alpha]


/**
 * 检验 Response 数据是否正确
 * @param responseObject 请求返回数据
 */
#define BoolResponse(responseObject) [responseObject[@"status"] integerValue] == 1


/* ----------- 开发成员 全局方法 ----------------- */
/* 成员1 --> 成员名字 */
// code...

/* 成员2 --> 成员名字 */
// code...

#endif /* YMMethodMacro_h */
