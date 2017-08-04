//
//  Tool.m
//  geliwuliu
//
//  Created by th on 2017/4/22.
//  Copyright © 2017年 th. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (instancetype)shareInstance {
    
    static Tool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Tool alloc] init];
    });
    return instance;
}

+ (BOOL) is_IOS_10 {
    
    return [[Tool shareInstance] is_IOS_10];
}

- (BOOL) is_IOS_10 {
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max) {
        // ios10以上
        return YES;
        
    } else {
        // ios10以下
        return NO;
    }
}

/* 
 区别
 
 CFBundleShortVersionString对应Xcode里项目的Version
 CFBundleVersion 对应Xcode里项目的Build 这个版本是内部自己团队使用的一个版本号，一般不对外公开。
 
 */
+ (BOOL)isNewVersion {
    return [[Tool shareInstance] isNewVersion];
}

- (BOOL)isNewVersion {
    //1、 取出沙盒中存储的上次使用软件的版本号
    NSString *key = @"CFBundleShortVersionString";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 2、获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    // 3、判断版本号
    if ([currentVersion isEqualToString:lastVersion]) {// 旧版本
        
        return NO;
        
    }else{ // 新版本
        
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        
        return YES;
    }
}


+ (BOOL)isFirstOpenApp {
    
    return [[Tool shareInstance] isFirstOpenApp];
}

- (BOOL)isFirstOpenApp {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL frist = [[defaults objectForKey:@"frist"] boolValue];
    if (frist) {
        if (![CoreArchive isSavedCurrentVersionInfo]) {
            //如当前的版本号和保存的不同  更新版本了
            //            [AppConfig saveLoginType:kNoLogin_Type];
            [CoreArchive saveCurrentVersionInfo];
            return YES;
        }
        return NO;
    }
    else{
        [CoreArchive saveCurrentVersionInfo];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"frist"];
        [defaults synchronize];
        return YES;
    }
}

+ (NSString*)getSoftVersion {
    return [[Tool shareInstance] getSoftVersion];
}

- (NSString*)getSoftVersion {
    return [CoreArchive currentVersion];
}


+ (void)getCachesFileSize:(void (^)(NSString *size))completion {
    
    [[Tool shareInstance] getCachesFileSize:^(NSString *size) {
        completion(size);
    }];
}

- (void)getCachesFileSize:(void (^)(NSString *size))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        NSString *folderPath = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"];
        
        NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
        NSFileManager* manager = [NSFileManager defaultManager];
        NSString *sizeStr = @"0M";
        if (![manager fileExistsAtPath:folderPath])
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(sizeStr);
            });
        }
        else
        {
            NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
            NSString* fileName;
            long long folderSize = 0;
            while ((fileName = [childFilesEnumerator nextObject]) != nil){
                NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
                folderSize += [Tool fileSizeAtPath:fileAbsolutePath];
            }
            float sizeM = folderSize/(1024.0*1024.0);
            
            if (sizeM < 1) {
                
                int size = (int)1024 * sizeM;
                
                sizeStr = [NSString stringWithFormat:@"%d k",size];
            }
            else {
                
                sizeStr = [NSString stringWithFormat:@"%@ M",[NSString changeFloat:[NSString stringWithFormat:@"%.2f", sizeM]]];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(sizeStr);
            });
        }
    });
    
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*) filePath{
    
    return [[Tool shareInstance] fileSizeAtPath:filePath];
}

- (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (void)removeCache:(void (^)(BOOL flag))completion {
    
    [[Tool shareInstance] removeCache:^(BOOL flag) {
        
        if (completion) {
            completion(flag);
        }
    }];
}

- (void)removeCache:(void (^)(BOOL flag))completion {
    
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       dispatch_async(dispatch_get_main_queue(), ^{
                           completion(YES);
                       });
                   });
}


+ (NSString *)writeToDocumentsWithDataSource:(id)dataSource FileName:(NSString *)fileName {
    
    return [[Tool shareInstance] writeToDocumentsWithDataSource:dataSource FileName:fileName];
}

- (NSString *)writeToDocumentsWithDataSource:(id)dataSource FileName:(NSString *)fileName {
    
    //得到完整的文件名
    NSString *filename = [[Tool shareInstance] getPathWithKey:fileName ofType:@".plist"];
    // 写入本地
    if ([dataSource isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)dataSource;
        [array writeToFile:filename atomically:YES];
        return filename;
    }
    if ([dataSource isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)dataSource;
        [dict writeToFile:filename atomically:YES];
        
        return filename;
    }
    
    return @"";
}

+ (NSArray *)readArrayFromDocumentWithFileName:(NSString *)fileName {
    
    return [[Tool shareInstance] readArrayFromDocumentWithFileName:fileName];
}

