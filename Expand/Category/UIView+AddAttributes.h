//
//  UIView+AddAttributes.h
//  JYProject
//
//  Created by dayou on 2017/7/26.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddAttributes)

/**
 * 快捷方式为 frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * 快捷方式为 frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * 快捷方式为 frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * 快捷方式为 frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat mybottom;

/**
 * 快捷方式为 frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * 快捷方式为 frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * 快捷方式为 center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * 快捷方式为 center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * 返回屏幕中的x坐标
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * 返回屏幕中的y坐标
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * 返回屏幕上的x坐标,考虑滚动视图
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * 返回屏幕上的y坐标,考虑滚动视图
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * 在屏幕上返回视图框架,考虑滚动视图。
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * 快捷方式为frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * 快捷方式为 frame.size
 */
@property (nonatomic) CGSize size;


@end
