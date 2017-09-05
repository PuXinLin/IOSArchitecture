//
//  PXLDataListViewController.h
//  JYProject
//
//  Created by dayou on 2017/9/5.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <UIKit/UIKit.h>

/*---------------------PXLDataListViewControllerDelegate-----------------------*/
@protocol PXLDataListViewControllerDelegate <NSObject>

@end

@interface PXLDataListViewController : UIViewController
/* delegate */
@property (nonatomic ,weak)id<PXLDataListViewControllerDelegate> delegate;

@end
