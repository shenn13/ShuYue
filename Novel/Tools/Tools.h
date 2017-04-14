//
//  Tools.h
//  EHealth_HM
//
//  Created by skusdk on 13-10-12.
//  Copyright (c) 2013年 dengwz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Tools : NSObject

#pragma mark 系统相关信息判断
/**
 *	@brief	是否iOS7系统判断
 *
 *	@return	return value description
 */
+(BOOL) IS_IOS_7;
+(BOOL) IS_IOS_8;
+(NSString *)imageByDeviceWithImage:(NSString *)image;


+(float)getMainHeight;
+(float)getMainWidth;
/**
 *	@brief	是否568h屏判断
 *
 *	@return	return value description
 */
+(BOOL) IS_iPhone_568h;


#pragma makr - 是否第一次打开app
/**
 *  是否第一次打开app
 */
+ (BOOL)isFirstOpenApp;

#pragma mark - 拨打电话

/**
 *  拨打电话
 *
 *  @param phoneNum 电话好吗
 */
+ (void)dialPhoneNumber:(NSString *)phoneNum;

#pragma makr - 保存当前用户的账号和密码
/**
 *  保存当前用户的账号和密码
 *
 *  @param account  账号
 *  @param password 密码
 */
+ (void)saveCurUserAccount:(NSString *)account password:(NSString *)password;

/**
 *  清除密码和账号
 *
 *  @param cleanPassword 是否清除密码
 *  @param cleanAccount  清除账号
 */
+ (void)cleanPassword:(BOOL)cleanPassword account:(BOOL)cleanAccount;

#pragma mark - 取用户当前的账号
/**
 *  取用户的账号
 *
 *  @return 用户账号
 */
+ (NSString *)getCurAccount;

#pragma mark - 取用户当前的密码
/**
 *  用户当前的密码
 *
 *  @return 用户密码
 */
+ (NSString *)getCurPassword;


#pragma mark - 获取软件版本号
/**
 *  获取软件版本号
 *
 *  @return 版本号
 */
+(NSString*)getSoftVersion;


#pragma mark - 读取本地的txt格式json数据 并解析返回字典
/**
 *  读取本地的txt格式json数据 并解析返回字典
 *
 *  @param fileName json 数据  txt 格式文件名
 *
 *  @return 字典
 */
+(NSDictionary *)readFileJsonFileName:(NSString *)fileName;

#pragma mark 序列化与反序列化
/**
 *	@brief	字典序列化成字符串
 */
+(NSString *)SerializationJson:(NSDictionary *)dictionary;


#pragma mark - json反序列化方法
/**
 *	@brief	json反序列化方法
 */
+(NSDictionary*)DeserializeJson:(NSString *)json;


#pragma mark - 取得wifi名
/**
 *  取得wifi名
 *
 *  @return wifi名
 */
+ (NSString *)getWifiName;


#pragma mark 导航设置 获取导航堆栈内对应的UIViewController对象
/**
 *	@brief	获取导航堆栈内对应的UIViewController对象
 *
 *	@param 	navControllers 	导航堆栈
 *	@param 	outViewController 	需要获取的UIViewController
 *
 */
+ (UIViewController *)FindSpecificViewController:(NSArray *)navControllers outViewController:(Class)outViewController;

#pragma mark - 打开网络状态监控
+ (void)openNetworkMonitoring;

#pragma mark - 获取网络状态
/**
 *  获取网络是否正常
 *
 *  @return yes 正常 no 没网络
 */
+ (BOOL)getNetworkStatus;


#pragma mark - 获取缓存大小
/**
 *  获取缓存大小
 */
+ (void)requestCachesFileSize:(void (^)(NSString *size))completion;

#pragma mark -清理缓存
/**
 *  清除字符串
 */
+(void)clearCache:(void (^)(BOOL flag))completion;

/**
 *  将html 转为适合屏幕
 *
 *  @param html 字符串
 *
 *  @return 新的字符串
 */
+ (NSString *) getStringWithViewport:(NSString *) html;


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

#pragma mark - 读取
+ (NSArray *)readFromDocumentWithFileName:(NSString *)fileName;

@end
