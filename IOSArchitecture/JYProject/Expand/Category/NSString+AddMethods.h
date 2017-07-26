//
//  NSString+AddMethods.h
//  JYProject
//
//  Created by dayou on 2017/7/26.
//  Copyright © 2017年 dayou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AddMethods)

/**
 * 把string转化为NSMutableAttributedString
 */
+ (NSMutableAttributedString *)jy_stringConversionText:(NSString *)text
                                            color:(UIColor *)color
                                                  font:(CGFloat)font
                                                 range:(NSRange)range;
/**
 *  计算文字高度
 */
-(CGFloat)jy_heightWithFontString:(NSString*)contentString width:(CGFloat)width fontSize:(CGFloat)fontSize;

/**
 *  计算文字宽度
 */
-(CGFloat)jy_widthWithFontString:(NSString*)contentString height:(CGFloat)height fontSize:(CGFloat)fontSize;

/**
 *  给区域返回运行显示的字数
 */
-(NSRange)jy_sizeToWidth:(NSString*)string size:(CGSize)size fontSize:(CGFloat)fontSize;

@end
