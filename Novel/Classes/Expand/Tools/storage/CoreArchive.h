//
//  ToolArc.h
//  私人通讯录
//
//  Created by muxi on 14-9-3.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -  用NSUserDefaults 偏好类信息存储

@interface CoreArchive : NSObject

/**
 *  保存普通字符串
 */
+(void)setStr:(NSString *)str key:(NSString *)key;

/**
 *  读取
 */
+(NSString *)strForKey:(NSString *)key;

/**
 *  删除
 */
+(void)removeStrForKey:(NSString *)key;


/**
 *  保存int
 */
+(void)setInt:(NSInteger)i key:(NSString *)key;

/**
 *  读取int
 */
+(NSInteger)intForKey:(NSString *)key;



/**
 *  保存float
 */
+(void)setFloat:(CGFloat)floatValue key:(NSString *)key;

/**
 *  读取float
 */
+(CGFloat)floatForKey:(NSString *)key;

/**
 *  保存bool
 */
+(void)setBool:(BOOL)boolValue key:(NSString *)key;

/**
 *  读取bool
 */
+(BOOL)boolForKey:(NSString *)key;



/** 保存当前版本信息 */
+(void)saveCurrentVersionInfo;


/** 本地是否已经保存过当前版本信息 */
+(BOOL)isSavedCurrentVersionInfo;


/** 当前程序的版本号：系统版本号，非归档本地版本号 */
+(NSString *)currentVersion;

@end
