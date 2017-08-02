//
//  JYNoNetWorkView.h
//  JYProject
//
//  Created by dayou on 2017/8/2.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <UIKit/UIKit.h>

/*---------------------JYModelViewDelegate-----------------------*/
@protocol JYNoNetWorkViewDelegate <NSObject>
/* 重新请求数据 */
-(void)reloadRequest;
@end

/* 网络请求失败View */
@interface JYNoNetWorkView : UIView

/* delegate */
@property (nonatomic ,weak)id<JYNoNetWorkViewDelegate> delegate;

/* message */
@property (nonatomic ,strong)NSString *message;

/**
 *初始化
 *
 * @param view 弹出框的父View
 */
-(instancetype)initWithView:(MBProgressHUD*)view;

@end
