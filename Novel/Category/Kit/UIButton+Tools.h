//
//  UIButton+Tools.h
//  Novel
//
//  Created by th on 2017/2/11.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Tools)

+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *)font titleColor_normal:(UIColor *)color_normal titleColor_highlighted:(UIColor *)color_highlighted backgroundColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)border_width cornerRadius:(CGFloat)radius;

@end
