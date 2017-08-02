//
//  JYModelView.h
//  JYProject
//
//  Created by dayou on 2017/8/1.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <UIKit/UIKit.h>

/*---------------------JYModelViewDelegate-----------------------*/
@protocol JYModelViewDelegate <NSObject>

@end

@interface JYModelView : UIView
/* delegate */
@property (nonatomic ,weak)id<JYModelViewDelegate> delegate;

@end
