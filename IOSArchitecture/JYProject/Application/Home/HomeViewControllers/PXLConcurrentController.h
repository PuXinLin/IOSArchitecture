//
//  PXLConcurrentController.h
//  JYProject
//
//  Created by dayou on 2017/8/30.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <UIKit/UIKit.h>

/*---------------------JYModelModelDelegate-----------------------*/
@protocol PXLConcurrentControllerDelegate <NSObject>

@end

@interface PXLConcurrentController : UIViewController
/* delegate */
@property (nonatomic ,weak)id<PXLConcurrentControllerDelegate> delegate;

@end
