//
//  JYProgressHUD.m
//  JYProject
//
//  Created by dayou on 2017/8/1.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "JYProgressHUD.h"
#import "JYNoNetWorkView.h"

static CGFloat const duration = 2.f; // 显示时间

static BOOL isAvalibleTouch = NO; // 手势是否可用，默认NO

@interface JYProgressHUD()

@end

@implementation JYProgressHUD

+ (instancetype)sharedRequestInstance
{
    static JYProgressHUD *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[JYProgressHUD alloc]init];
    });
    return __sharedInstance;
}

#pragma mark ---------- Public Methods ----------
/**************************** 这里是页面弹框 切换页面后不会显示 ****************************/
#pragma mark 提示框  (Controller上的提示)
+(void)showMessageJY:(NSString*)message onView:(UIView*)onView progressType:(JYProgressType)progressType
{
    JYProgressHUD * jyprogress = [JYProgressHUD sharedRequestInstance] ;
    MBProgressHUD *progressHUD = [jyprogress loadProgressOnView:onView];
    if (!progressHUD) {
        return;
    }
    switch (progressType) {
        case JYProgress_Text:
        {
            progressHUD.labelText = message;
            progressHUD.mode = MBProgressHUDModeText;
            [jyprogress showProgressHUD:duration onprogressHUD:progressHUD];
        }
            break;
        case JYProgress_Loading:
        {
            progressHUD.mode = MBProgressHUDModeIndeterminate;
            [jyprogress showProgressHUD:0 onprogressHUD:progressHUD];
        }
            break;
        case JYProgress_TextAndLoading:
        {
            progressHUD.labelText = message;
            progressHUD.mode = MBProgressHUDModeIndeterminate;
            [jyprogress showProgressHUD:0 onprogressHUD:progressHUD];
        }
            break;
        case JYProgress_RequestError:
        {
            /* 自定义的View */
            JYNoNetWorkView *noNetWorkView = [[JYNoNetWorkView alloc]initWithView:progressHUD];
            progressHUD.margin = 0;
            progressHUD.cornerRadius = 0;
            noNetWorkView.message = message;
            progressHUD.userInteractionEnabled = YES;
            progressHUD.mode = MBProgressHUDModeCustomView;
            progressHUD.customView = noNetWorkView;
            [jyprogress showProgressHUD:0 onprogressHUD:progressHUD];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark 隐藏小菊花
+(void)hideProgressJY:(UIView *)onView
{
    [MBProgressHUD hideHUDForView:onView animated:YES];
}
- (instancetype)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:JYProgressHUD.class]) {
            return (JYProgressHUD *)subview;
        }
    }
    return nil;
}

/**************************** 以下是全局弹框 切换页面后依然显示 ****************************/

#pragma mark 提示框  (Window上的提示)
+(void)showMessageJY:(NSString*)message progressType:(JYProgressType)progressType
{
    JYProgressHUD * jyprogress = [JYProgressHUD sharedRequestInstance] ;
    MBProgressHUD *progressHUD = [jyprogress loadProgressOnView:JY_APP_KeyWindow];
    if (!progressHUD) {
        return;
    }
    switch (progressType) {
        case JYProgress_Text:
        {
            progressHUD.labelText = message;
            progressHUD.mode = MBProgressHUDModeText;
            [jyprogress showProgressHUD:duration onprogressHUD:progressHUD];
        }
            break;
        case JYProgress_Loading:
        {
            progressHUD.mode = MBProgressHUDModeIndeterminate;
            [jyprogress showProgressHUD:0 onprogressHUD:progressHUD];
        }
            break;
        case JYProgress_TextAndLoading:
        {
            progressHUD.labelText = message;
            progressHUD.mode = MBProgressHUDModeIndeterminate;
            [jyprogress showProgressHUD:0 onprogressHUD:progressHUD];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 隐藏小菊花
+(void)hideProgressJY
{
    [MBProgressHUD hideHUDForView:JY_APP_KeyWindow animated:YES];
}

#pragma mark MBProgressHUD 显示
-(void)showProgressHUD:(CGFloat)durationTime onprogressHUD:(MBProgressHUD*)progressHUD
{
    /* 主线程更新 */
    dispatch_async(dispatch_get_main_queue(), ^{
        if (durationTime){
            [progressHUD hide:YES afterDelay:duration];
        }
        else{
            [progressHUD show:YES];
        }
    });
}
#pragma mark 初始化 MBProgressHUD
-(MBProgressHUD*)loadProgressOnView:(UIView*)view
{
    if (!view) {
        return nil;
    }
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    progressHUD.userInteractionEnabled = isAvalibleTouch;
    progressHUD.removeFromSuperViewOnHide = YES;
    return progressHUD;
}
#pragma mark 配置View
-(void)configurationView{}

#pragma mark 数据请求
-(void)loadRequestData{}

#pragma mark 页面初始化
-(void)resizeCustomView{}

#pragma mark ---------- Click Event ----------

#pragma mark ---------- Delegate ----------

#pragma mark ---------- Lazy Load ----------

@end

