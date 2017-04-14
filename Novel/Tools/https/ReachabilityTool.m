//
//  ReachabilityTool.m
//  BeautyExperience
//
//  Created by ZhouZhenFu on 15/11/16.
//  Copyright © 2015年 tr. All rights reserved.
//

#import "ReachabilityTool.h"

@implementation ReachabilityTool

+ (ReachabilityTool *)defatueReachabilityTool
{
    static id tool = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        
        tool = [[ReachabilityTool alloc]init];
    });
    return tool;
}


#pragma mark- 检测网络状态

+ (BOOL)getNetworkStatus{
    return [ReachabilityTool defatueReachabilityTool].hasNetWorking;
}


// 检测网络状态
- (void)starCheckingNetwork {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [reach startNotifier];
    
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable) {
        _hasNetWorking = YES;
    } else {
        _hasNetWorking = NO;
    }
}

// 处理事件
- (void)reachabilityChanged:(NSNotification *)notification {
    Reachability *reach = [notification object];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        
        [SVProgressHUD showErrorWithStatus:@"亲的网络不太稳定哦！"];
        _hasNetWorking = NO;
    } else {
        _hasNetWorking = YES;
    }
    // 此处还可检测当前是否处于WiFi和3G/4G网络
}


@end
