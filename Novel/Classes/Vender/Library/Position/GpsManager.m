//
//  GpsManager.m
//  PoorChat
//
//  Created by 胖妞 on 16/5/24.
//  Copyright © 2016年 优一. All rights reserved.
//

#import "GpsManager.h"
#import <UIKit/UIKit.h>

@implementation GpsManager
/**
 *  初始化返回一个对象
 */
+ (id) sharedGpsManager {
    
    static id s;
    
    if (s == nil) {
        s = [[GpsManager alloc] init];
    }
    return s;
}


- (instancetype)init {
    
    self = [super init];
    
    if (self)
    {
        // 打开定位 然后得到数据
        GpsM = [[CLLocationManager alloc] init];
        GpsM.delegate = self;
        GpsM.desiredAccuracy = kCLLocationAccuracyBest;//性能最好的，但是耗电
        // 兼容iOS8.0版本
        /* Info.plist里面加上2项
         NSLocationAlwaysUsageDescription      Boolean YES
         NSLocationWhenInUseUsageDescription   Boolean YES
         */
        
        // 请求授权 requestWhenInUseAuthorization用在>=iOS8.0上
        // respondsToSelector: 前面manager是否有后面requestWhenInUseAuthorization方法
        // 1. 适配 动态适配
        if ([GpsM respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [GpsM requestWhenInUseAuthorization];
            [GpsM requestAlwaysAuthorization];
        }
        // 2. 另外一种适配 systemVersion 有可能是 8.1.1
        float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (osVersion >= 8)
        {
            [GpsM requestWhenInUseAuthorization];
            [GpsM requestAlwaysAuthorization];
        }
    }
    return self;
}

- (void) getGps:(  void (^)(double lat, double lng) )cb {
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        return;
    }
    // block一般赋值需要copy
    getGpsBlock = [cb copy];
    
    // 停止上一次的
    [GpsM stopUpdatingLocation];
    // 开始新的数据定位
    [GpsM startUpdatingLocation];
}

+ (void) getGps:(  void (^)(double lat, double lng) )cb {
    
    [[GpsManager sharedGpsManager] getGps:cb];
}
//检测定位是否可用
- (void)checkPosition:(void (^)(BOOL isPosition))check {
    
    if ([CLLocationManager locationServicesEnabled] == YES) {//locationServicesEnabled是检测系统定位是否开启，不是应用定位权限
        
        checkGpsBlock = [check copy];
        
        if (checkGpsBlock) {
            
            checkGpsBlock (YES);
        }
    } else {//不能定位
        checkGpsBlock = [check copy];
        
        if (checkGpsBlock) {
            
            checkGpsBlock (NO);
        }
    }
}
+ (void)checkPosition:(void (^)(BOOL isPosition))check {
    
    [[GpsManager sharedGpsManager] checkPosition:check];
}

//获取城市名称
- (void) getCityName:(void(^)(NSString *cityName))cb {
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        return;
    }
    // block一般赋值需要copy
    getCityName = [cb copy];
    
    // 停止上一次的
    [GpsM stopUpdatingLocation];
    // 开始新的数据定位
    [GpsM startUpdatingLocation];
}

+ (void) getCityName:(void(^)(NSString *cityName))cb {
    
    [[GpsManager sharedGpsManager] getCityName:cb];
}

 //下面是每隔一段时间就会调用的
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    void(^getCity)(NSString *city) = ^(NSString *city) {
        if (city) {
            
            //去掉‘市’字，因为接口会报错
            city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
            
            getCityName(city);
        }
    };
    
    for (CLLocation *currentLocation in locations)
    {
        CLLocationCoordinate2D l = currentLocation.coordinate;
        double lat = l.latitude;
        double lnt = l.longitude;
        
        // 使用blocks 调用blocks
        if (getGpsBlock) {
            getGpsBlock(lat, lnt);
        }
        
        CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
        
        //反编码
        [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (placemarks.count > 0) {
                CLPlacemark *placeMark = [placemarks firstObject];
                NSString *currentCity = placeMark.locality;
                if (!currentCity) {
                    currentCity = @"无法获取当前位置";
                    getCity(currentCity);
                } else {
                    getCity(currentCity);
                }
                //            NSLog(@"%@",currentCity); //这就是当前的城市
                //            NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
            } else if (error) {
                getCity(NSStringFormat(@"%@",error));
            }
            
        }];
    }
}

- (void) stop {
    [GpsM stopUpdatingLocation];
}

+ (void) stop {
    
    [[GpsManager sharedGpsManager] stop];
}

#pragma mark - 检测应用是否有定位权限

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // 不能定位位置----需要告诉告诉用户联网-提醒用户打开定位开关
    [self alertOpenLocationSwitch];
}

- (void)alertOpenLocationSwitch
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在隐私设置中打开定位开关" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
