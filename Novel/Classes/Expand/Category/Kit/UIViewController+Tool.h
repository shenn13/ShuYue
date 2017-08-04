//
//  UIViewController+Tool.h
//  geliwuliu
//
//  Created by th on 2017/4/24.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Tool)


/**
 *  根据图片名 添加左边导航item
 *
 *  @param imageName 图片名
 *
 *  @return 按钮
 */

/**
 根据图片名和标题，添加左边导航leftItem

 @param imageName 图片名
 @param title 标题，可以为空
 @param color 标题颜色
 @return left按钮
 */
- (UIButton *)addLeftBarButtonItemImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color;

- (UIBarButtonItem *)addRightBarButtonItemTitle:(NSString *)title;

- (UIButton *)addRightBarButtonItemImageName:(NSString *)imageName width:(CGFloat)width;

@end
