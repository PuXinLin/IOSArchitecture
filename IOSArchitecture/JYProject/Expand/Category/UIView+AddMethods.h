//
//  UIView+AddMethods.h
//  JYProject
//
//  Created by dayou on 2017/7/26.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddMethods)

/**
 * 添加圆角
 */
-(void)jy_addCornerRadius:(CGFloat)radius;

/**
 * 切除view指定位置的圆角
 *
 * @param corner 选定的位置, size   圆角的大小
 *
 */
- (void)jy_removalOfSpecifiedLocationRoundCorners:(UIRectCorner)corner withSize:(CGSize)size;

/**
 *  设置UIView的边框、颜色、圆角
 *
 * @param borderWidth   边框宽, borderColor   边框颜色
 *
 */
-(void)jy_setBorderWith:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end
