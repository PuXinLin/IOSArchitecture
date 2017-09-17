//
//  UIColor+AddMethods.h
//  JYProject
//
//  Created by dayou on 2017/7/26.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AddMethods)

/**
 * 字符转颜色
 *
 * @param hexColor 颜色字符(例: ffffff), alpha 透明度
 * @return UIColor
 */
+(id)jy_getColorWithHexNumber:(NSString *)hexColor alpha:(CGFloat) alpha;

@end
