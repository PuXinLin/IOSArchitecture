//
//  JYModelViewController.h
//  JYProject
//
//  Created by dayou on 2017/8/1.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <UIKit/UIKit.h>

/*---------------------JYModelModelDelegate-----------------------*/
@protocol JYModelViewControllerDelegate <NSObject>

@end

@interface JYModelViewController : UIViewController
/* delegate */
@property (nonatomic ,weak)id<JYModelViewControllerDelegate> delegate;

@property (nonatomic ,strong)NSString *jystring;

@end
