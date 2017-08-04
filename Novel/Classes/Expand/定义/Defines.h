//
//  Defines.h
//  Novel
//
//  Created by th on 2017/1/31.
//  Copyright © 2017年 th. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifndef Defines_h
#define Defines_h

#define NotificationWithChangeBg @"NotificationWithChangeBg"

#define NotificationWithChangeBgSelect @"NotificationWithChangeBgSelect"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(kScreenWidth, kScreenHeight))
#define SCREEN_MIN_LENGTH (MIN(kScreenWidth, kScreenHeight))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

typedef NS_ENUM(int, kTextType) {
    kText_normal = 800,
    kText_bold
    
};

//释放
#define kDealloc(objc) objc = nil;
//通知是否释放内存了
static NSString *const notiDealloc    = @"notificationDealloc";

/*************************
 序列化和反序列化
 *************************/
#define YYModelSynthCoderAndHash \
- (void)encodeWithCoder:(NSCoder *)aCoder { [self modelEncodeWithCoder:aCoder]; } \
- (id)initWithCoder:(NSCoder *)aDecoder { return [self modelInitWithCoder:aDecoder]; } \
- (id)copyWithZone:(NSZone *)zone { return [self modelCopy]; } \
- (NSUInteger)hash { return [self modelHash]; } \
- (BOOL)isEqual:(id)object { return [self modelIsEqual:object]; }

#endif /* Defines_h */
