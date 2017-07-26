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
-(UIImage *)getImage:(CGSize)size backColor:(UIColor *)color cornerRadius:(CGFloat)radius
{
    UIImage * image = [[UIImage alloc]init];
    
    CGRect rect = (CGRect){CGPointZero,size}; // 图像上下文 内存中开辟一个地址，跟屏幕无关
    
    /**
     size：绘图的尺寸
     opaque: 不透明 false(透明) / true（不透明）
     scale: 屏幕分辨率，默认生成的图像默认使用 1.0 的分辨率，图像质量不好 可以指定 0 会选择当前设备的屏幕分辨率
     */
    
    UIGraphicsBeginImageContextWithOptions(size, true, 0); // -  false(透明) / true（不透明），true好，占GPU少
    
    [color setFill]; // 0.填充背景
    UIRectFill(rect);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius]; //  1.实例化一个圆形的路径
    
    [path addClip]; // 2.进行路径裁剪 - 后续的绘图，都会出现在圆形内部，外部的全部干掉
    
    [image drawInRect:rect]; // 3.绘图 drawInRect 就是在指定区域内拉伸屏幕
    
    [[UIColor redColor] setStroke]; // - 4.绘制内切的圆形
    
    path.lineWidth = 2;
    [path stroke];
    
    image = UIGraphicsGetImageFromCurrentImageContext(); // 5.取的结果
    
    UIGraphicsEndImageContext(); // 6.关闭上下文
    
    return image; // 7.返回结果
    
    
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
