//
//  BooksListLayout.h
//  Novel
//
//  Created by th on 2017/2/8.
//  Copyright © 2017年 th. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BooksListModel.h"

#define BooksListTitleFont 16 //title字体大小
#define BooksListOtherFont 13 //other字体大小
#define BooksListGray [UIColor lightGrayColor]
#define BooksListNormalColor [UIColor colorWithRed:0.37 green:0.37 blue:0.37 alpha:1.00]

@interface BooksListLayout : NSObject

/** cell高度 */
@property (nonatomic, assign) CGFloat height;

/** 内容高度 */
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, strong) YYTextLayout *titleLayout;

@property (nonatomic, strong) YYTextLayout *authorAndCatLayout;

@property (nonatomic, strong) YYTextLayout *shortIntroLayout;

@property (nonatomic, strong) YYTextLayout *followerAndRetentionLayout;

//model
@property (nonatomic, strong) BooksListItemModel *model;

/** 开始计算布局 */
- (instancetype)initWithLayout:(BooksListItemModel *)model;

@end
