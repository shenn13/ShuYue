//
//  PayManager.h
//  支付
//
//  Created by th on 2017/4/18.
//  Copyright © 2017年 th. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

/**
 此处必须保证在 info.plist 中的 URL Types 的 Identifier 对应一致
 zhifubao  URL Schemes 为APP的唯一标识，返回app的时候调用
 weixin URL Schemes 是微信开放平台申请到的 app id
 */
#define WechatURLName @"weixin"
#define AlipayURLName @"zhifubao"

#define KPayManager [PayManager shareManager]


/**
 回调状态吗
 */
typedef NS_ENUM(NSInteger, PayErrorCode) {
    PayErrorCodeSuccess, //成功
    PayErrorCodeFailure, //失败
    PayErrorCodeCancel //取消
};

typedef  void(^Pay_ComleteCallBlock)(PayErrorCode errCode, NSString *errStr);

@interface PayManager : NSObject

/**
 单例管理
 */
+ (instancetype)shareManager;


/**
 处理跳转URL，回到应用，需要在delegate中实现

 @param url url
 @return bool
 */
- (BOOL)pay_handleUrl:(NSURL *)url;

/**
 注册App，需要在didFinishLaunchingWithOptions中调用
 */
- (void)pay_registerApp;

/**
 发起支付

 @param orderMessage 传入订单信息,如果是字符串，则对应是跳转支付宝支付；如果传入PayReq 对象，这跳转微信支付,注意，不能传入空字符串或者nil
 @param callBack 回调，有返回状态信息
 */
- (void)payWithOrderMessage:(id)orderMessage callBack:(Pay_ComleteCallBlock)callBack;


@end
