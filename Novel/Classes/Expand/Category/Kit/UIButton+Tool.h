//
//  UIButton+Tool.h
//  geliwuliu
//
//  Created by th on 2017/4/23.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Tool)

/**
 初始化一个按钮
 
 @param frame frame
 @param font 字体大小
 @param color_normal 标题正常颜色
 @param color_highlighted 标题高亮颜色
 @param bgColor 背景颜色
 @param borderColor 边框颜色
 @param border_width 边框宽度
 @param radius 半径
 @return 按钮
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *)font titleColor_normal:(UIColor *)color_normal titleColor_highlighted:(UIColor *)color_highlighted backgroundColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)border_width cornerRadius:(CGFloat)radius;

@end
