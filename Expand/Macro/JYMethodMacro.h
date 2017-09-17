//
//  JYMethodMacro.h
//  JYProject
//
//  Created by dayou on 2017/7/31.
//  Copyright © 2017年 dayou. All rights reserved.
//

#ifndef JYMethodMacro_h
#define JYMethodMacro_h


/**
 * 输出
 * 缺省号代表一个可以变化的参数表。使用保留名 __VA_ARGS__ 把参数传递给宏。
 */
#ifdef DEBUG
#define JY_Log(...) NSLog(@"方法:%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define JY_Log(...)

#endif

/**
 * 获取颜色
 * @param : (red green blue)(0 - 255)   alpha(0 - 1)
 */
#define JY_ColorRgba(r,g,b,a)\
[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/**
 * 获取颜色
 * @param : stringColor(例: "ffffff")   alpha(0 - 1)
 */
#define JY_ColorString(stringColor,a)\
[UIColor jy_getColorWithHexNumber:stringColor alpha:a]

/* ----------- 开发成员 全局方法 ----------------- */
/* 成员1 --> 成员名字 */
// code...

/* 成员2 --> 成员名字 */
// code...


#endif /* JYMethodMacro_h */
