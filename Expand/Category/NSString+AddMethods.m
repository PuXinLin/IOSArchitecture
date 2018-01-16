//
//  NSString+AddMethods.m
//  JYProject
//
//  Created by dayou on 2017/7/26.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import "NSString+AddMethods.h"
#import <CoreText/CoreText.h>

@implementation NSString (AddMethods)

/* 把string转化为富文本 */
+ (NSMutableAttributedString *)jy_stringConversionText:(NSString *)text
                                                 color:(UIColor *)color
                                                  font:(CGFloat)font
                                                 range:(NSRange)range {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attributedStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font],NSForegroundColorAttributeName:color} range:range];
    
    return attributedStr;
}

/* 计算文字高度 */
-(CGFloat)jy_heightWithFontString:(NSString*)contentString width:(CGFloat)width fontSize:(CGFloat)fontSize{
    
    CGSize titleSize = [contentString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return titleSize.height+1; //   弥补小数
}
/* 计算文字宽度 */
-(CGFloat)jy_widthWithFontString:(NSString*)contentString height:(CGFloat)height fontSize:(CGFloat)fontSize{
    
    CGSize titleSize = [contentString boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return titleSize.width+1; //   弥补小数
}
/* 给区域返回字数 */
-(NSRange)jy_sizeToWidth:(NSString*)string size:(CGSize)size fontSize:(CGFloat)fontSize{
    
    CGRect rect =CGRectMake(0, 0, size.width, size.height);
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    [attributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} range:NSMakeRange(0, string.length)];
    
    NSAttributedString * childString = [attributedStr attributedSubstringFromRange:NSMakeRange(0, attributedStr.length)];
    
    CTFramesetterRef childFramesetter =CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) childString);
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:rect];
    
    CTFrameRef frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
    CFRange range = CTFrameGetVisibleStringRange(frame);
    
    CFRelease(childFramesetter);    //  释放内存
    
    CFRelease(frame);   //  释放内存
    
    return NSMakeRange(range.location, range.length);
}


@end
