//
//  UIView+AddMethods.m
//  JYProject
//
//  Created by dayou on 2017/7/26.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "UIView+AddMethods.h"

@implementation UIView (AddMethods)

/*  设置圆角 */
-(void)jy_addCornerRadius:(CGFloat)radius{
    self.layer.cornerRadius = radius;
}

/* 切除view指定位置的圆角 */
-(void)jy_removalOfSpecifiedLocationRoundCorners:(UIRectCorner)corner withSize:(CGSize)size {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/*  设置UIView的边框、颜色、圆角 */
-(void)jy_setBorderWith:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    self.layer.masksToBounds = YES;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

@end
