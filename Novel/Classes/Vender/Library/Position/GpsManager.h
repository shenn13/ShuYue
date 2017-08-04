//
//  GpsManager.h
//  PoorChat
//
//  Created by 胖妞 on 16/5/24.
//  Copyright © 2016年 优一. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface GpsManager : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *GpsM;
    
    // 获取维度和经度
    void (^getGpsBlock) (double lat, double lng);
    
    // 获取当前位置的城市名称
    void (^getCityName) (NSString *cityName);
    
    //判断设备是否开启了定位
    void (^checkGpsBlock) (BOOL isPosition);
}

//检测系统定位是否开启，不是应用定位权限
+ (void)checkPosition:(void (^)(BOOL isPosition))check;

// 值获取一次定位  lat 维度 lng 经度
+ (void) getGps:(  void (^)(double lat, double lng) )cb;

//获取城市名称
+ (void) getCityName:(void(^)(NSString *cityName))cb;

+ (void) stop;


@end


/*

 调用方式:
 //只获取一次定位
 __block  BOOL isOnece = YES;
 [GpsManager getGpsBlock:^(double lat, double lng) {
 isOnece = NO;
 
 //只打印一次经纬度
 NSLog(@"lat lng (%f, %f)", lat, lng);
 
 if (!isOnece) {
 [GpsManager stop];
 }
 }];
 
 //如果要一直持续获取定位则
 [GpsManager getGpsBlock:^(double lat, double lng) {
 
 //不断的打印经纬度
 NSLog(@"lat lng (%f, %f)", lat, lng);
 }];

*/