- (NSArray *)readArrayFromDocumentWithFileName:(NSString *)fileName {
    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    
//    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    
    return [NSArray arrayWithContentsOfFile:[[Tool shareInstance] getPathWithKey:fileName ofType:@".plist"]];
}

+ (NSDictionary *)readDictFromDocumentWithFileName:(NSString *)fileName {
    
    return [[Tool shareInstance] readDictFromDocumentWithFileName:fileName];
}

- (NSDictionary *)readDictFromDocumentWithFileName:(NSString *)fileName {
    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    
//    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    
    //统一使用沙盒Library目录下的Private Documents文件夹
    return [NSDictionary dictionaryWithContentsOfFile:[[Tool shareInstance] getPathWithKey:fileName ofType:@".plist"]];
}

+ (NSString *)getPathWithKey:(NSString *)key ofType:(NSString *)type {
    return [[Tool shareInstance] getPathWithKey:key ofType:type];
}

- (NSString *)getPathWithKey:(NSString *)key ofType:(NSString *)type {
    
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    
    docsdir = [docsdir stringByAppendingPathComponent:@"Private Documents"];
    NSLog(@"%@",docsdir);
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path = @"";
    
    if (type.length > 0) {
        path = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.%@", NSStringFromClass([self class]),key, type]];
    } else {
        path = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", NSStringFromClass([self class]),key]];
    }
    
    return path;
}


+ (NSString *)getWifiName {
    
    return [[Tool shareInstance] getWifiName];
}

- (NSString *)getWifiName {
    
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}


+ (NSString *)getCurrentVersion {
    return [[Tool shareInstance] getCurrentVersion];
}

- (NSString *)getCurrentVersion {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return appCurVersion;
}

/**
 UUID是Universally Unique Identifier的缩写，中文意思是通用唯一识别码。它是让分布式系统中的所有元素，都能有唯一的辨识资讯，而不需要透过中央控制端来做辨识资讯的指定。这样，每个人都可以建立不与其它人冲突的 UUID。在此情况下，就不需考虑数据库建立时的名称重复问题。苹果公司建议使用UUID为应用生成唯一标识字符串。每次生成都会改变
 */
+ (NSString *) uuid {
    return [[Tool shareInstance] uuid];
}

- (NSString *)uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
/**
 iOS7及之后的系统，是没有办法获取一个类似UDID这样的能保证设备唯一的标志符的;
 钥匙串的访问需要Security.framework。钥匙串的API都比较恶心，这里推荐使用SAMKeyChain， https://github.com/soffes/SAMKeychain
 当然这也是有弊端的，比如刷机、恢复出厂设置这类会重置手机信息的，都会清空钥匙串信息，我们保存的UUID也就跟着清除了，不过苹果各种限制，我们能做到这种底部，已经很不错了！！！
 */
+ (NSString *)getDeviceId {
    return [[Tool shareInstance] getDeviceId];
}

- (NSString *)getDeviceId {
    NSString *uuid = [YYKeychain getPasswordForService:@" " account:@"uuid"];
    
    if (uuid.length > 0) {
        //得到
        NSLog(@"得到UUID：%@", uuid);
        
    } else {
        //没有得到
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        uuid = currentDeviceUUID.UUIDString;
        uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
        uuid = [uuid lowercaseString];
        
        if ([YYKeychain setPassword:uuid forService:@" " account:@"uuid"]) {
            NSLog(@"UUID:%@ 保存成功", uuid);
        } else {
            NSLog(@"UUID：%@保存失败", uuid);
        }
    }
    return uuid;
}

+ (void)endEditing {
    [[Tool shareInstance] endEditing];
}

- (void)endEditing {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


+ (void)configWithKeyBoard {
    
    [[Tool shareInstance] configWithKeyBoard];
}

- (void)configWithKeyBoard {
    
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    
//    [manager setToolbarManageBehaviour:IQAutoToolbarByPosition];//最新版的设置键盘的returnKey的关键字 ,可以点击键盘上的next键，自动跳转到下一个输入框，最后一个输入框点击完成，自动收起键盘。
//    
//    manager.shouldResignOnTouchOutside =YES; // 控制点击背景是否收起键盘
//    
//    //    manager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
//    
//    [manager setToolbarTintColor:kNormalColor];
//    
//    manager.enableAutoToolbar =YES; // 控制是否显示键盘上的工具条
    
    //在需要使用的界面设置
    //    IQKeyboardReturnKeyHandler *retuenKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    //    retuenKeyHandler.lastTextFieldReturnKeyType =UIReturnKeyDone; // 设置最后一个输入框的ReturnKey关键字
}

@end
