//
//  UIImage+Tools.m
//  demo10-9
//
//  Created by xx on 15/10/12.
//  Copyright (c) 2015年 xx. All rights reserved.
//

#import "UIImage+Tools.h"

@implementation UIImage (Tools)

+ (UIImage *)imageFileNamed:(NSString *)imageName
{
//    UIImage * tempImage = nil;
//    //  NSString * imagePath = [[NSString alloc] initWithFormat:@"%@/%@", resourcesPath, imageName];
//    
////    NSString * imagePath  = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
////    tempImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
//    //    [imagePath release];
//        return tempImage ;
    return [UIImage imageNamed:imageName];

}

- (CGFloat)height{
    return self.size.height;
}
- (CGFloat)width{
    return self.size.width;
}
- (void)setHeight:(CGFloat)height{}
- (void)setWidth:(CGFloat)width{}

/**
 *  修改图片size
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}

- (CGFloat)InProportionAtWidth:(CGFloat)width
{
    return  width / (self.size.width / self.size.height);
}

- (CGFloat)InProportionAtHeight:(CGFloat)height
{
    return height * (self.size.width / self.size.height);
}

#pragma mark - 根据图片的宽度压缩图片
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSData *)imageData:(UIImage *)myimage
{
    NSData *data = UIImageJPEGRepresentation(myimage, 1.0);
    
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.65);
        }else if (data.length>100*1024) {//0.15M-0.2M
            data=UIImageJPEGRepresentation(myimage, 0.8);
        }else if (data.length>1*1024) {
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
        
    }
    
    return data;
}

@end
