//
//  UIImage+AddMethods.m
//  JYProject
//
//  Created by dayou on 2017/7/26.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "UIImage+AddMethods.h"

@implementation UIImage (AddMethods)

/* 绘制一张纯色的图片 */
+ (UIImage *)jy_createImageWithColor:(UIColor *)color frame:(CGRect)rect Radius:(CGFloat)radius{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextFillPath(context);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
/* 设置图片的大小 */
+ (UIImage*)jy_imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
