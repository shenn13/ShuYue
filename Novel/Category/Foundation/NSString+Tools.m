//
//  NSString+Tools.m
//  demo10-9
//
//  Created by xx on 15/10/11.
//  Copyright (c) 2015年 xx. All rights reserved.
//

#import "NSString+Tools.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (Tools)

#pragma mark - URL编码
+ (NSString *)encodeToPercentEscapeString:(NSString *)input {
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)input, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    
    return outputStr;
}


#pragma mark - 判断字符串是否为null @“”

+ (BOOL)isBlankString:(NSString *)string
{
    if (nil == string) {
        return YES;
    }
    NSString *temp = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (temp == nil) {
        return YES;
    }
    if (temp == NULL) {
        return YES;
    }
    if ([temp isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if(temp.length < 1){
        return YES;
    }
    return NO;
}


/**
 *@method 判断是否为整形
 *@param string 字符数据
 */
+(BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 判断是否为浮点形
+(BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - 判断是否为空字符串，如为空转为特定字符串，否则原值返回
+ (NSString *)changNULLString:(id)string
{
    if ([NSString isBlankString:string]) {
        
        return @"暂无";
    }
    else
    {
        return string;
    }
}
+ (NSString *)changNULLString:(id)string newString:(NSString *)newString
{
    if ([NSString isBlankString:string]) {
        
        if (newString) {
            
            return newString;
        }
        return @"暂无";
    }
    else
    {
        return string;
    }
    
}

#pragma mark - 判断是否为空字符串，如为空转为特定字符串，否则原值返回并在后面添加特定的字符串
+ (NSString *)changNULLString:(id)string addendStr:(NSString *)appendStr
{
    if ([NSString isBlankString:string]) {
        
        return @"暂无";
    }
    else
    {
        return [NSString stringWithFormat:@"%@%@",string,appendStr];
    }
}


#pragma 计算字体的宽
+(CGFloat)calculateLabelWidth:(NSString *)title font:(UIFont *)font AndHeight:(CGFloat)height
{
    float width = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
    return width;
}
#pragma mark - 计算字体高
+(CGFloat)calculateLabelHeight:(NSString *)title font:(UIFont *)font AndWidth:(CGFloat)width
{
    NSString *newTitle = [NSString stringWithFormat:@"%@0",title];
    float height = [newTitle boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
    return height;
}

+ (NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

/*
 *  document根文件夹
 */
+(NSString *)documentFolder{
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



/*
 *  caches根文件夹
 */
+(NSString *)cachesFolder{
    
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 *  生成子文件夹
 *
 *  如果子文件夹不存在，则直接创建；如果已经存在，则直接返回
 *
 *  @param subFolder 子文件夹名
 *
 *  @return 文件夹路径
 */
-(NSString *)createSubFolder:(NSString *)subFolder{
    
    NSString *subFolderPath=[NSString stringWithFormat:@"%@/%@",self,subFolder];
    
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:subFolderPath isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:subFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return subFolderPath;
}
+ (NSString *)addOne:(id)number{
    NSInteger count = [number integerValue];
    return [NSString stringWithFormat:@"%ld",(long)count+1];
}
+ (NSString *)reduceOne:(id)number{
    NSInteger count = [number integerValue];
    return [NSString stringWithFormat:@"%ld",(long)(count-1)];
}

/** 返回文字size */
- (CGSize)sizeWithText:(NSString *)text size:(CGSize)size attributes:(nullable NSDictionary<NSString *,id> *)attrs{
    CGSize textSize = [text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return textSize;
}

@end
