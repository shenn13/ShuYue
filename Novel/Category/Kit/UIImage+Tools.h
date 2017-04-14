//
//  UIImage+Tools.h
//  demo10-9
//
//  Created by xx on 15/10/12.
//  Copyright (c) 2015年 xx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

+ (UIImage *)imageFileNamed:(NSString *)imageName;

/**
 *  修改图片size
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize;

/**
 *  按图片的比例，根据宽取得 按比例的高
 *
 *  @param width 宽
 *
 *  @return 高
 */
- (CGFloat)InProportionAtWidth:(CGFloat)width;

/**
 *  取图片的比例，根据高取得 按比例的宽
 *
 *  @param height 高
 *
 *  @return 宽
 */
- (CGFloat)InProportionAtHeight:(CGFloat)height;

/** 压缩图片*/
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
/**
 *  压缩图片UIImageJPEGRepresentation
 */
+ (NSData *)imageData:(UIImage *)myimage;

@end
