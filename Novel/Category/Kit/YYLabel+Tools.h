//
//  YYLabel+Tools.h
//  Novel
//
//  Created by th on 2017/2/11.
//  Copyright © 2017年 th. All rights reserved.
//

#import <YYKit/YYKit.h>

@interface YYLabel (Tools)


/**
 返回一个已经计算好frame的YYLabel

 @param frame frame
 @param font 字体大小
 @param color 字体颜色
 @return YYLabel
 */
+ (YYLabel *_Nonnull)labelWithFrame:(CGRect)frame textFont:(CGFloat)font textColor:(UIColor *_Nullable)color;


/**
 返回YYTextLayout

 @param title 文字
 @param maxSize 最大size
 @param maximumNumberOfRows 显示行数
 @param font 字体大小
 @param color 字体颜色
 @param lineSpace 行间距
 @return YYTextLayout
 */
- (nonnull YYTextLayout *)layoutWithTitle:(nonnull NSString *)title maxSize:(CGSize)maxSize maximumNumberOfRows:(NSUInteger)maximumNumberOfRows textFont:(nonnull UIFont *)font textColor:(nonnull UIColor *)color lineSpace:(CGFloat)lineSpace;


/**
 返回一个数组，元素为label每行的文字

 @param label 传入label
 @return 数组
 */
+ (nullable NSArray *)getLinesArrayOfStringInLabel:(nonnull YYLabel *)label;

@end
