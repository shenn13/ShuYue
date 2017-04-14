//
//  ReadingManager.h
//  Novel
//
//  Created by th on 2017/2/20.
//  Copyright © 2017年 th. All rights reserved.
//

#define kReadFont 14

#import <Foundation/Foundation.h>
#import "BookChapterModel.h"
#import "SummaryModel.h"

@interface ReadingManager : NSObject

/** 初始化单例 */
+ (instancetype)shareReadingManager;

/** 目录数组 */
@property (nonatomic, strong) NSArray *chapters;

/** 小说title */
@property (nonatomic, copy) NSString *title;

/** 书籍id */
@property (nonatomic, copy) NSString *bookId;

/** 源id */
@property (nonatomic, copy) NSString *summaryId;

/** 记录当前第n章 */
@property (nonatomic, assign) NSInteger chapter;

/** 记录在当前章节中读到第n页 */
@property (nonatomic, assign) NSInteger page;

/** 在applicationDidEnterBackground程序退出时判断是否需要存储 */
@property (nonatomic, assign) BOOL isSave;

/** 预下载n章 */
@property (nonatomic, assign) NSInteger downlownNumber;

@property (nonatomic, copy) NSString *autoSummaryId;

- (void)clear;

/**
 请求源
 */
- (void)updateWithSummary:(NSString *)bookId completion:(void(^)())completion failure:(void(^)(NSString *error))failure;


/**
 异步请求目录数组

 @param bookId book's id
 @param completion 完成block
 @param failure 失败block
 */
- (void)onloadChaptersWithId:(NSString *)summaryId completion:(void(^)())completion failure:(void(^)(NSString *error))failure;

/**
 异步请求章节内容

 @param link 链接
 @param completion 完成block
 @param failure 失败block
 */
- (void)updateWithChapterAsync:(NSUInteger)chapter ispreChapter:(BOOL)ispreChapter completion:(void(^)())completion failure:(void(^)(NSString *error))failure;

/**
 同步请求章节内容
 */
- (void)updateWithChapterSync:(NSUInteger)chapter ispreChapter:(BOOL)ispreChapter completion:(void(^)())completion failure:(void(^)(NSString *error))failure;

/**
 预缓存章节
 */
- (void)downLoadChapterWithNumber:(NSInteger)number;

@end
