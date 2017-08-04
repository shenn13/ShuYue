//
//  BaseViewController.h
//  Novel
//
//  Created by xth on 2017/7/15.
//  Copyright © 2017年 th. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"

/**
 *  根视图控制器类，一切普通视图控制器都继承此类。
 */
@interface BaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/** 分页 */
@property (nonatomic, assign) int page;

@property (nonatomic, strong) BaseTableView *tableView;

- (void)initializeWithTableViewFrame:(CGRect)frame style:(UITableViewStyle)style;

/** < 释放 > */
-(void)oDealloc;

/** < 网络请求> */
-(void)onLoadDataByRequest;

/** < 加载视图> */
-(void)onLoadViewByViewDidLoad;

/** 返回事件 */
- (void)go2Back;

/** 需要添加定义左边按钮的直接在UIViewController+Tool 的 - (UIButton *)addLeftBarButtonItemImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color; 添加即可*/
//@property (nonatomic, copy) void(^requestSuccessBlock)(id responseObject);

/**
 请求成功后的处理
 
 @param responseObject responseObject
 @param clas model class
 @param alertStr 后备提示
 @param isAlert 是否提示
 @param complete obj
 */
- (void)requestSuccessWithResponeObj:(id)responseObject modelClass:(id)clas alertStr:(NSString *)alertStr isAlert:(BOOL)isAlert complete:(void (^)(id obj))complete;

/** 请求错误页面停止刷新 */
- (void)showEmptyWithStr:(NSString *)str;

@end

#pragma mark - UITableViewController

@interface BaseTableViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
/** < 释放 > */
-(void)oDealloc;

/** < 加载视图 > */
-(void)onLoadViewByViewDidLoad;

/** < 网络请求 > */
-(void)onLoadDataByRequest;

/** 页数 */
@property (nonatomic, assign) int page;

/** 返回事件 */
- (void)go2Back;

/** 请求错误页面停止刷新 */
- (void)showEmptyWithStr:(NSString *)str;

/**
 请求成功后的处理
 
 @param responseObject responseObject
 @param clas model class
 @param alertStr 后备提示
 @param isAlert 是否提示
 @param complete obj
 */
- (void)requestSuccessWithResponeObj:(id)responseObject modelClass:(id)clas alertStr:(NSString *)alertStr isAlert:(BOOL)isAlert complete:(void (^)(id obj))complete;

@end

#pragma mark - UICollectionViewController

@interface BaseCollectionViewController : UICollectionViewController
/** < 释放 > */
-(void)oDealloc;

/** < 加载视图 > */
-(void)onLoadViewByViewDidLoad;

/** < 网络请求 > */
-(void)onLoadDataByRequest;

/** 返回事件 */
- (void)go2Back;

@end
