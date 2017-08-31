//
//  JYProgressHUD.h
//  JYProject
//
//  Created by dayou on 2017/8/1.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface JYProgressHUD : NSObject
/* 显示提示框状态 */
typedef NS_ENUM(NSInteger, JYProgressType) {
    JYProgress_Text,           //只显示文字
    JYProgress_Loading,        //只显示加载框
    JYProgress_TextAndLoading, //显示文字和加载框
    JYProgress_RequestError,   //显示请求失败的页面
};
/**************************** 这里是页面弹框 切换页面后不会显示 ****************************/
/**
 *  提示框  (Controller.view上的提示)
 *
 * @param aString      文字内容
 * @param onView         弹出框的父View
 * @param progressType 提示框状态
 */
+(MBProgressHUD*)showMessageJY:(NSString*)message onView:(UIView*)onView progressType:(JYProgressType)progressType;

/**
 * 隐藏小菊花
 *
 * @param onView  弹出框的父View
 */
+(void)hideProgressJY:(UIView*)onView;

/**************************** 以下是全局弹框 切换页面后依然显示 ****************************/
/**
 * 提示框  (Window上的提示)
 *
 * @param aString      文字内容
 * @param progressType 提示框状态
 */

+(void)showMessageJY:(NSString*)message progressType:(JYProgressType)progressType;

/**
 * 隐藏小菊花
 */
+(void)hideProgressJY;


+ (instancetype)sharedRequestInstance;

@end
