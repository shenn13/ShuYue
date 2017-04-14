//
//  ReachabilityTool.h
//  BeautyExperience
//
//  Created by ZhouZhenFu on 15/11/16.
//  Copyright © 2015年 tr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

//网络检测
@interface ReachabilityTool : NSObject

/** 是否有网络 */
@property (assign, nonatomic) BOOL hasNetWorking;

+ (ReachabilityTool *)defatueReachabilityTool;

- (void)starCheckingNetwork;

@end
