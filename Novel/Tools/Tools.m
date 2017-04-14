//
//  Tools.m
//  EHealth_HM
//
//  Created by skusdk on 13-10-12.
//  Copyright (c) 2013年 dengwz. All rights reserved.
//

#import "Tools.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "ReachabilityTool.h"


@implementation Tools

+(BOOL)IS_IOS_7{
    return kSystemVersion > 6.2;
}

+(BOOL)IS_IOS_8{
    return kSystemVersion > 7.9;
}

//根据型号判断返回的图片
+(NSString *)imageByDeviceWithImage:(NSString *)image{
    
    if ([Tools IS_IOS_8]) {
        return [NSString stringWithFormat:@"%@@3x",image];
    }
    else{
        return [NSString stringWithFormat:@"%@@2x",image];
    }
}


+(float)getMainHeight{
    if ([Tools IS_IOS_8]){
        return kScreenHeight;
    
    }else{
        return kScreenWidth;
    }

}
+(float)getMainWidth{
    if ([Tools IS_IOS_8]){
        return kScreenWidth;
        
    }else{
        return kScreenHeight;
    }
}

+(BOOL)IS_iPhone_568h{
    return kScreenHeight > 480;
}

#pragma makr - 是否第一次打开app
+(BOOL)isFirstOpenApp{
    
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

#pragma mark - 拨打电话
+ (void)dialPhoneNumber:(NSString *)phoneNum{

    if (![RegExpValidate validateMobile:phoneNum] && ![RegExpValidate validatePhoneNumber:phoneNum]) {
        [SVProgressHUD showErrorWithStatus:@"号码不正确！"];
        return;
    }
    UIWebView *phoneCallWebView = nil;
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

#pragma makr - 保存当前用户的账号和密码
+ (void)saveCurUserAccount:(NSString *)account password:(NSString *)password
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:account forKey:@"account"];
    [userDef setObject:password forKey:@"password"];
    [userDef synchronize];
}
+ (void)cleanPassword:(BOOL)cleanPassword account:(BOOL)cleanAccount{

    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    if (cleanPassword) {
        
        [userDef setObject:nil forKey:@"password"];
    }
    if (cleanAccount) {
        
        [userDef setObject:nil forKey:@"account"];
    }
    [userDef synchronize];
}

#pragma mark - 用户当前的账号
+ (NSString *)getCurAccount{
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *account = [userDef objectForKey:@"account"];
    if (account) {
        
        return account;
    }
    else{
        return @"";
    }
}
#pragma mark - 用户当前的密码
+ (NSString *)getCurPassword{
  
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *password = [userDef objectForKey:@"password"];
    if (password) {
        return password;
    }
    else{
        return @"";
    }
}

#pragma mark - 获取app版本
+(NSString*)getSoftVersion{
    return [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
}

#pragma mark -
#pragma mark - 读取本地的txt格式json数据 并解析返回字典
+(NSDictionary *)readFileJsonFileName:(NSString *)fileName{
  
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString * jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return [Tools DeserializeJson:jsonString];
}

#pragma mark - 字典序列化成字符串
+(NSString *)SerializationJson:(NSDictionary *)dictionary
{
    if([NSJSONSerialization isValidJSONObject:dictionary]){
        NSError *error;
        NSData *dictionaryData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"SerialixationJson>>%@",error);
        return [[NSString alloc]initWithData:dictionaryData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark - json反序列化方法
+(NSDictionary*)DeserializeJson:(NSString *)json
{
    if(json != nil){
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]options:kNilOptions error:&error];
//        NSLog(@"DeserializeJson>>%@",error);
//        NSLog(@"dictionary>>%@",dictionary);
        return dictionary;
    }
    return nil;
}

#pragma mark - 取得wifi名
+ (NSString *)getWifiName{
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


+(UIViewController *)FindSpecificViewController:(NSArray *)navControllers outViewController:(Class)outViewController{
    
    if(navControllers == nil){
        return nil;
    }
    UIViewController *outController = nil;
    for(UIViewController *controoler in navControllers){
        
        if([controoler isKindOfClass:outViewController]){
            outController = controoler;
            break;
        }
    }
    return outController;
}

#pragma mark - 打开网络状态监控
+ (void)openNetworkMonitoring{
    
    [[ReachabilityTool defatueReachabilityTool] starCheckingNetwork];
}

#pragma mark - 获取网络状态
+ (BOOL)getNetworkStatus{
    
   return [ReachabilityTool defatueReachabilityTool].hasNetWorking;
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 获取缓存大小
//遍历文件夹获得文件夹大小，返回多少M
+ (void)requestCachesFileSize:(void (^)(NSString *))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSString *folderPath = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"];
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
                folderSize += [Tools fileSizeAtPath:fileAbsolutePath];
            }
            float sizeM = folderSize/(1024.0*1024.0);
            
            if (sizeM < 1) {
                
                int size = (int)1024 * sizeM;
                
                sizeStr = [NSString stringWithFormat:@"%d k",size];
            }
            else{
                sizeStr = [NSString stringWithFormat:@"%0.2f M",sizeM];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                completion(sizeStr);
            });
        }
    });
}

#pragma mark -清理缓存
+(void)clearCache:(void (^)(BOOL))completion{
    
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

+ (NSString *) getStringWithViewport:(NSString *) html{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"jsp"];
    NSString *path2 = [[NSBundle mainBundle]pathForResource:@"thelasttest" ofType:@"jsp"];
    //    NSString *_rememberWebString = [_data.recite stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSString * path1_strd = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString * path2_strd = [NSString stringWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:nil];
    NSString * strd = [NSString stringWithFormat:@"%@%@%@",path1_strd,html,path2_strd];
    return strd;
    
}

#pragma mark - 将字典，数组写到沙盒
+ (NSString *)writeToDocumentsWithDataSource:(id)dataSource FileName:(NSString *)fileName {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
//    NSString *path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),fileName];
        NSLog(@"path:%@",path);
    //得到完整的文件名
    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    // 写入本地
    if ([dataSource isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)dataSource;
        [array writeToFile:filename atomically:YES];
        return path;
    }
    if ([dataSource isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)dataSource;
        [dict writeToFile:filename atomically:YES];
        
        return path;
    }
    
    return @"";
}

+ (NSArray *)readFromDocumentWithFileName:(NSString *)fileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    return [NSArray arrayWithContentsOfFile:filename];
}


@end
