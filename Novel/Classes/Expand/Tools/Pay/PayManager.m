//
//  PayManager.m
//  支付
//
//  Created by th on 2017/4/18.
//  Copyright © 2017年 th. All rights reserved.
//

#import "PayManager.h"
#import <UIKit/UIKit.h>

// 回调url地址为空
#define payTip_CallBackURL @"url地址不能为空！"

// 订单信息为空字符串或者为nil
#define payTip_OrderMessage @"订单信息不能为空！"

// 没添加 URL Types
#define payTip_URLType @"请先在Info.plist 添加 URL Type"

// 添加了 URL Types 但是信息不全
#define payTip_URLTypes_Scheme(name) [NSString stringWithFormat:@"请先在Info.plist 的 URL Type 添加 %@ 对应的 URL Scheme",name]

@interface PayManager() <WXApiDelegate>

// 缓存回调
@property (nonatomic, copy) Pay_ComleteCallBlock callBack;

// 缓存appScheme
@property (nonatomic, strong) NSMutableDictionary *appSchemeDict;

@end

@implementation PayManager

+ (instancetype)shareManager {
    
    static PayManager *instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

/*
 返回码	含义
 9000	订单支付成功
 8000	正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 4000	订单支付失败
 6001	用户中途取消
 6002	网络连接出错
 6004	支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 其它	其它支付错误
 */

- (BOOL)pay_handleUrl:(NSURL *)url {
    
    NSAssert(url, payTip_CallBackURL);
    
    if ([url.host isEqualToString:@"pay"]) { // 微信
        
        return [WXApi handleOpenURL:url delegate:self];
        
    } else if ([url.host isEqualToString:@"safepay"]) { // 支付宝
        // 支付宝跳转支付宝钱包支付，处理支付结果(在app被杀模式下，通过这个方法获取支付结果）
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSString *resultStatus = resultDic[@"resultStatus"];
            
            NSString *errStr = resultDic[@"memo"];
            
            PayErrorCode errorCode = PayErrorCodeSuccess;
            
            switch (resultStatus.integerValue) {
                case 9000: // 成功
                    
                    errorCode = PayErrorCodeSuccess;
                    
                    break;
                    
                case 6001: // 取消
                    
                    errorCode = PayErrorCodeCancel;
                    
                    break;
                    
                default: // 失败
                    
                    errorCode = PayErrorCodeFailure;
                    
                    break;
            }
            
            if ([PayManager shareManager].callBack) {
                [PayManager shareManager].callBack(errorCode,errStr);
            }
            
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            
            NSLog(@"result = %@", resultDic);
            
            NSString *result = resultDic[@"result"];
            
            NSString *authCode = nil;
            
            if (result.length > 0) {
                
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
                
                NSLog(@"授权结果 authCode = %@", authCode ? : @"");
            }
            
        }];
        
        return YES;
        
    } else {
        return NO;
    }
}

- (void)pay_registerApp {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *urlTypes = dict[@"CFBundleURLTypes"];
    
    NSAssert(urlTypes, payTip_URLType);
    
    for (NSDictionary *urlTypeDict in urlTypes) {
        
        NSString *urlName = urlTypeDict[@"CFBundleURLName"];
        
        NSArray *urlSchemes = urlTypeDict[@"CFBundleURLSchemes"];
        
        NSAssert(urlSchemes.count, payTip_URLTypes_Scheme(urlName));
        
        // 一般对应只有一个
        NSString *urlScheme = urlSchemes.lastObject;
        
        if ([urlName isEqualToString:WechatURLName]) {
            [self.appSchemeDict setValue:urlScheme forKey:WechatURLName];
            // 注册微信
            [WXApi registerApp:urlScheme];
        }
        else if ([urlName isEqualToString:AlipayURLName]){
            // 保存支付宝scheme，以便发起支付使用
            [self.appSchemeDict setValue:urlScheme forKey:AlipayURLName];
        }
        else{
            
        }
    }
    
}
/*
 返回码	含义
 9000	订单支付成功
 8000	正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 4000	订单支付失败
 6001	用户中途取消
 6002	网络连接出错
 6004	支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
 其它	其它支付错误
 */
- (void)payWithOrderMessage:(id)orderMessage callBack:(Pay_ComleteCallBlock)callBack {
    
    // 缓存block
    self.callBack = callBack;
    
    // 发起支付
    if ([orderMessage isKindOfClass:[PayReq class]]) { // 微信
        
        NSAssert(WechatURLName, payTip_URLTypes_Scheme(WechatURLName));
        
        [WXApi sendReq:(PayReq *)orderMessage];
        
    } else if ([orderMessage isKindOfClass:[NSString class]]) { // 支付宝
        
        NSAssert(![orderMessage isEqualToString:@""], payTip_OrderMessage);
        NSAssert(self.appSchemeDict[AlipayURLName], payTip_URLTypes_Scheme(AlipayURLName));
        
        [[AlipaySDK defaultService] payOrder:(NSString *)orderMessage fromScheme:self.appSchemeDict[AlipayURLName] callback:^(NSDictionary *resultDic){
            
            NSString *resultStatus = resultDic[@"resultStatus"];
            
            NSLog(@"------%@", [resultDic descriptionWithLocale:nil]);
            
            NSString *errStr = resultDic[@"memo"];
            
            PayErrorCode errorCode = PayErrorCodeSuccess;
            
            switch (resultStatus.integerValue) {
                case 9000:// 成功
                    errorCode = PayErrorCodeSuccess;
                    break;
                case 6001:// 取消
                    errorCode = PayErrorCodeCancel;
                    break;
                default:
                    errorCode = PayErrorCodeFailure;
                    break;
            }
            
            if ([PayManager shareManager].callBack) {
                
                [PayManager shareManager].callBack(errorCode,errStr);
            }
        }];
        
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    // 判断支付类型
    if([resp isKindOfClass:[PayResp class]]){
        //支付回调
        PayErrorCode errorCode = PayErrorCodeSuccess;
        
//        NSString *errStr = resp.errStr;
        NSString *errStr = nil;
        
        switch (resp.errCode) {
            case 0:
                errorCode = PayErrorCodeSuccess;
                errStr = @"订单支付成功";
                break;
            case -1:
                errorCode = PayErrorCodeFailure;
                errStr = resp.errStr;
                break;
            case -2:
                errorCode = PayErrorCodeCancel;
                errStr = @"用户中途取消";
                break;
            default:
                errorCode = PayErrorCodeFailure;
                errStr = resp.errStr;
                break;
        }
        if (self.callBack) {
            self.callBack(errorCode,errStr);
        }
    }
}

#pragma mark -- Setter & Getter

- (NSMutableDictionary *)appSchemeDict{
    if (_appSchemeDict == nil) {
        _appSchemeDict = [NSMutableDictionary dictionary];
    }
    return _appSchemeDict;
}

@end
