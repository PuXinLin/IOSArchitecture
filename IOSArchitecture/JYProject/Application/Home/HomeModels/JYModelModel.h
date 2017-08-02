//
//  JYModelModel.h
//  JYProject
//
//  Created by dayou on 2017/8/1.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

/*---------------------JYModelModelDelegate-----------------------*/
@protocol JYModelModelDelegate <NSObject>

@end

@interface JYModelModel : NSObject
/* delegate */
@property (nonatomic ,weak)id<JYModelModelDelegate> delegate;

@end
