//
//  UIView+Pro.h
//  Demo1222
//
//  Created by ZhouZhenFu on 15/12/25.
//  Copyright © 2015年 HzB. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface UIView (Pro)

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGFloat x_pro;
@property (nonatomic, assign) CGFloat y_pro;
@property (nonatomic, assign) CGSize size_pro;
@property (nonatomic, assign) CGFloat width_pro;
@property (nonatomic, assign) CGFloat height_pro;
@property (nonatomic,assign) CGFloat centerX_pro;
@property (nonatomic,assign) CGFloat centerY_pro;

@property (nonatomic, assign) CGFloat maxX_pro;
@property (nonatomic, assign) CGFloat maxY_pro;


/**
 *  将view 设置为圆形 ，要设置了frame 才有效
 */
-(void)setRound;


/**
 *  设置View的某一个方向的圆角：
 *
 *  @param corners     UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param cornerRadii 圆角的大小
 */
- (void)setViewCornerByRoundingCorners:(UIRectCorner)corners CornerRadii:(CGSize)cornerRadii;



@end
