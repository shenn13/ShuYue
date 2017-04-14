
//  ViewController4.h
//  测试
//
//  Created by 李李善 on 16/7/30.
//  Copyright © 2016年 李李善. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseTableView.h"

#pragma mark - UIViewController

/**
 *  根视图控制器类，一切普通视图控制器都继承此类。
 */
@interface BaseViewController : UIViewController

/** < 释放 > */
-(void)oDealloc;

/** < 加载动画 > */
-(void)onLoadAnimatedByDidAppear;

/** < 加载视图 > */
-(void)onLoadViewByWillAppear;

/** < 网络请求 > */
-(void)onLoadDataByRequest;


@property(nonatomic ,assign)BOOL isPresent;

@end

#pragma mark - UITableViewController

@interface BaseTableViewController : UITableViewController
/** < 释放 > */
-(void)oDealloc;
/** < 加载动画 > */
-(void)onLoadAnimatedByDidAppear;

/** < 加载视图 > */
-(void)onLoadViewByWillAppear;

/** < 网络请求 > */
-(void)onLoadDataByRequest;

/** 页数 */
@property (nonatomic, assign) int page;


@end

#pragma mark - UICollectionViewController

@interface BaseCollectionViewController : UICollectionViewController
/** < 释放 > */
-(void)oDealloc;

/** < 加载动画 > */
-(void)onLoadAnimatedByDidAppear;

/** < 加载视图 > */
-(void)onLoadViewByWillAppear;

/** < 网络请求 > */
-(void)onLoadDataByRequest;



@end
