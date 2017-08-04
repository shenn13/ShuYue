//
//  UIButton+Tool.m
//  geliwuliu
//
//  Created by th on 2017/4/23.
//  Copyright © 2017年 th. All rights reserved.
//

#import "UIButton+Tool.h"

@implementation UIButton (Tool)

+ (UIButton *)buttonWithFrame:(CGRect)frame titleFont:(UIFont *)font titleColor_normal:(UIColor *)color_normal titleColor_highlighted:(UIColor *)color_highlighted backgroundColor:(UIColor *)bgColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)border_width cornerRadius:(CGFloat)radius {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    
    [btn.titleLabel setFont:font];
    
    [btn setTitleColor:color_normal forState:UIControlStateNormal];
    
    [btn setTitleColor:color_highlighted forState:UIControlStateHighlighted];
    
    btn.backgroundColor = bgColor;
    
    [btn.layer setMasksToBounds:YES];
    
    [btn.layer setBorderColor:borderColor.CGColor];
    
    btn.layer.borderWidth = border_width;
    
    [btn.layer setCornerRadius:radius];
    
    return btn;
}

@end
