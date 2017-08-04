//
//  UIView+Pro.m
//  Demo1222
//
//  Created by ZhouZhenFu on 15/12/25.
//  Copyright © 2015年 HzB. All rights reserved.
//

#import "UIView+Pro.h"

@implementation UIView (Pro)
//minX_pro

-(void)setMaxX_pro:(CGFloat)maxX_pro{
    self.x_pro = maxX_pro - self.frame.size.width;
}
- (CGFloat)maxX_pro{
    return CGRectGetMaxX(self.frame);
}
-(void)setMaxY_pro:(CGFloat)maxY_pro{
    self.y_pro = maxY_pro - self.frame.size.height;
}
- (CGFloat)maxY_pro{
    return CGRectGetMaxY(self.frame);
}

- (void)setPosition:(CGPoint)position {
    CGRect frame = self.frame;
    frame.origin = position;
    self.frame = frame;
}

- (CGPoint)position {
    return self.frame.origin;
}

- (void)setX_pro:(CGFloat)x_pro{
    CGRect frame = self.frame;
    frame.origin.x = x_pro;
    self.frame = frame;}

- (CGFloat)x_pro {
    return self.frame.origin.x;
}

- (void)setY_pro:(CGFloat)y_pro{
    CGRect frame = self.frame;
    frame.origin.y = y_pro;
    self.frame = frame;
}

- (CGFloat)y_pro {
    return self.frame.origin.y;
}


- (void)setWidth_pro:(CGFloat)width_pro{
    CGRect frame = self.frame;
    frame.size.width = width_pro;
    self.frame = frame;
}

- (void)setHeight_pro:(CGFloat)height_pro{
    CGRect frame = self.frame;
    frame.size.height = height_pro;
    self.frame = frame;
}

- (void)setSize_pro:(CGSize)size_pro{
    CGRect frame = self.frame;
    frame.size = size_pro;
    self.frame = frame;
}
- (CGSize)size_pro {
    return self.frame.size;
}

- (CGFloat)width_pro {
    return self.frame.size.width;
}

- (CGFloat)height_pro {
    return self.frame.size.height;
}

- (void)setCenterX_pro:(CGFloat)centerX_pro{
    CGPoint center = self.center;
    center.x = centerX_pro;
    self.center = center;
}

- (CGFloat)centerX_pro{
    return self.center.x;
}

- (void)setCenterY_pro:(CGFloat)centerY_pro{
    CGPoint center = self.center;
    center.y = centerY_pro;
    self.center = center;
}
- (CGFloat)centerY_pro
{
    return self.center.y;
}

- (void)setRound{
    self.layer.cornerRadius = self.width_pro / 2.0;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
}


#pragma mark - 设置View的某一个方向的圆角
- (void)setViewCornerByRoundingCorners:(UIRectCorner)corners CornerRadii:(CGSize)cornerRadii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


@end
