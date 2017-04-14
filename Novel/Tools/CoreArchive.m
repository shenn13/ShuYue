//
//  ToolArc.m
//  私人通讯录
//
//  Created by muxi on 14-9-3.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

static NSString *NewFeatureVersionKey = @"NewFeatureVersionKey";

#import "CoreArchive.h"

@implementation CoreArchive

#pragma mark - 偏好类信息存储
//保存普通对象
+(void)setStr:(NSString *)str key:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setObject:str forKey:key];
    
    //立即同步
    [defaults synchronize];

}

//读取
+(NSString *)strForKey:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSString *str=(NSString *)[defaults objectForKey:key];
    
    return str;

}

//删除
+(void)removeStrForKey:(NSString *)key{
    
    [self setStr:nil key:key];

}

//保存int
+(void)setInt:(NSInteger)i key:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setInteger:i forKey:key];
    
    //立即同步
    [defaults synchronize];

}

//读取
+(NSInteger)intForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSInteger i=[defaults integerForKey:key];
    
    return i;
}

//保存float
+(void)setFloat:(CGFloat)floatValue key:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setFloat:floatValue forKey:key];
    
    //立即同步
    [defaults synchronize];

}
//读取
+(CGFloat)floatForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    CGFloat floatValue=[defaults floatForKey:key];
    
    return floatValue;
}


//保存bool
+(void)setBool:(BOOL)boolValue key:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setBool:boolValue forKey:key];
    
    //立即同步
    [defaults synchronize];

}
//读取
+(BOOL)boolForKey:(NSString *)key{
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    BOOL boolValue=[defaults boolForKey:key];
    
    return boolValue;
}

/** 保存当前版本信息 */
+(void)saveCurrentVersionInfo{
    
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[self currentVersion];
    
    //保存
    [CoreArchive setStr:versionValueStringForSystemNow key:NewFeatureVersionKey];
}


/** 本地是否已经保存过当前版本信息 */
+(BOOL)isSavedCurrentVersionInfo{
    
    //本地版本号：归档
    NSString *versionLocal = [CoreArchive strForKey:NewFeatureVersionKey];
    
    //当前版本号:获取
    NSString *versionCurrent = [self currentVersion];
    
    return (versionLocal!=nil && [versionCurrent isEqualToString:versionLocal]);
}

/*
 *  当前程序的版本号
 */
+(NSString *)currentVersion{
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    
    return versionValueStringForSystemNow;
}


@end
