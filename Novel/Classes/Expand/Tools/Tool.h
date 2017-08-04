//
//  Tool.h
//  geliwuliu
//
//  Created by th on 2017/4/22.
//  Copyright © 2017年 th. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreArchive.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface Tool : NSObject

+ (instancetype)shareInstance;

/**
 *	@brief	是否iOS10系统判断
 *
 *	@return	bool
 */
+(BOOL) is_IOS_10;

/**
 *  是否第一次打开app
 *
 *  @return bool
 */
+ (BOOL)isFirstOpenApp;


/**
 检测是否是新版本

 @return bool
 */
+ (BOOL)isNewVersion;

/**
 *  获取软件版本号
 *
 *  @return 版本号
 */
+ (NSString*)getSoftVersion;

#pragma mark - 获取缓存大小
/**
 获取缓存大小

 @param completion block打印缓存size
 */
+ (void)getCachesFileSize:(void (^)(NSString *size))completion;

/**
 *  清除缓存
 *
 *  @param completion block bool是否成功
 */
+ (void)removeCache:(void (^)(BOOL flag))completion;

#pragma mark - 将字典，数组写到沙盒
/**
 *  将字典，数组写到沙盒
 *
 *  @param dataSource 字典，数组
 *  @param fileName   文件名：region.plist
 *
 *  @return 文件的路径
 */
+ (NSString *)writeToDocumentsWithDataSource:(id)dataSource FileName:(NSString *)fileName;

/**
读取沙盒plist,只能读取存储为Array格式的数据

 @param fileName plist文件名
 @return 数组
 */
+ (NSArray *)readArrayFromDocumentWithFileName:(NSString *)fileName;


/**
 读取沙盒plist,只能读取存储为Dictionary格式的数据

 @param fileName plist文件名
 @return 字典
 */
+ (NSDictionary *)readDictFromDocumentWithFileName:(NSString *)fileName;

/**
 获取沙盒Library目录下的Private Documents目录 路径
 */

/**
 获取沙盒Library目录下的Private Documents目录下的某个文件路径

 @param key 文件名
 @param type 文件后缀 例如.plist  .data
 @return 文件路径
 */
+ (NSString *)getPathWithKey:(NSString *)key ofType:(NSString *)type;

#pragma mark - 取得wifi名
/**
 *  取得wifi名，需要真机
 *
 *  @return wifi名
 */
+ (NSString *)getWifiName;


/**
 获取当前版本号
 */
+ (NSString *)getCurrentVersion;

/**
 获取设备唯一号
 */
+ (NSString *)getDeviceId;


/**
 统一收起键盘
 */
+ (void)endEditing;

/**
 键盘管理
 */
+ (void)configWithKeyBoard;



@end
