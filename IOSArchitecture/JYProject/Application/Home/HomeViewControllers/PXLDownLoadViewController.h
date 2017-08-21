//
//  PXLDownLoadViewController.h
//  JYProject
//
//  Created by dayou on 2017/8/9.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <UIKit/UIKit.h>

/*---------------------JYModelModelDelegate-----------------------*/
@protocol PXLDownLoadViewControllerDelegate <NSObject>

@end

@interface PXLDownLoadViewController : UIViewController
/* delegate */
@property (nonatomic ,weak)id<PXLDownLoadViewControllerDelegate> delegate;

@end
